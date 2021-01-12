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

// map.d: defines structures and functions related to maps and manipulation of
// map data

import global;

// for `remove`
import std.algorithm.mutation;

// SECTION 1: ////////////////////////////////////////////////////////////////
// Rooms                                                                    //
//////////////////////////////////////////////////////////////////////////////

// A `struct' used to store `Room's for the Map generation code
struct Room
{
    int x1, y1, x2, y2;
}

// SECTION 2: ////////////////////////////////////////////////////////////////
// Maps                                                                     //
//////////////////////////////////////////////////////////////////////////////

// A struct which stores map data
struct Map
{
    Tile[MAP_X][MAP_Y]   tils;
    Monst[]              mons;
    Item[MAP_X][MAP_Y]   itms;
    Room[12]             rooms;
    bool[MAP_X][MAP_Y]   visible;

    ubyte[2] player_start;
}

// SECTION 3: ////////////////////////////////////////////////////////////////
// Map Manipulation                                                         //
//////////////////////////////////////////////////////////////////////////////

// Drop Items In /////////////////////////////////////////////////////////////

// "drops" an item in the map at the given coordinates.  If `inform_player` is
// true, send the player a message to indicate that the item was moved due to
// an item already being present.
void drop_item( Map* map, Item itm, ubyte at_x, ubyte at_y,
                bool inform_player = false )
{
    ubyte x = minmax!(ubyte)( at_x, 0, MAP_x );
    ubyte y = minmax!(ubyte)( at_y, 0, MAP_y );

    if( inform_player )
    {
        message( "You drop the %s.", item_name( itm ) );
    }
  
    while( Item_here( map.itms[y][x] ) )
    {

        if( inform_player )
        {
            message( "The %s bounce%s off of %s %s", item_name( itm ),
                     itm.count == 1? "s" : "",
                     map.itms[y][x].count > 1 ? "some" : "a",
                     item_name( map.itms[y][x] ) );
        }

        do
        {
            // the item "bounces" off an item or wall into an adjacent tile
            Move fall = cast(Move)not_dice( 0, 7 );

            switch( fall )
            {
                default:
                    continue;

                case Move.northwest:
                    x--;
                    y--;
                    break;

                case Move.north:
                    y--;
                    break;

                case Move.northeast:
                    x++;
                    y--;
                    break;

                case Move.west:
                    x--;
                    break;

                case Move.east:
                    x++;
                    break;

                case Move.southwest:
                    x--;
                    y++;
                    break;

                case Move.south:
                    y++;
                    break;

                case Move.southeast:
                    x++;
                    y++;
                    break;
            } // switch( fall )

        } while( map.tils[y][x].block_cardinal_movement
                 && map.tils[y][x].block_diagonal_movement );

    } // while( Item_here( map.itms[y][x] ) )

    // destroy the item if it falls in water.
    if( map.tils[y][x].hazard & HAZARD_WATER )
    {
        if( inform_player )
        {
            message( "The %s fall%s in the water and sink%s.",
                     item_name( itm ), itm.count == 1 ? "s" : "",
                     itm.count == 1 ? "s" : "" );
        }
    }
    // otherwise, place the item in the map.
    else
    {
        map.itms[y][x] = itm;
    }
} // drop_item( Map*, Item, ubyte, ubyte, bool? )

// Add & Remove Monsters /////////////////////////////////////////////////////

// Add a monster to the given map
void add_mon( Map* map, Monst mon )
{
    size_t mndex = map.mons.length;
    if( mndex < NUMTILES )
    {
        map.mons.length++;
        map.mons[mndex] = mon;
    }
}

// Remove a monster from the given map by index
void remove_mon( Map* map, uint index )
{
    // To remove a Monster in a Map's mon array, move all Monsters that are
    // past it in the array up, thus overwriting it.
    if( index < map.mons.length )
    {
        map.mons = map.mons.remove( index );
    }
}
