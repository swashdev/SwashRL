/*
 * Copyright (c) 2019-2020 Philip Pavlick.  See '3rdparty.txt' for other
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

// mapalgo.d: defines functions related to map generation algorithms

public import global;
import std.random;

// Generates an empty `Map`
Map empty_Map()
{
    Map map;
    foreach( y; 0 .. MAP_Y )
    {
        foreach( x; 0 .. MAP_X )
        {
            map.itms[y][x] = No_item;
            map.tils[y][x] = TERRAIN_WALL;
        }
    }

    map.player_start = [ 0, 0 ];

    return map;
}

// Randomly generates a new Map.
// In the future, this function will take in an enum which specifies a map
// generation algogrithm, but for the moment it only uses the Simple Roguelike
// algorithm.
Map generate_new_map()
{
    Map map = gen_simple_roguelike( FOLIAGE );
    return map;
}

// Generates a new Map using SwashRL's Simple Roguelike algorithm.
Map gen_simple_roguelike( bool mold = true )
{
    // The `Map` to be returned
    Map map = empty_Map();

    // A list of `rooms`
    Room[12] rooms;

    size_t sector;
    for( sector = 0; sector < SECTORS.length; sector++ )
    {
        // DEFERRED
        version( none )
        {
            // Randomly decide whether or not to put an "actual room" in this
            // sector.  If we choose not to put a room here, use a placeholder
            // "zero-size" room
            if( 0 == d10() )
            {
                rooms[sector] = Room( 0, 0, 0, 0 );
                continue;
            }
        }

        Room room;

        // Get the coordinates for the upper-left corner of the room:
        room.x1 = uniform!"[]"( SECTORS[sector][0], SECTORS[sector][1] - MIN_ROOM_X, Lucky );
        room.y1 = uniform!"[]"( SECTORS[sector][2], SECTORS[sector][3] - MIN_ROOM_Y, Lucky );

        // Adjust x1 & y1 to ensure they are odd numbers:
        if( room.x1 % 2 == 0 )
        {
            room.x1--;
        }
        if( room.y1 % 2 == 0 )
        {
            room.y1--;
        }

        // Next, decide on a height and width:
        int w = uniform!"[]"( MIN_ROOM_X, MAX_ROOM_X, Lucky );
        int h = uniform!"[]"( MIN_ROOM_Y, MAX_ROOM_Y, Lucky );

        // Assign x2 & y2 accordingly:
        room.x2 = room.x1 + w;
        room.y2 = room.y1 + h;

        // Adjust x2 & y2 to fit the sector:
        if( room.x2 > SECTORS[sector][1] )
        {
            room.x2 = SECTORS[sector][1];
        }
        if( room.y2 > SECTORS[sector][3] )
        {
            room.y2 = SECTORS[sector][3];
        }

        // Adjust x2 & y2 to ensure they are odd numbers:
        if( room.x2 % 2 == 0 )
        {
            room.x2--;
        }
        if( room.y2 % 2 == 0 )
        {
            room.y2--;
        }

        // Add the room to the array:
        rooms[sector] = room;
    } // for( sector = 0; sector < SECTORS.length; sector++ )

    // Give the list of rooms to the generated map:
    map.rooms = rooms;

    // Add the player to a random location in a random room on the map:
    Room player_room = rooms[uniform( 0, 8, Lucky )];

    ubyte px = cast(ubyte)uniform!"[]"( player_room.x1, player_room.x2, Lucky );
    ubyte py = cast(ubyte)uniform!"[]"( player_room.y1, player_room.y2, Lucky );

    map.player_start = [py, px];

    // Now we go through the list of generated rooms and carve out the ones
    // that are "real rooms"
    for( sector = 0; sector < rooms.length; sector++ )
    {
        if( 0 >= (rooms[sector].x2 - rooms[sector].x1) )
        {
            continue;
        }

        add_room( rooms[sector], &map );
    }

    // This shuffled list of numbers will represent indexes for both the
    // sectors of the map and the rooms we just generated contained within
    // each sector.
    int[8] sectors = [0, 1, 2, 3, 4, 5, 6, 7].randomShuffle( Lucky );

    // For each pair of sectors adjacent to each other in the shuffled array,
    // we'll connect them with a corridor.
    for( int counter = 0; counter < 7; counter++ )
    {
        int counter2 = counter + 1;

        // Carve a corridor connecting the first chosen _room_ with the second
        // chosen _sector_.  We will always pick odd numbers for our starting
        // and ending coordinates, to avoid interfering with the rigid
        // boundaries of already-generated rooms; however, we will allow
        // corridors to intersect rooms.

        int index1 = sectors[counter], index2 = sectors[counter2];
  
        int start_x = uniform!"[]"( rooms[index1].x1, rooms[index1].x2, Lucky );
        int start_y = uniform!"[]"( rooms[index1].y1, rooms[index1].y2, Lucky );
        int mid_x   = uniform!"[]"( SECTORS[index2][0], SECTORS[index2][1],
                                    Lucky );
        int mid_y   = uniform!"[]"( SECTORS[index2][2], SECTORS[index2][3],
                                    Lucky );

        // Ensure the generated numbers are always odd
        if( start_x % 2 == 0 )
        {
            start_x--;
        }
        if( start_y % 2 == 0 )
        {
            start_y--;
        }
        if( mid_x   % 2 == 0 )
        {
            mid_x--;
        }
        if( mid_y   % 2 == 0 )
        {
            mid_y--;
        }

        // Carve the resulting corridor:
        add_corridor( &map, start_x, start_y, mid_x, mid_y );

        // Now check if our midpoint is inside the room we want to connect to.
        // If it is, job done.  Otherwise, select new coordinates.
        if( within_minmax!int( mid_x, rooms[index2].x1, rooms[index2].x2 )
            && within_minmax!int( mid_y, rooms[index2].y1, rooms[index2].y2 ) )
        {
            continue;
        }

        int end_x = uniform!"[]"( rooms[index2].x1, rooms[index2].x2, Lucky );
        int end_y = uniform!"[]"( rooms[index2].y1, rooms[index2].y2, Lucky );

        // Again. make sure our coordinates are odd:
        if( end_x % 2 == 0 )
        {
            end_x--;
        }
        if( end_y % 2 == 0 )
        {
            end_y--;
        }

        // Carve the corridor.  Note that the way that the corridors are
        // generated means that the generation algorithm may double back on
        // itself, creating dead ends.  Since this isn't an undesireable
        // effect, we'll let this slide.
        add_corridor( &map, mid_x, mid_y, end_x, end_y );
    } // for( int counter = 0; counter < 7; counter++ )
  
    static if( FOLIAGE )
    {
        // Plant mold in the Map:
        if( mold )
        {
            grow_mold( &map );
        }
    }

    return map;
} // Map gen_simple_roguelike( bool? )

// DEFERRED Anderson's algorithm for a future release
version( none )
{

// Get coordinates for a wall which is appropriate to add a random map element
// to in Mike Anderson's dungeon generation algorithm.
// For more information, see here:
// http://www.roguebasin.com/index.php?title=Dungeon-Building_Algorithm
void select_random_adjacent_wall( Map map, byte* y, byte* x )
{
    // We're going to store a two-dimensional array representing valid
    // coordinates, since that's faster than checking each wall for adjacent
    // floor tiles
    bool[MAP_X][MAP_Y] valid;

    // Initialize `valid` with `false` values
    for( int _x = 0; _x < MAP_X; _x++ )
    {
        for( int _y = 0; _y < MAP_Y; _y++ )
        {
            valid[_x][_y] = false;
        }
    }

    // First we'll check to make sure that the map does indeed contain
    // non-wall tiles.  In other words, we're checking to make sure the map
    // isn't empty.
    // While we're doing this, we'll also populate `valid` by checking each
    // floor-like tile for adjacent walls
    bool empty_map = true;
    for( int _x = 0; _x < MAP_X; _x++ )
    {
        for( int _y = 0; _y < MAP_Y; _y++ )
        {
            // Check what directions the tile at (_x, _y) blocks.  As a
            // shortcut, we're also going to veto door tiles, so we don't
            // accidentally end up with branching paths inside doorways.
            // Since both walls and doors block cardinal movement, that's the
            // only variable we need to check.
            if( !map.tils[_x][_y].block_cardinal_movement )
            {
                // Mark the map as non-empty
                empty_map = false;

                // Now we check adjacent tiles to see if they are walls.
                // If so, we're going to set the value corresponding to these
                // coordinates in `valid` to `true`.
                // Note that we're only checking in cardinal directions.
                if( _x > 0 )
                {
                    if( map.tils[_x - 1][_y].block_cardinal_movement )
                    {
                        valid[_x - 1][_y] = true;
                    }
                }
                if( _x < (MAP_X - 1) )
                {
                    if( map.tils[_x + 1][_y].block_cardinal_movement )
                    {
                        valid[_x + 1][_y] = true;
                    }
                }
                if( _y > 0 )
                {
                    if( map.tils[_x][_y - 1].block_cardinal_movement )
                    {
                        valid[_x][_y - 1] = true;
                    }
                }
                if( _y < (MAP_Y - 1) )
                {
                    if( map.tils[_x][_y + 1].block_cardinal_movement )
                    {
                        valid[_x][_y + 1] = true;
                    }
                }
            } // if( !map.tils[_x][_y].block_cardinal_movement )
        } // for( int _y = 0; _y < MAP_Y; _y++ )
    } // for( int _x = 0; _x < MAP_X; _x++ )

    // If the map is empty, we'll return some placeholder values.
    if( empty_map )
    {
did_not_get_adjacent_wall:
        y = -1;
        x = -1;
        return;
    }

    // Next we're going to double-check and make sure we actually got some
    // sets of valid coordinates.  If for whatever reason this function was
    // passed a map that gave only floor tiles, `valid` won't contain any
    // valid coordinates.
    bool got_valid = false;
    foreach( row; valid )
    {
        if( got_valid )
        {
            break;
        }

        foreach( col; row )
        {
            if( row[col] == true )
            {
                got_valid = true;
                break;
            }
        }
    }

    // If we did _not_ get any valid coordinates, return some placeholder
    // values
    if( !got_valid )
    {
        goto did_not_get_adjacent_wall;
    }

    // If the map is _not_ empty, we now have a two-dimensional array,
    // `valid`, filled with boolean values representing valid wall
    // coordinates.  We're now going to start selecting random x and y
    // coordinates until we get a `true` value from those coordinates in
    // `valid`.
    do
    {
        x = cast(byte)uniform( 1, MAP_X, Lucky );
        y = cast(byte)uniform( 1, MAP_Y, Lucky );
    } while( valid[x][y] == false );
} // void select_random_adjacent_wall( Map, byte*, byte* )

// Generates a random map using Mike Anderson's dungeon generation algorithm.
// For more information, see here:
// http://www.roguebasin.com/index.php?title=Dungeon-Building_Algorithm
Map gen_anderson( bool mold = true )
{
    int reps = 0;

    // 1. Fill the whole map with solid earth
    Map map = empty_Map();

    // 2. Dig out a single room in the centre of the map
    Room[] rooms = { random_Room() };
    add_room( rooms[0], map );

    // 3. Pick a random wall.  Obviously since the map is composed _mostly_ of
    // walls, we'll want to pick one that's actually connected to something.
    // I've written a function that gets us some good coordinates.
    uint x1, y1;
    int dir;

anderson_step_3:
    // Check how many times we've repeated the scan-and-add process.  On
    // RogueBasin, Anderson recommended 400-500 repetitions.
    if( rep < 500 )
    {
        rep++;
    }
    else
    {
        return m;
    }

    select_random_adjacent_wall( map, &x1, &y1 );

    // Determine which floor tile this wall is adjacent to and as such what
    // direction we'll be moving in.
    dir = -1;
    if( x1 > 0 )
    {
        if( !map.tils[x1 - 1][y1].blocks_cardinal_movement )
        {
            dir = Move.east;
        }
    }
    if( x1 < (MAP_X - 1) )
    {
        if( !map.tils[x1 + 1][y1].blocks_cardinal_movement )
        {
            dir = Move.west;
        }
    }
    if( y1 > 0 )
    {
        if( !map.tils[x1][y1 - 1].blocks_cardinal_movement )
        {
            dir = Move.south;
        }
    }
    if( y1 < (MAP_Y - 1) )
    {
        if( !map.tils[x1][y1 + 1].blocks_cardinal_movement )
        {
            dir = Move.north;
        }
    }

    // If for whatever reason we didn't get a valid direction, abort and try
    // again.
    if( dir <= 0 )
    {
        goto anderson_step_3;
    }

    return map;
} // Map gen_anderson( bool? )

} // version( none )
