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

// mapgen.d: variables & functions related to map generation
// (see also mapalgo.d)

import std.random;

import global;

// SECTION 1: ////////////////////////////////////////////////////////////////
// Configuration Variables                                                  //
//////////////////////////////////////////////////////////////////////////////

// Room configuration ////////////////////////////////////////////////////////

// Universal size configs for rooms:
enum MIN_ROOM_X =  4, MIN_ROOM_Y = 4;
enum MAX_ROOM_X = 18, MAX_ROOM_Y = 8;

// Universal limits to coordinates permissible inside cooridors:
enum MIN_HALL_X = 2, MAX_HALL_X = 76;
enum MIN_HALL_Y = 2, MAX_HALL_Y = 18;

// Map sector coordinates ////////////////////////////////////////////////////

// This two-dimensional array stores the minimum and maximum coordinate for
// map `SECTORS`, sections of the map inside which rooms can be generated.
// The standard map sectors split the map into a 4x2 grid, but other map
// generation algorithms might use different numbers of sectors of different
// sizes or may not make use of sectors at all.
const int[4][8] SECTORS =
    [ [1, 19,  1,  9], [21, 37,  1,  9], [39, 55,  1,  9], [57, 77,  1,  9],
      [1, 19, 11, 19], [21, 37, 11, 19], [39, 55, 11, 19], [57, 77, 11, 19]
    ];

// SECTION 2: ////////////////////////////////////////////////////////////////
// Map Element Generation Functions                                         //
//////////////////////////////////////////////////////////////////////////////

// Generates a random room
Room random_Room()
{
    Room room;

    int room_width  = uniform!"[]"( MIN_ROOM_X, MAX_ROOM_X, Lucky );
    int room_height = uniform!"[]"( MIN_ROOM_Y, MAX_ROOM_Y, Lucky );

    room.x1 = uniform( 1, (80 - MAX_ROOM_X), Lucky );
    room.x2 = room.x1 + room_width;
    room.y1 = uniform( 1, (22 - MAX_ROOM_Y), Lucky );
    room.y2 = room.y1 + room_height;

    return room;
} // Room random_Room()

// Generate a corridor into the given map using the given start- and end-
// points.
void add_corridor( Map* map, int start_x, int start_y, int end_x, int end_y )
{
    // Randomly decide whether to do y-coordinate or x-coordinate first
    if( flip() )
    {
        add_corridor_x( start_y, start_x, end_x, map );
        add_corridor_y( end_x,   start_y, end_y, map );
    }
    else
    {
        add_corridor_y( start_x, start_y, end_y, map );
        add_corridor_x( end_y,   start_x, end_x, map );
    }
}

// SECTION 3: ////////////////////////////////////////////////////////////////
// Map Digging Functions                                                    //
//////////////////////////////////////////////////////////////////////////////

// Corridor Digging Functions ////////////////////////////////////////////////

// Carves a vertical (north/south) cooridor into the given map using the given
// start- and end-points.
bool add_corridor_y( uint x, uint y1, uint y2, Map* map )
{
    // Check if the corridor will be within the bounds of the Map.
    if( x < 1 || x > MAP_x )
    {
        return false;
    }
    if( y1 < 1 || y1 > MAP_y || y2 < 1 || y2 > MAP_y )
    {
        return false;
    }

    // if y2 < y1, swap the two.
    uint sta, end;
    if( y2 < y1 )
    {
        sta = y2;
        end = y1;
    }
    else
    {
        sta = y1;
        end = y2;
    }

    // Carve all locations along the line [y, index], where `index` is the
    // most recent spot carved.
    foreach( y; sta .. (end + 1) )
    {
        // Do not destroy water by carving
        if( map.tils[y][x] != TERRAIN_WATER )
        {
            map.tils[y][x] = TERRAIN_FLOOR;
        }
    }

    return true;
} // bool add_corridor_x( uint, uint, uint, Map* )

// Carves a horizontal (east/west) corridor into the given map using the given
// start- and end-points
bool add_corridor_x( uint y, uint x1, uint x2, Map* map )
{
    // Check if the corridor will be within the bounds of the Map.
    if( y < 1 || y > MAP_y )
    {
        return false;
    }
    if( x1 < 1 || x1 > MAP_x || x2 < 1 || x2 > MAP_x )
    {
        return false;
    }

    // if x2 < x1, swap the two.
    uint sta, end;
    if( x2 < x1 )
    {
        sta = x2;
        end = x1;
    }
    else
    {
        sta = x1;
        end = x2;
    }

    // Carve all locations along the line [y, index], where `index' is the
    // most recent spot carved.
    foreach( x; sta .. (end + 1) )
    {
        // Do not destroy water by carving
        if( map.tils[y][x] != TERRAIN_WATER )
        {
            map.tils[y][x] = TERRAIN_FLOOR;
        }
    }

    return true;
} // bool add_corridor_x( uint, uint, uint, Map* )

