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

  Room r;
  int room_width  = uniform!"[]"( MIN_ROOM_X, MAX_ROOM_X, Lucky );
  int room_height = uniform!"[]"( MIN_ROOM_Y, MAX_ROOM_Y, Lucky );

  r.x1 = uniform( 1, (80 - MAX_ROOM_X), Lucky );
  r.x2 = r.x1 + room_width;
  r.y1 = uniform( 1, (22 - MAX_ROOM_Y), Lucky );
  r.y2 = r.y1 + room_height;

  return r;

} // Room random_Room()

// Generate a corridor into the given map using the given start- and end-
// points.
void add_corridor( Map* m, int start_x, int start_y, int end_x, int end_y )
{
  // Randomly decide whether to do y-coordinate or x-coordinate first
  if( flip() )
  {
    add_corridor_x( start_y, start_x, end_x, m );
    add_corridor_y( end_x,   start_y, end_y, m );
  }
  else
  {
    add_corridor_y( start_x, start_y, end_y, m );
    add_corridor_x( end_y,   start_x, end_x, m );
  }
}

// SECTION 3: ////////////////////////////////////////////////////////////////
// Map Digging Functions                                                    //
//////////////////////////////////////////////////////////////////////////////

// Corridor Digging Functions ////////////////////////////////////////////////

