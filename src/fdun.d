/*
 * Copyright 2016-2018 Philip Pavlick
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License, excepting that
 * Derivative Works are not required to carry prominent notices in changed
 * files.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
/* swash-tentative status: ACTIVE */

// fdun.d: Functions for reading and writing dungeon level files

import global;

import fexcept;

import std.stdio;
import std.format;
import std.file;

/++
 + Opens a level from a file.
 +
 + This function opens a level from a file.  The file is specified by the
 + given integer level_number.  The file will have the file name
 + `save/lev/<level_number>.lev`
 +
 + The file is always opened in "read mode," because this function is only
 + intended to <i>access</i> files, not save them.
 +
 + Throws:
 +     DungeonFileException if the dungeon file does not exist or is
 +     inaccessible
 +
 + Params:
 +     level_number: The dungeon level that we want to load.
 +
 + Returns: A `File` opened by the function.
 +/
File open_level( T... )( T args )
{
  string path = format( "save/lev/%s.lev", format( args ) );

  // Check if the file exists; if it doesn't, throw an exception
  if( !exists( path ) )
  { level_file_error( path, "File does not exist." );
  }

  if( !isFile( path ) )
  { level_file_error( path, "This is a directory or symlink, not a file" );
  }

  File ret;

  try
  {
    ret = File( path, "r" );
  }
  catch( FileException e )
  {
    level_file_error( path, e.msg );
  }

  return ret;
}

/++
 + Saves a level to a file
 +
 + This function takes in a `map` and a `player` and writes the map data and
 + the player's coordinates to a file.  The file is specified by the given
 + integer level_number.  The file will always be in the same directory as the
 + program, and will be the file name `<level_number>.lev`
 +
 + The file is accessed in "write mode," and will overwrite any existing file.
 +
 + Throws:
 +     DungeonFileException if the file path is inaccessible,
 +     FileException if some other problem happened while writing.
 +
 + Params:
 +     m = The `map` to be saved
 +     u = The `player` character
 +     level_number = The level number to be used for the resulting file name
 +/
void save_level( T... )( map m, player u, T args )
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
      tile t = m.t[y][x];

      // Each tile has a symbol...
      symbol s = t.sym;

      char ch = s.ch;
      fil.writeln( ch );

      // Each symbol has a Color...
      Color c = s.color;

      ubyte fg = c.fg;
      fil.writeln( fg );

      bool reverse = c.reverse;
      fil.writeln( reverse );

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

      ushort hazard = t.hazard;
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
      item i = m.i[y][x];

      // Every item has a symbol:
      symbol s = i.sym;

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

      Color c = s.color;

      ubyte fg = c.fg;
      fil.writeln( fg );

      bool reverse = c.reverse;
      fil.writeln( reverse );

      // Each item has a name...
      string name = i.name;
      fil.writeln( name );

      ushort type = i.type, equip = i.equip;
      fil.writeln( type );
      fil.writeln( equip );

      byte addd = i.addd, addm = i.addm;
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
    monst mn = m.m[n];

    // If the monster has no hit points, skip it... dead monsters aren't worth
    // recording.
    if( mn.hp <= 0 )
    { continue;
    }

    // Every monster has--you guessed it!  A symbol!
    symbol s = mn.sym;

    char ch = s.ch;
    fil.writeln( ch );

    Color c = s.color;

    ubyte fg = c.fg;
    fil.writeln( fg );

    bool reverse = c.reverse;
    fil.writeln( reverse );

    // Every monster has a string...
    string name = mn.name;
    fil.writeln( name );

    int hp = mn.hp;
    fil.writeln( hp );

    ubyte fly = mn.fly, swim = mn.swim, x = mn.x, y = mn.y;
    fil.writeln( fly );
    fil.writeln( swim );
    fil.writeln( x );
    fil.writeln( y );

    // Every monster has a dicebag...
    dicebag db = mn.attack_roll;

    ubyte di = db.dice;
    fil.writeln( di );

    short modifier = db.modifier;
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

/++
 + Reads a line from a file and strips the newline off the end
 +/
string strip_line( File fil )
{
  char[] line = fil.readln().dup;
  line.length--;
  return cast(string)line;
}

/++
 + Get a saved level from a file
 +/
map level_from_file( string file_label )
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

  map m;

  foreach( y; 0 .. MAP_Y )
  {
    foreach( x; 0 .. MAP_X )
    {
      tile t;

      char ch = '?';
      ubyte fg = CLR_LITERED;
      bool reversed = 1;


      ch = to!char( strip_line( fil ) );
      fg = to!ubyte( strip_line( fil ) );
      reversed = to!bool( strip_line( fil ) );

      t.sym.ch = ch;
      t.sym.color.fg = fg;
      t.sym.color.reverse = reversed;

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

      ushort hazard = 0;

      hazard = to!ushort( strip_line( fil ) );

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

      item i;

      ubyte fg = CLR_LITERED;
      bool reversed = 1;

      fg = to!ubyte( strip_line( fil ) );
      reversed = to!bool( strip_line( fil ) );

      i.sym.ch = ch;
      i.sym.color.fg = fg;
      i.sym.color.reverse = reversed;

      string name = strip_line( fil );

      i.name = name;

      ushort type = 0, equip = 0;

      type = to!ushort( strip_line( fil ) );
      equip = to!ushort( strip_line( fil ) );

      i.type = type;
      i.equip = equip;

      byte addd = 0, addm = 0;

      addd = to!byte( strip_line( fil ) );
      addm = to!byte( strip_line( fil ) );

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

    monst mn;

    ubyte fg = CLR_LITERED;
    bool reversed = 1;

    fg = to!byte( strip_line( fil ) );
    reversed = to!bool( strip_line( fil ) );

    mn.sym.ch = ch;
    mn.sym.color.fg = fg;
    mn.sym.color.reverse = reversed;

    string name = strip_line( fil );
 
    mn.name = name;

    int hp = 0;

    hp = to!int( strip_line( fil ) );

    mn.hp = hp;

    ubyte fly = 0, swim = 0;

    fly = to!ubyte( strip_line( fil ) );
    swim = to!ubyte( strip_line( fil ) );

    mn.fly = fly;
    mn.swim = swim;

    ubyte x = 0, y = 0;

    x = to!ubyte( strip_line( fil ) );
    y = to!ubyte( strip_line( fil ) );

    ubyte di = 0;

    di = to!ubyte( strip_line( fil ) );

    mn.attack_roll.dice = di;

    short modifier = 0;

    modifier = to!short( strip_line( fil ) );

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
