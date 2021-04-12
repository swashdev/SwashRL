/*
 * Copyright (c) 2018-2021 Philip Pavlick.  See '3rdparty.txt' for other
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
import std.conv;

// SECTION 0: ////////////////////////////////////////////////////////////////
// Placeholders & Special Markers                                           //
//////////////////////////////////////////////////////////////////////////////

// `LAST_COMPATIBLE_VERSION` is used to indicate the last version of the game
// whose save files are compatible with the current version.  See global.d
// for how version numbers are stored.
enum LAST_COMPATIBLE_VERSION = 0.035;

// `PLACEHOLDER_MARKER` is used to indicate that an object which would
// normally be written does not exist.
enum PLACEHOLDER_MARKER = cast(char)19;

// `SEPARATOR_MARKER` is used to indicate that a section in a save file has
// ended.
enum SEPARATOR_MARKER   = cast(char)20;

// SECTION 1: ////////////////////////////////////////////////////////////////
// Exceptions & Error Handling                                              //
//////////////////////////////////////////////////////////////////////////////

// An exception for invalid save file access.
class Save_File_Exception : Exception
{
    mixin basicExceptionCtors;
}

// An exception for invalid dungeon level file access.
class Dungeon_File_Exception : Exception
{
    mixin basicExceptionCtors;
}

// Throws a SaveFileException.
void save_error( T... )( string file, T args )
{
    throw new Save_File_Exception(
            format( "Unable to access save file %s: %s", file,
                format( args ) ) );
}

// Throws a DungeonFileException.
void level_file_error( T... )( string dungeon_file, T args )
{
    throw new Dungeon_File_Exception(
            format( "Unable to read dungeon level file %s: %s", dungeon_file,
                format( args ) ) );
}

// SECTION 2: ////////////////////////////////////////////////////////////////
// Saving to a File                                                         //
//////////////////////////////////////////////////////////////////////////////

// Saves a Symbol to a file.
void save_Symbol( Symbol sym, File fil )
{
    // Each Symbol has a char and a Colors.  Write both of these.
    fil.writeln( sym.ascii );
    fil.writeln( sym.color );
}

// Saves a Tile to a file.
void save_Tile( Tile til, File fil )
{
    // Each Tile has a Symbol.  Write this first.
    save_Symbol( til.sym, fil );

    // Next, write the tile's special properties.
    fil.writeln( til.block_cardinal_movement );
    fil.writeln( til.block_diagonal_movement );
    fil.writeln( til.block_vision );
    fil.writeln( til.lit );
    fil.writeln( til.seen );
    fil.writeln( til.hazard );
}

// Saves an Item to a file.
void save_Item( Item itm, File fil )
{
    // If the given item turns out not to exist, write a placeholder instead.
    if( !Item_here( itm ) )
    {
        fil.writeln( PLACEHOLDER_MARKER );
    }
    else
    {
        // Each Item has a Symbol.  Write this first.
        save_Symbol( itm.sym, fil );

        // Next, write the Item's special properties.
        fil.writeln( itm.name );
        fil.writeln( itm.type );
        fil.writeln( itm.equip );
        fil.writeln( itm.str );
        fil.writeln( itm.end );
        fil.writeln( itm.add_dice );
        fil.writeln( itm.add_mod );
        fil.writeln( itm.stacks );
        fil.writeln( itm.count );
    }
}

// Saves a Dicebag to a file.
void save_Dicebag( Dicebag dice, File fil )
{
    // Each Dicebag has a dice count, a modifier, and a floor & ceiling.
    fil.writeln( dice.dice );
    fil.writeln( dice.modifier );
    fil.writeln( dice.floor );
    fil.writeln( dice.ceiling);
}

// Saves an inventory to a file.
void save_inventory( Item[] inventory, File fil )
{
    // First acquire & save the length of the inventory so we know how many
    // items to save.
    size_t len = inventory.length;
    fil.writeln( len );

    // Save all of the items sequentially.
    foreach( count; 0 .. len )
    {
        save_Item( inventory[count], fil );
        // If the inventory isn't full, abort after writing the first
        // placeholder marker so we don't waste time and space.
        if( !Item_here( inventory[count] ) )
        {
            break;
        }
    }
}

// Saves a wallet to a file.
void save_wallet( Item[5] wallet, File fil )
{
    // Wallets always have five items in them, even if they're empty stacks,
    // so this one is ezpz.
    foreach( count; 0 .. 5 )
    {
        save_Item( wallet[count], fil );
    }
}

// Saves an equipment list to a file.
void save_equipment( Item[Slot] equipment, File fil )
{
    Slot[] keys = equipment.keys;
    Item[] values = equipment.values;

    // Basically what we're doing here is we're saving the key and then its
    // value for each slot in the equipment list.  Skip all empty entries.
    foreach( count; 0 .. equipment.length )
    {
        if( keys[count] != Slot.none && Item_here( values[count] ) )
        {
            fil.writeln( keys[count] );
            save_Item( values[count], fil );
        }
    }

    // Save a placeholder to indicate we're at the end of the equipment
    // list.  This is necessary because associative arrays may have any number
    // of elements and because we're skipping some in the above loop we won't
    // know for sure how many there actually are.
    fil.writeln( Slot.none );
} // save_equipment( Item[Slot], File )

// Saves a Monst's inventory to a file.
void save_Monst_inventory( Monst mon, File fil )
{
    save_inventory( mon.inventory, fil );
    save_wallet( mon.wallet, fil );
    save_equipment( mon.equipment, fil );
}

// Saves a Monst to a file.
void save_Monst( Monst mon, File fil )
{
    // Only save the monster if it has >0 hit points.
    if( mon.hit_points > 0 )
    {
        // Each Monst has a Symbol.  Write this first.
        save_Symbol( mon.sym, fil );

        // Next, write the Monst's special properties.
        fil.writeln( mon.name );
        fil.writeln( mon.hit_points );
        fil.writeln( mon.str );
        fil.writeln( mon.end );
        fil.writeln( mon.walk );
        fil.writeln( mon.x );
        fil.writeln( mon.y );

        // Each Monst has a Dicebag.  Write this next.
        save_Dicebag( mon.attack_roll, fil );

        // Save the monster's inventory, wallet, and equipped items.
        save_inventory( mon.inventory, fil );
        save_wallet( mon.wallet, fil );
        save_equipment( mon.equipment, fil );
    }
} // save_Monst( Monst, File )

// Saves a level to a file.
void save_level( T... )( Map map, Player plyr, T args )
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
    catch( FileException error )
    {
        level_file_error( path, error.msg );
    }

    // First things first: Output the version number so that we can determine
    // level file compatibility:
    string ver = format( "%.3f", VERSION );
    fil.writeln( ver );

    // We start by recording all of the tiles on the map:

    // Leave a marker indicating we're starting tile recording:
    fil.writeln( SEPARATOR_MARKER );

    foreach( y; 0 .. MAP_Y )
    {
        foreach( x; 0 .. MAP_X )
        {
            Tile til = map.tils[y][x];

            save_Tile( til, fil );
        }
    }

    // Leave a marker indicating that we're finishing tile output and starting
    // items:
    fil.writeln( SEPARATOR_MARKER );

    // Start writing items:
    foreach( y; 0 .. MAP_Y )
    {
        foreach( x; 0 .. MAP_X )
        {
            Item itm = map.itms[y][x];

            save_Item( itm, fil );
        } // foreach( x; 0 .. MAP_X )
    }

    // Leave a marker indicating that we're done with items and now are
    // outputting monsters
    fil.writeln( SEPARATOR_MARKER );

    // Start writing monsters:
    foreach( index; 0 .. map.mons.length )
    {
        Monst mon = map.mons[index];

        save_Monst( mon, fil );
    }

    // Leave a marker indicating that we're done with outputting monsters
    fil.writeln( SEPARATOR_MARKER );

    // Finally, we output the coordinates that the player character is
    // standing at.
    ubyte x = plyr.x, y = plyr.y;

    fil.writeln( x );
    fil.writeln( y );

    // We're done.
    fil.close();
} // void save_level( Map, Player, T args )

// SECTION 3: ////////////////////////////////////////////////////////////////
// Loading from a Saved File                                                //
//////////////////////////////////////////////////////////////////////////////

// Loads in a Symbol from a file.
Symbol load_Symbol( File fil )
{
    // Each Symbol has a char and a Colors.  Read these in order.
    char ascii = to!char( strip_line( fil ) );
    Colors color = to!Colors( strip_line( fil ) );

    // Return the resulting Symbol.
    return Symbol( ascii, color );
}

// Loads in a Tile from a file.
Tile load_Tile( File fil )
{
    // Each Tile has a Symbol.  Read this first.
    Symbol sym = load_Symbol( fil );

    // Next, read in the Tile's special properties.
    bool block_cardinal_movement = to!bool( strip_line( fil ) );
    bool block_diagonal_movement = to!bool( strip_line( fil ) );
    bool block_vision = to!bool( strip_line( fil ) );
    bool lit = to!bool( strip_line( fil ) );
    bool seen = to!bool( strip_line( fil ) );
    uint hazard = to!uint( strip_line( fil ) );

    // Return the resulting Tile.
    return Tile( sym, block_cardinal_movement, block_diagonal_movement,
                 block_vision, lit, seen, hazard );
}

// Loads in an Item from a file.
Item load_Item( File fil )
{
    // Unlike with Tiles, we need to read in the char and Colors of the Item's
    // Symbol separately, so we can check if a `PLACEHOLDER_MARKER` has been
    // written instead.
    char ascii = to!char( strip_line( fil ) );
  
    // If we got a placeholder, return `No_item`.
    if( ascii == PLACEHOLDER_MARKER )
    {
        return No_item;
    }

    // Otherwise, we can proceed as normal by reading in the Symbol's Colors
    // and then getting the Symbol from there.
    Colors color = to!Colors( strip_line( fil ) );
    Symbol sym = Symbol( ascii, color );

    // Next, read in the Item's special properties.
    string name = strip_line( fil );
    Type type = to!Type( strip_line( fil ) );
    Slot equip = to!Slot( strip_line( fil ) );

    int str = to!int( strip_line( fil ) );
    int end = to!int( strip_line( fil ) );

    int add_dice = to!int( strip_line( fil ) );
    int add_mod = to!int( strip_line( fil ) );

    bool stacks = to!bool( strip_line( fil ) );
    uint count = to!uint( strip_line( fil ) );

    // Return the resulting Item.
    return Item( sym, name, type, equip, str, end, add_dice, add_mod, stacks,
                 count );
} // Item load_Item( File )

// Loads in a Dicebag from a file.
Dicebag load_Dicebag( File fil )
{
    // Each dicebag has dice count, a modifier, a floor, and a ceiling.  Read
    // these in order.
    uint dice = to!uint( strip_line( fil ) );
    int modifier = to!int( strip_line( fil ) );
    int floor = to!int( strip_line( fil ) );
    int ceiling = to!int( strip_line( fil ) );

    // Return the resulting Dicebag.
    return Dicebag( dice, modifier, floor, ceiling );
}

// Loads a dynamic array, representing an inventory, from a file.
Item[] load_inventory( File fil )
{
    Item[] inventory;

    // First acquire the length of the inventory so we know how many items to
    // load.
    size_t len = to!size_t( strip_line( fil ) );
    inventory.length = len;

    // Load all of the items sequentially.  Once we encounter an empty item,
    // we have to stop loading and fill the rest in ourselves.
    bool do_filler = false;
    foreach( count; 0 .. len )
    {
        // If we haven't encountered a placeholder yet...
        if( !do_filler )
        {
            // load in an item...
            inventory[count] = load_Item( fil );
            // and check to see if it's a placeholder.
            if( !Item_here( inventory[count] ) )
            {
                // if it is, mark the rest of the inventory as filler.
                do_filler = true;
            }
        }
        else
        {
            inventory[count] = No_item;
        }
    }

    // Return the resulting inventory.
    return inventory;
} // Item[] load_inventory( File )

// Loads a 5-item array representing a wallet.
Item[5] load_wallet( File fil )
{
    Item[5] wallet;

    // Wallets always have five items in them, even if they're empty stacks,
    // so this one is ezpz.
    foreach( count; 0 .. 5 )
    {
        wallet[count] = load_Item( fil );
    }

    return wallet;
}

// Loads an equipment list from a file.
Item[Slot] load_equipment( File fil )
{
    Item[Slot] equipment;

    // Basically what we're doing here is we're loading the key and then its
    // value for each slot in the equipment list.  If we encounter a
    // placeholder, abort loading and return the list.
    bool keep_loading = true;
    do
    {
        // First load an equipment slot key.
        Slot key = to!Slot( strip_line( fil ) );

        // Check if this is a placeholder.
        if( key == Slot.none )
        {
            // If it is, abort loading.  We're done.
            keep_loading = false;
        }
        else
        {
            // Otherwise, assign the slot to an item.
            equipment[key] = load_Item( fil );
        }
    } while( keep_loading );

    // Return the resulting equipment list.
    return equipment;
} // Item[Slot] load_equipment( File )

// Loads in a Monst from a file.
Monst load_Monst( char ascii, File fil )
{
    // Unlike with Tiles or Items, we need to save in `ch` before we start
    // reading the Monst so we know that we don't have a `SEPARATOR_MARKER`,
    // so we already have that.  We just need to read in a Colors and from
    // there we'll have the Symbol we need.
    Colors color = to!Colors( strip_line( fil ) );

    Symbol sym = Symbol( ascii, color );

    // Next, read in the Monst's special properties.
    string name = strip_line( fil );

    int hit_points = to!int( strip_line( fil ) );
    int str = to!int( strip_line( fil ) );
    int end = to!int( strip_line( fil ) );

    Locomotion walk = to!Locomotion( strip_line( fil ) );
    ubyte x = to!ubyte( strip_line( fil ) );
    ubyte y = to!ubyte( strip_line( fil ) );

    // Read in the Monst's Dicebag next.
    Dicebag attack_roll = load_Dicebag( fil );

    // Now we read in the Monst's inventory, wallet, and equipment list.
    Item[] inventory = load_inventory( fil );
    Item[5] wallet = load_wallet( fil );
    Item[Slot] equipment = load_equipment( fil );

    // Return the resulting Monst.
    return Monst( sym, name, hit_points, str, end, walk, attack_roll, x, y,
            inventory, wallet, equipment );
} // Monst load_Monst( char, File )

// Get a saved level from a file.
Map level_from_file( string file_label )
{
    string path = format( "save/lev/%s.lev", file_label );

    if( !exists( path ) )
    {
        level_file_error( path, "File does not exist." );
    }

    if( !isFile( path ) )
    {
        level_file_error( path,
                "This is a directory or a symlink, not a file." );
    }

    File fil;

    try
    {
        fil = File( path, "r" );
    }
    catch( FileException error )
    {
        level_file_error( path, error.msg );
    }

    float ver = 0.000;

    ver = to!float( strip_line( fil ) );

    if( ver < LAST_COMPATIBLE_VERSION )
    {
        fil.close();
        level_file_error( path,
                "File version %.3f not compatible with current version %.3f",
                ver, VERSION );
    }

    char marker = '\0';

    marker = to!char( strip_line( fil ) );

    if( marker != SEPARATOR_MARKER )
    {
        fil.close();
        level_file_error( path,
                "Could not read map tiles; file not formatted correctly." );
    }

    Map map;

    foreach( y; 0 .. MAP_Y )
    {
        foreach( x; 0 .. MAP_X )
        {
            Tile til = load_Tile( fil );

            map.tils[y][x] = til;
        }
    }

    marker = to!char( strip_line( fil ) );

    if( marker != SEPARATOR_MARKER )
    {
        fil.close();
        level_file_error( path,
                "Could not read items; file not formatted correctly." );
    }

    foreach( y; 0 .. MAP_Y )
    {
        foreach( x; 0 .. MAP_X )
        {
            Item itm = load_Item( fil );

            map.itms[y][x] = itm;
        }
    }

    marker = to!char( strip_line( fil ) );

    if( marker != SEPARATOR_MARKER )
    {
        fil.close();
        level_file_error( path,
                "Could not read monsters; file not formatted correctly." );
    }

    char ascii = '\0';
    uint count = 0;

    ascii = to!char( strip_line( fil ) );

    while( ascii != SEPARATOR_MARKER )
    {
        if( fil.eof() )
        {
            fil.close();
            level_file_error( path,
                    "Reached EOF before end of monster array" );
        }

        Monst mon = load_Monst( ascii, fil );

        map.mons.length++;
        map.mons[count] = mon;
        count++;

        ascii = to!char( strip_line( fil ) );
    }

    ubyte px = 0, py = 0;

    px = to!ubyte( strip_line( fil ) );
    py = to!ubyte( strip_line( fil ) );

    map.player_start = [ py, px ];

    fil.close();

    return map;
} // Map level_from_file( string )