// Room Digging Functions ////////////////////////////////////////////////////

// Carves a room into the given map using the given coordinates
bool add_room( uint y1, uint x1, uint y2, uint x2, Map* map )
{
    // Check if the Room will fit within the bounds of the Map.
    if( x1 > MAP_x || x1 < 1 || x2 > MAP_x || x2 < 1 )
    {
        return false;
    }
    if( y1 > MAP_y || y1 < 1 || y2 > MAP_y || y2 < 1 )
    {
        return false;
    }

    // Carve out the Room
    foreach( index_y; y1 .. (y2 + 1) )
    {
        foreach( index_x; x1 .. (x2 + 1) )
        {
            map.tils[index_y][index_x] = TERRAIN_FLOOR;
        }
    }

    return true;
} // bool add_room( uint, uint, uint, uint, Map* )

// Carves a room into the given map using a Room struct
bool add_room( Room room, Map* map )
{
    return add_room( room.y1, room.x1, room.y2, room.x2, map );
}

// SECTION 4: ////////////////////////////////////////////////////////////////
// Decorative Map Beautifying Functions                                     //
//////////////////////////////////////////////////////////////////////////////

static if( FOLIAGE )
{
    // Grows mold in the given map
    void grow_mold( Map* map )
    {
        import std.random;

        // This is the number of seeds we're going to have for mold growths:
        int num_molds = d10();

        if( num_molds > 0 )
        {
            foreach( count; 1 .. num_molds )
            {
                // This is the maximum number of Tiles this mold growth will
                // affect:
                int mold_len = d100();

                // Choose coordinates where our mold growth will start:
                int x = uniform( 0, MAP_X, Lucky );
                int y = uniform( 0, MAP_Y, Lucky );

                // Now we begin growing mold:
                foreach( count2; 1 .. mold_len )
                {
                    // Place mold on the current Tile:
                    map.tils[y][x].hazard |= SPECIAL_MOLD;

                    // Now decide a random direction to move in:
                    final switch( uniform( 0, 10, Lucky ) )
                    {
                        // You may notice that values which modify x are
                        // slightly more common; this is to encourage the mold
                        // to spread out along the wider x axis and fill more
                        // of the Map
                        case 0:
                            x--;
                            y--;
                            break;

                        case 1:
                        case 2:
                            x--;
                            break;

                        case 3:
                            x--;
                            y++;
                            break;

                        case 4:
                            y++;
                            break;

                        case 5:
                            y--;
                            break;

                        case 6:
                            x++;
                            y--;
                            break;

                        case 7:
                        case 8:
                            x++;
                            break;

                        case 9:
                            x++;
                            y++;
                            break;
                    } // final switch( uniform( 0, 10, Lucky ) )

                    // Terminate growing mold if we hit the edge of the Map
                    if( x >= MAP_X || x < 0 )
                    {
                        break;
                    }
                    if( y >= MAP_Y || y < 0 )
                    {
                        break;
                    }
                } // foreach( count2; 1 .. mold_len )
            } // foreach( count; 1 .. num_molds )
        } // if( num_molds > 0 )

        // Also grow mold around pools of water by first searching for water
        // Tiles:
        foreach( y; 0 .. MAP_Y )
        {
            foreach( x; 0 .. MAP_X )
            {
                if( map.tils[y][x].hazard & HAZARD_WATER )
                {
                    // 1 in 4 chance the Tile will have mold growing near it
                    if( d( 4 ) == 1 )
                    {
                        // Grow mold in a random Tile near the water
                        int trux, truy;

                        do
                        {
                            trux = flip() ? x : flip() ? x + 1 : x - 1;
                            truy = flip() ? y : flip() ? y + 1 : y - 1;
                        } while( trux == x && truy == y );

                        // Cancel here if x or y are out of bounds
                        if( trux >= MAP_X || trux < 0 )
                        {
                            continue;
                        }

                        if( truy >= MAP_Y || truy < 0 )
                        {
                            continue;
                        }

                        map.tils[y][x].hazard |= SPECIAL_MOLD;
                    } // if( d( 4 ) == 1 )
                } // if( map.tils[y][x].hazard & HAZARD_WATER )
            } // foreach( x; 0 .. MAP_X )
        } // foreach( y; 0 .. MAP_Y )
    } // void grow_mold( Map* )
} // static if( FOLIAGE )

