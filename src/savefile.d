/*
 * Copyright (c) 2015-2020 Philip Pavlick.  See '3rdparty.txt' for other
 * licenses.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *  * Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *  * Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *  * Neither the name of the SwashRL project nor the names of its
 *    contributors may be used to endorse or promote products derived from
 *    this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

// savefile.d:  Functions for reading and writing dungeon level files

import global;

import std.stdio;
import std.format;
import std.file;
import std.exception : basicExceptionCtors;

// SECTION 0: ////////////////////////////////////////////////////////////////
// Exceptions & Error Handling                                              //
//////////////////////////////////////////////////////////////////////////////

// An exception for invalid save file access.
class SaveFileException : Exception
{
  mixin basicExceptionCtors;
}

// An exception for invalid dungeon level file access.
class DungeonFileException : Exception
{
  mixin basicExceptionCtors;
}

// Throws a SaveFileException.
void save_error( T... )( string file, T args )
{
  throw new SaveFileException( format( "Unable to access save file %s: %s",
                                       file, format( args ) ) );
}

// Throws a DungeonFileException.
void level_file_error( T... )( string dungeon_file, T args )
{
  throw new DungeonFileException(
    format( "Unable to read dungeon level file %s: %s",
    dungeon_file, format( args ) ) );
}

// SECTION 1: ////////////////////////////////////////////////////////////////
// Saving to a File                                                         //
//////////////////////////////////////////////////////////////////////////////

// Saves a level to a file.
void save_level( T... )( Map m, Player u, T args )
{
  File fil;
  string path = format( "save/lev/%s.lev", format( args ) );

  mkdirRecurse( "save/lev" );

  if( exists( path ) && !isFile( path ) )
  {
    level_file_error( path,
                      "This file name points to a directory or symlink" );
  }

  try
  {
    fil = File( path, "w" );
  }
  catch( FileException e )
  {
    level_file_error( path, e.msg );
  }

  // First things first: Output the version number so that we can determine
  // level file compatibility:
  string ver = format( "%.3f", VERSION );
  fil.writeln( VERSION );

  // We start by recording all of the tiles on the map:

  // Leave a marker indicating we're starting tile recording:
  fil.writeln( cast(char)20 );

  foreach( y; 0 .. MAP_Y )
  {
    foreach( x; 0 .. MAP_X )
    {
      Tile t = m.t[y][x];

      // Each tile has a symbol...
      Symbol s = t.sym;

      char ch = s.ch;
      fil.writeln( ch );

      // Each symbol has a Color_Pair...
      Color_Pair c = s.color;

      // Each Color_Pair has a short and two booleans...
      short curses_color_pair = c.get_color_pair();
      bool bold = c.get_bright(), inverted = c.get_inverted();

      fil.writeln( curses_color_pair );
      fil.writeln( bold );
      fil.writeln( inverted );

      // Each tile also has a series of booleans:
      bool block_c = t.block_cardinal_movement,
           block_d = t.block_diagonal_movement,
           block_v = t.block_vision,
           lit = t.lit, seen = t.seen;
      fil.writeln( block_c );
      fil.writeln( block_d );
      fil.writeln( block_v );
      fil.writeln( lit );
      fil.writeln( seen );

      uint hazard = t.hazard;
      fil.writeln( hazard );

      // We're done with this tile.
    } // foreach( x; 0 .. MAP_X )
  } // foreach( y; 0 .. MAP_Y )

  // Leave a marker indicating that we're finishing tile output and starting
  // items:
  fil.writeln( cast(char)20 );

  // Start writing items:
  foreach( y; 0 .. MAP_Y )
  {
    foreach( x; 0 .. MAP_X )
    {
      Item i = m.i[y][x];

      // Every item has a symbol:
      Symbol s = i.sym;

      // Unlike with the tiles, if the symbol's character is equal to '\0' we
      // actually just output a marker and then continue, because that
      // indicates that there's no item there.
      if( s.ch == '\0' )
      {
        fil.writeln( cast(char)19 );
        continue;
      }

      // Otherwise, we treat this symbol much like the tile's symbol:

      char ch = s.ch;
      fil.writeln( ch );

      Color_Pair c = s.color;

      short curses_color_pair = c.get_color_pair();
      bool bold = c.get_bright(), inverted = c.get_inverted();

      fil.writeln( curses_color_pair );
      fil.writeln( bold );
      fil.writeln( inverted );

      // Each item has a name...
      string name = i.name;
      fil.writeln( name );

      uint type = i.type, equip = i.equip;
      fil.writeln( type );
      fil.writeln( equip );

      int addd = i.addd, addm = i.addm;
      fil.writeln( addd );
      fil.writeln( addm );

      // We're done with the item.
    } // foreach( x; 0 .. MAP_X )
  } // foreach( y; 0 .. MAP_Y )

  // Leave a marker indicating that we're done with items and now are
  // outputting monsters
  fil.writeln( cast(char)20 );

  // Start writing monsters:
  foreach( n; 0 .. m.m.length )
  {
    Monst mn = m.m[n];

    // If the monster has no hit points, skip it... dead monsters aren't worth
    // recording.
    if( mn.hp <= 0 )
    { continue;
    }

    // Every monster has--you guessed it!  A symbol!
    Symbol s = mn.sym;

    char ch = s.ch;
    fil.writeln( ch );

    Color_Pair c = s.color;

    short curses_color_pair = c.get_color_pair();
    bool bold = c.get_bright(), inverted = c.get_inverted();

    fil.writeln( curses_color_pair );
    fil.writeln( bold );
    fil.writeln( inverted );

    // Every monster has a string...
    string name = mn.name;
    fil.writeln( name );

    int hp = mn.hp;
    fil.writeln( hp );

    uint fly = mn.fly, swim = mn.swim, x = mn.x, y = mn.y;
    fil.writeln( fly );
    fil.writeln( swim );
    fil.writeln( x );
    fil.writeln( y );

    // Every monster has a dicebag...
    Dicebag db = mn.attack_roll;

    uint di = db.dice;
    fil.writeln( di );

    int modifier = db.modifier;
    fil.writeln( modifier );

    int floor = db.floor, ceiling = db.ceiling;
    fil.writeln( floor );
    fil.writeln( ceiling );

    // We're done with the monster.
  } // foreach( n; 0 .. m.m.length )

  // Leave a marker indicating that we're done with outputting monsters
  fil.writeln( cast(char)20 );

  // Finally, we output the coordinates that the player character is standing
  // at.
  ubyte x = u.x, y = u.y;

  fil.writeln( x );
  fil.writeln( y );

  // We're done.
  fil.close();
} // save_level( map, player, uint )

// SECTION 2: ////////////////////////////////////////////////////////////////
// Loading from a Saved File                                                //
//////////////////////////////////////////////////////////////////////////////

// Get a saved level from a file.
Map level_from_file( string file_label )
{
  import std.conv;

  string path = format( "save/lev/%s.lev", file_label );

  if( !exists( path ) )
  { level_file_error( path, "File does not exist." );
  }

  if( !isFile( path ) )
  { level_file_error( path, "This is a directory or a symlink, not a file." );
  }

  File fil;

  try
  {
    fil = File( path, "r" );
  }
  catch( FileException e )
  {
    level_file_error( path, e.msg );
  }

  float ver = 0.000;

  ver = to!float( strip_line( fil ) );

  if( ver < 0.026 )
  {
    fil.close();
    level_file_error( path, "File version %.3f not compatible with current "
                      ~ "version %.3f", ver, VERSION );
  }

  char marker = '\0';

  marker = to!char( strip_line( fil ) );

  if( marker != cast(char)20 )
  {
    fil.close();
    level_file_error( path,
                  "Could not read map tiles; file not formatted correctly." );
  }

  Map m;

  foreach( y; 0 .. MAP_Y )
  {
    foreach( x; 0 .. MAP_X )
    {
      Tile t;

      char ch = '?';
      short curses_color_pair = 0;
      bool reversed = 1, bold = 1;


      ch = to!char( strip_line( fil ) );
      curses_color_pair = to!short( strip_line( fil ) );
      bold = to!bool( strip_line( fil ) );
      reversed = to!bool( strip_line( fil ) );

      t.sym.ch = ch;
      
      Color_Pair cpair = *Curses_Color_Pairs[curses_color_pair];
      if( bold ) cpair = cpair.brighten();
      if( reversed ) cpair = cpair.invert();

      t.sym.color = cpair;

      bool block_c = 1, block_d = 1, block_v = 1, lit = 0, seen = 0;

      block_c = to!bool( strip_line( fil ) );
      block_d = to!bool( strip_line( fil ) );
      block_v = to!bool( strip_line( fil ) );
      lit =     to!bool( strip_line( fil ) );
      seen =    to!bool( strip_line( fil ) );

      t.block_cardinal_movement = block_c;
      t.block_diagonal_movement = block_d;
      t.block_vision = block_v;
      t.lit = lit;
      t.seen = seen;

      uint hazard = 0;

      hazard = to!uint( strip_line( fil ) );

      t.hazard = hazard;

      m.t[y][x] = t;
    } // foreach( x; 0 .. MAP_X )
  } // foreach( y; 0 .. MAP_Y )

  marker = to!char( strip_line( fil ) );

  if( marker != cast(char)20 )
  {
    fil.close();
    level_file_error( path,
                  "Could not read items; file not formatted correctly." );
  }

  foreach( y; 0 .. MAP_Y )
  {
    foreach( x; 0 .. MAP_X )
    {
      char ch = '\0';

      ch = to!char( strip_line( fil ) );

      if( ch == cast(char)19 )
      {
        m.i[y][x] = No_item;
        continue;
      }

      Item i;

      short curses_color_pair = 0;
      bool reversed = 1, bold = 1;


      curses_color_pair = to!short( strip_line( fil ) );
      bold = to!bool( strip_line( fil ) );
      reversed = to!bool( strip_line( fil ) );

      i.sym.ch = ch;
      
      Color_Pair cpair = *Curses_Color_Pairs[curses_color_pair];
      if( bold ) cpair = cpair.brighten();
      if( reversed ) cpair = cpair.invert();

      i.sym.color = cpair;

      string name = strip_line( fil );

      i.name = name;

      uint type = 0, equip = 0;

      type = to!uint( strip_line( fil ) );
      equip = to!uint( strip_line( fil ) );

      i.type = type;
      i.equip = equip;

      int addd = 0, addm = 0;

      addd = to!int( strip_line( fil ) );
      addm = to!int( strip_line( fil ) );

      i.addd = addd;
      i.addm = addm;

      m.i[y][x] = i;
    } // foreach( x; 0 .. MAP_X )
  } // foreach( y; 0 .. MAP_Y )

  marker = to!char( strip_line( fil ) );

  if( marker != cast(char)20 )
  {
    fil.close();
    level_file_error( path,
                  "Could not read monsters; file not formatted correctly." );
  }

  char ch = '\0';
  uint count = 0;

  ch = to!char( strip_line( fil ) );

  while( ch != cast(char)20 )
  {
    if( fil.eof() )
    {
      fil.close();
      level_file_error( path, "Reached EOF before end of monster array" );
    }

    Monst mn;

    short curses_color_pair = 0;
    bool reversed = 1, bold = 1;

    curses_color_pair = to!short( strip_line( fil ) );
    bold = to!bool( strip_line( fil ) );
    reversed = to!bool( strip_line( fil ) );

    mn.sym.ch = ch;
      
    Color_Pair cpair = *Curses_Color_Pairs[curses_color_pair];
    if( bold ) cpair = cpair.brighten();
    if( reversed ) cpair = cpair.invert();

    mn.sym.color = cpair;

    string name = strip_line( fil );
 
    mn.name = name;

    int hp = 0;

    hp = to!int( strip_line( fil ) );

    mn.hp = hp;

    uint fly = 0, swim = 0;

    fly = to!uint( strip_line( fil ) );
    swim = to!uint( strip_line( fil ) );

    mn.fly = fly;
    mn.swim = swim;

    ubyte x = 0, y = 0;

    x = to!ubyte( strip_line( fil ) );
    y = to!ubyte( strip_line( fil ) );

    uint di = 0;

    di = to!uint( strip_line( fil ) );

    mn.attack_roll.dice = di;

    int modifier = 0;

    modifier = to!int( strip_line( fil ) );

    mn.attack_roll.modifier = modifier;

    int floor = 1000, ceiling = 0;

    floor = to!int( strip_line( fil ) );
    ceiling = to!int( strip_line( fil ) );

    mn.attack_roll.floor = floor;
    mn.attack_roll.ceiling = ceiling;

    mn.x = x;
    mn.y = y;

    m.m.length++;
    m.m[count] = mn;
    count++;

    ch = to!char( strip_line( fil ) );
  }

  ubyte px = 0, py = 0;

  px = to!ubyte( strip_line( fil ) );
  py = to!ubyte( strip_line( fil ) );

  m.player_start = [ py, px ];

  fil.close();

  return m;
} // level_from_file( string )