// Carves a vertical (north/south) cooridor into the given map using the given
// start- and end-points.
bool add_corridor_y( uint x, uint y1, uint y2, Map* m )
{
  // Check if the corridor will be within the bounds of the Map.
  if( x < 1 || x > MAP_x )
  { return false;
  }
  if( y1 < 1 || y1 > MAP_y || y2 < 1 || y2 > MAP_y )
  { return false;
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

  // Carve all locations along the line [y, index], where `index' is the most
  // recent spot carved.
  foreach( y; sta .. (end + 1) )
  {
    // Do not destroy water by carving
    if( m.t[y][x] != TERRAIN_WATER )
    { m.t[y][x] = TERRAIN_FLOOR;
    }
  }

  return true;
} // bool add_corridor_x( uint, uint, uint, Map* )

// Carves a horizontal (east/west) corridor into the given map using the given
// start- and end-points
bool add_corridor_x( uint y, uint x1, uint x2, Map* m )
{
  // Check if the corridor will be within the bounds of the Map.
  if( y < 1 || y > MAP_y )
  { return false;
  }
  if( x1 < 1 || x1 > MAP_x || x2 < 1 || x2 > MAP_x )
  { return false;
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

  // Carve all locations along the line [y, index], where `index' is the most
  // recent spot carved.
  foreach( x; sta .. (end + 1) )
  {
    // Do not destroy water by carving
    if( m.t[y][x] != TERRAIN_WATER )
    { m.t[y][x] = TERRAIN_FLOOR;
    }
  }

  return true;
} // bool add_corridor_x( uint, uint, uint, Map* )

// Room Digging Functions ////////////////////////////////////////////////////

// Carves a room into the given map using the given coordinates
bool add_room( uint y1, uint x1, uint y2, uint x2, Map* m )
{
  // Check if the Room will fit within the bounds of the Map.
  if( x1 > MAP_x || x1 < 1 || x2 > MAP_x || x2 < 1 )
  { return false;
  }
  if( y1 > MAP_y || y1 < 1 || y2 > MAP_y || y2 < 1 )
  { return false;
  }

  // Carve out the Room
  foreach( index_y; y1 .. (y2 + 1) )
  {
    foreach( index_x; x1 .. (x2 + 1) )
    {
      m.t[index_y][index_x] = TERRAIN_FLOOR;
    }
  }

  return true;
} // bool add_room( uint, uint, uint, uint, Map* )

// Carves a room into the given map using a Room struct
bool add_room( Room r, Map* m )
{
  return add_room( r.y1, r.x1, r.y2, r.x2, m );
} // bool add_room( Room, Map* )

// SECTION 4: ////////////////////////////////////////////////////////////////
// Decorative Map Beautifying Functions                                     //
//////////////////////////////////////////////////////////////////////////////

static if( FOLIAGE )
{
// Grows mold in the given map
void grow_mold( Map* m )
{
  import std.random;

  // This is the number of seeds we're going to have for mold growths:
  int num_molds = td10();

  if( num_molds > 0 )
  {
    foreach( c; 1 .. num_molds )
    {
      // This is the maximum number of Tiles this mold growth will affect:
      int mold_len = d100();

      // Choose coordinates where our mold growth will start:
      int x = uniform( 0, MAP_X, Lucky );
      int y = uniform( 0, MAP_Y, Lucky );

      // Now we begin growing mold:
      foreach( d; 1 .. mold_len )
      {
        // Place mold on the current Tile:
        m.t[y][x].hazard |= SPECIAL_MOLD;

        // Now decide a random direction to move in:
        final switch( uniform( 0, 10, Lucky ) )
        {
          // You may notice that values which modify x are slightly more
          // common; this is to encourage the mold to spread out along the
          // wider x axis and fill more of the Map
          case 0: x--; y--; break;
          case 1:
          case 2: x--;      break;
          case 3: x--; y++; break;
          case 4:      y++; break;
          case 5:      y--; break;
          case 6: x++; y--; break;
          case 7:
          case 8: x++;      break;
          case 9: x++; y++; break;
        }

        // Terminate growing mold if we hit the edge of the Map
        if( x >= MAP_X || x < 0 ) break;
        if( y >= MAP_Y || y < 0 ) break;
      } // foreach( d; 1 .. mold_len )
    } // foreach( c; 1 .. num_molds )
  } // if( num_molds > 0 )

  // Also grow mold around pools of water by first searching for water Tiles:
  foreach( y; 0 .. MAP_Y )
  {
    foreach( x; 0 .. MAP_X )
    {
      if( m.t[y][x].hazard & HAZARD_WATER )
      {
        // 1 in 4 chance the Tile will have mold growing near it...
        if( dn(4) == 1 )
        {
          // Grow mold in a random Tile near the water...
          int trux, truy;

          do
          {
            trux = flip() ? x : flip() ? x + 1 : x - 1;
            truy = flip() ? y : flip() ? y + 1 : y - 1;
          } while( trux == x && truy == y );

          // Cancel here if x or y are out of bounds
          if( trux >= MAP_X || trux < 0 ) continue;
          if( truy >= MAP_Y || truy < 0 ) continue;

          m.t[y][x].hazard |= SPECIAL_MOLD;
        }
      }
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
  Map nu;

  nu.player_start = [ 1, 1 ];

  foreach( y; 0 .. MAP_Y )
  {
    foreach( x; 0 .. MAP_X )
    {
      nu.i[y][x] = No_item;
      if( y == 0 || y == MAP_y || x == 0 || x == MAP_x )
      {
        nu.t[y][x] = TERRAIN_WALL;
      }
      else
      {
        if( (y < 13 && y > 9) && ((x > 19 && x < 24) || (x < 61 && x > 56)) )
        { nu.t[y][x] = TERRAIN_WALL;
        }
        else
        {
          if( (y < 13 && y > 9) && (x > 30 && x < 50) )
          { nu.t[y][x] = TERRAIN_WATER;
          }
          else
          { nu.t[y][x] = TERRAIN_FLOOR;
          }
        } /* else from if( (y < 13 && y > 9) ... */
      } /* else from if( y == 0 || y == MAP_y ... */
    } /* foreach( x; 0 .. MAP_X ) */
  } /* foreach( y; 0 .. MAP_Y ) */

static if( FOLIAGE )
{
  grow_mold( &nu );
}

  // test Monsters

  Monst goobling = new_monst_at( 'g', "goobling", 0, 0, 2, 2, 0, 10, 2, 0, 2,
                                 1000, 60, 20 );
  goobling.sym.color = Colors.Dark_Gray;

  add_mon( &nu, goobling );

static if( false ) /* never */
{
  goobling.x = 50;
  add_mon( &nu, goobling );
  goobling.y = 10;
  add_mon( &nu, goobling );
}

  // test Items

  // a test Item "old sword" which grants a +2 bonus to the player's
  // attack roll
  Item old_sword = Item( Symbol( '(', Colors.Gray ), "old sword",
                         Type.weapon, Armor.none, 0, 2 );
  nu.i[10][5] = old_sword;

  Item shield = Item( Symbol( ']', Colors.Dark_Gray ), "crow-crested shield",
                      Type.armor, Armor.shield, 0, 5 );
  nu.i[11][5] = shield;

  Item ring = Item( Symbol( '*', Colors.Silver ), "silver ring",
                    Type.jewelery, Armor.ring, 0, 0 );
  nu.i[10][2] = ring;

  ring.sym.color = Colors.Gold;  ring.name = "gold ring";
  nu.i[10][1] = ring;

  Item helmet = Item( Symbol( ']', Colors.Brown ), "hat",
                      Type.armor, Armor.helmet, 0, 0 );
  nu.i[10][3] = helmet;

  Item scarf = Item( Symbol( ']', Colors.Green ), "fluffy scarf",
                     Type.armor, Armor.neck, 0, 0 );
  nu.i[11][3] = scarf;

  Item tunic = Item( Symbol( ']', Colors.Brown ), "tunic",
                     Type.armor, Armor.cuirass, 0, 0 );
  nu.i[12][3] = tunic;

  Item gloves = Item( Symbol( ']', Colors.Brown ), "pair of leather gloves",
                      Type.armor, Armor.bracers, 0, 1 );
  nu.i[13][3] = gloves;

  Item pants = Item( Symbol( ']', Colors.Brown ), "pair of trousers",
                     Type.armor, Armor.greaves, 0, 0 );
  nu.i[14][3] = pants;

  Item kilt = Item( Symbol( ']', Colors.Green ), "plaid kilt",
                    Type.armor, Armor.kilt, 0, 0 );
  nu.i[15][3] = kilt;

  Item boots = Item( Symbol( ']', Colors.Brown ), "pair of shoes",
                     Type.armor, Armor.feet, 0, 0 );
  nu.i[16][3] = boots;

  Item tailsheath = Item( Symbol( ']', Colors.Brown ), "leather tailsheath",
                          Type.armor, Armor.tail, 0, 1 );
  nu.i[17][3] = tailsheath;
  
  return nu;
}

}