debug
{

// SECTION 5: ////////////////////////////////////////////////////////////////
// The Test Map (debug only)                                                //
//////////////////////////////////////////////////////////////////////////////

    // Generates the standard test map
    Map test_map()
    {
        Map map;

        map.player_start = [ 1, 1 ];

        foreach( y; 0 .. MAP_Y )
        {
            foreach( x; 0 .. MAP_X )
            {
                map.itms[y][x] = No_item;
                if( y == 0 || y == MAP_y || x == 0 || x == MAP_x )
                {
                    map.tils[y][x] = TERRAIN_WALL;
                }
                else
                {
                    if( (y < 13 && y > 9)
                        && ((x > 19 && x < 24) || (x < 61 && x > 56)) )
                    {
                        map.tils[y][x] = TERRAIN_WALL;
                    }
                    else
                    {
                        if( (y < 13 && y > 9) && (x > 30 && x < 50) )
                        {
                            map.tils[y][x] = TERRAIN_WATER;
                        }
                        else
                        {
                            map.tils[y][x] = TERRAIN_FLOOR;
                        }
                    } // else from if( (y < 13 && y > 9) ...
                } // else from if( y == 0 || y == MAP_y ...
            } // foreach( x; 0 .. MAP_X )
        } // foreach( y; 0 .. MAP_Y )

        static if( FOLIAGE )
        {
            grow_mold( &map );
        }

        // test Monsters

        Monst goobling = Monst( Symbol( 'g', Colors.Dark_Gray ), "goobling",
                                roll( 2 ) + 2, Locomotion.terrestrial,
                                Dicebag( 2, 0, 2, 1000 ), 50, 10, init_inven()
                              );

        add_mon( &map, goobling );

        static if( MORE_TEST_MONSTERS )
        {
            goobling = Monst( Symbol( 'b', Colors.Dark_Gray ), "crow",
                              roll() + 2, Locomotion.aerial,
                              Dicebag( 1, 2, 3, 1000 ), 50, 20, init_inven()
                            );
            add_mon( &map, goobling );

            goobling = Monst( Symbol( '8', Colors.Cyan ), "carp",
                              roll(), Locomotion.aquatic,
                              Dicebag( 1, 3, 4, 1000 ), 50, 12, init_inven()
                            );
            add_mon( &map, goobling );

            goobling = Monst( Symbol( '%', Colors.Brown ), "slime mold",
                              3, Locomotion.sessile,
                              Dicebag( 0, 2, 2, 2 ), 78, 2, init_inven()
                            );
            add_mon( &map, goobling );

        } // static if( MORE_TEST_MONSTERS )

        // test Items

        // a test Item "old sword" which grants a +2 bonus to the player's
        // attack roll
        Item old_sword = Item( Symbol( '(', Colors.Gray ), "old sword",
                               Type.weapon, Armor.none, 0, 2 );
        map.itms[10][5] = old_sword;

        Item shield = Item( Symbol( ']', Colors.Dark_Gray ),
                            "crow-crested shield", Type.armor, Armor.shield,
                            0, 5 );
        map.itms[11][5] = shield;

        Item ring = Item( Symbol( '*', Colors.Silver ), "silver ring",
                          Type.jewelery, Armor.ring, 0, 0 );
        map.itms[10][2] = ring;

        ring.sym.color = Colors.Gold;  ring.name = "gold ring";
        map.itms[10][1] = ring;

        Item helmet = Item( Symbol( ']', Colors.Brown ), "hat",
                            Type.armor, Armor.helmet, 0, 0 );
        map.itms[10][3] = helmet;

        Item scarf = Item( Symbol( ']', Colors.Green ), "fluffy scarf",
                           Type.armor, Armor.neck, 0, 0 );
        map.itms[11][3] = scarf;

        Item tunic = Item( Symbol( ']', Colors.Brown ), "tunic",
                           Type.armor, Armor.cuirass, 0, 0 );
        map.itms[12][3] = tunic;

        Item gloves = Item( Symbol( ']', Colors.Brown ),
                            "pair of leather gloves", Type.armor,
                            Armor.bracers, 0, 1 );
        map.itms[13][3] = gloves;

        Item pants = Item( Symbol( ']', Colors.Brown ), "pair of trousers",
                           Type.armor, Armor.greaves, 0, 0 );
        map.itms[14][3] = pants;

        Item kilt = Item( Symbol( ']', Colors.Green ), "plaid kilt",
                          Type.armor, Armor.kilt, 0, 0 );
        map.itms[15][3] = kilt;

        Item boots = Item( Symbol( ']', Colors.Brown ), "pair of shoes",
                           Type.armor, Armor.feet, 0, 0 );
        map.itms[16][3] = boots;

        Item tailsheath = Item( Symbol( ']', Colors.Brown ),
                                "leather tailsheath", Type.armor, Armor.tail,
                                0, 1 );
        map.itms[17][3] = tailsheath;
  
        return map;
    } // Map test_map()
} // debug
