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

// mapalgo.d: defines functions related to map generation algorithms

public import global;
import std.random;

/++
 + Generates an empty `Map`
 +/
Map empty_Map()
{
  Map m;
  foreach( y; 0 .. MAP_Y )
  {
    foreach( x; 0 .. MAP_X )
    {
      m.i[y][x] = No_item;
      m.t[y][x] = Terrain.wall;
    }
  }

  m.player_start = [ 0, 0 ];

  return m;
}

/++
 + Randomly generates a new `Map`
 +
 + This function will generate a new dungeon level.  This is accomplished by
 + splitting the `Map` into nine sectors, placing a `Room` within each sector,
 + and then randomly connecting them with corridors.
 +
 + Currently, the function is written to guarantee that there will always be a
 + path which connects all of the Rooms, but there are no checks to prevent
 + the Rooms from overlapping.
 +
 + If `FOLIAGE` is `true`, this function will also `grow_mold` in the Map
 + before returning it.
 +
 + See_Also:
 +   <a href="#add_corridor_y">add_corridor_y</a>,
 +   <a href="#add_corridor_x">add_corridor_x</a>,
 +   <a href="#add_room">add_room</a>
 +
 + Returns:
 +   A `Map` with Rooms and corridors randomly generated
 +/
Map generate_new_map()
{
  Map m = gen_simple_roguelike( FOLIAGE );

  return m;
}

/++
 + Generates a simple, Rogue-like level
 +
 + This is the simplest of the dungeon generator algorithms, and uses a simple
 + version of the map generation algorithm that Rogue used, for a very
 + traditional-feeling level.
 +
 + Origin:  http://www.roguebasin.com/index.php?title=Simple_Rogue_levels
 +
 + Params:
 +   mold = If `true`, generates mold on the generated map.  Has no effect if
 +          `FOLIAGE` is set to `false` at compile time.
 +
 + Returns:
 +   A `Map` representing a generated level.
 +/
Map gen_simple_roguelike( bool mold = true )
{
  // The `Map` to be returned
  Map m = empty_Map();

  // A list of `r`oom`s`
  Room[12] rs;

  size_t s;
  for( s = 0; s < SECTORS.length; s++ )
  {
version( none )
{
    // Randomly decide whether or not to put an "actual room" in this sector
    // If we choose not to put a room here, use a placeholder "zero-size" room
    if( 0 == td10() )
    {
      rs[s] = Room( 0, 0, 0, 0 );
      continue;
    }
}

    Room r;

    // Get the coordinates for the upper-left corner of the room:
    r.x1 = uniform!"[]"( SECTORS[s][0], SECTORS[s][1] - MIN_ROOM_X, Lucky );
    r.y1 = uniform!"[]"( SECTORS[s][2], SECTORS[s][3] - MIN_ROOM_Y, Lucky );

    // Adjust x1 & y1 to ensure they are odd numbers:
    if( r.x1 % 2 == 0 )  r.x1--;
    if( r.y1 % 2 == 0 )  r.y1--;

    // Next, decide on a height and width:
    int w = uniform!"[]"( MIN_ROOM_X, MAX_ROOM_X, Lucky );
    int h = uniform!"[]"( MIN_ROOM_Y, MAX_ROOM_Y, Lucky );

    // Assign x2 & y2 accordingly:
    r.x2 = r.x1 + w;
    r.y2 = r.y1 + h;

    // Adjust x2 & y2 to fit the sector:
    if( r.x2 > SECTORS[s][1] ) r.x2 = SECTORS[s][1];
    if( r.y2 > SECTORS[s][3] ) r.y2 = SECTORS[s][3];

    // Adjust x2 & y2 to ensure they are odd numbers:
    if( r.x2 % 2 == 0 )  r.x2--;
    if( r.y2 % 2 == 0 )  r.y2--;

    // Add the room to the array:
    rs[s] = r;
  } // for( size_t s = 0; s < SECTORS.length; s++ )

  // Give the list of rooms to the generated map:
  m.r = rs;

  // Add the player to a random location in a random room on the map:
  Room pr = rs[uniform( 0, 8, Lucky )];

  ubyte px = cast(ubyte)uniform!"[]"( pr.x1, pr.x2, Lucky );
  ubyte py = cast(ubyte)uniform!"[]"( pr.y1, pr.y2, Lucky );

  m.player_start = [py, px];

  // Now we go through the list of generated rooms and carve out the ones that
  // are "real rooms"
  for( s = 0; s < rs.length; s++ )
  {
    if( 0 >= (rs[s].x2 - rs[s].x1) )  continue;
    add_room( rs[s], &m );

    
  }

  // This shuffled list of numbers will represent indexes for both the sectors
  // of the map and the rooms we just generated contained within each sector.
  int[8] sectors = [0, 1, 2, 3, 4, 5, 6, 7].randomShuffle( Lucky );

  // For each pair of sectors adjacent to each other in the shuffled array,
  // we'll connect them with a corridor.
  for( int counter = 0; counter < 7; counter++ )
  {
    int counter2 = counter + 1;
    // Carve a corridor connecting the first chosen ROOM with the second chosen
    // SECTOR.  We will always pick odd numbers for our starting and ending
    // coordinates, to avoid interfering with the rigid boundaries of
    // already-generated rooms; however, we will allow corridors to intersect
    // rooms.

    int index1 = sectors[counter], index2 = sectors[counter2];
  
    int start_x = uniform!"[]"( rs[index1].x1, rs[index1].x2, Lucky );
    int start_y = uniform!"[]"( rs[index1].y1, rs[index1].y2, Lucky );
    int mid_x   = uniform!"[]"( SECTORS[index2][0], SECTORS[index2][1],
                                Lucky );
    int mid_y   = uniform!"[]"( SECTORS[index2][2], SECTORS[index2][3],
                                Lucky );

    // Ensure the generated numbers are always odd
    if( start_x % 2 == 0 )  start_x--;
    if( start_y % 2 == 0 )  start_y--;
    if( mid_x   % 2 == 0 )  mid_x--;
    if( mid_y   % 2 == 0 )  mid_y--;

    // Carve the resulting corridor:
    add_corridor( &m, start_x, start_y, mid_x, mid_y );

    // Now check if our midpoint is inside the room we want to connect to.  If
    // it is, job done.  Otherwise, select new coordinates.
    if( within_minmax( mid_x, rs[index2].x1, rs[index2].x2 )
     && within_minmax( mid_y, rs[index2].y1, rs[index2].y2 ) )
    { continue;
    }

    int end_x = uniform!"[]"( rs[index2].x1, rs[index2].x2, Lucky );
    int end_y = uniform!"[]"( rs[index2].y1, rs[index2].y2, Lucky );

    // Again. make sure our coordinates are odd:
    if( end_x % 2 == 0 )  end_x--;
    if( end_y % 2 == 0 )  end_y--;

    // Carve the corridor.  Note that the way that the corridors are generated
    // means that the generation algorithm may double back on itself, creating
    // dead ends.  Since this isn't an undesireable effect, we'll let this
    // slide.
    add_corridor( &m, mid_x, mid_y, end_x, end_y );
  } // for( int counter = 0; counter < 7; counter++ )
  

static if( FOLIAGE )
{
  // Plant mold in the Map:
  if( mold )  grow_mold( &m );
}

  return m;
} // Map gen_simple_roguelike( bool? )

// Deferred Anderson's algorithm for a future release
version( none )
{

/++
 + Get coordinates for an appropriate wall from the given `Map`
 +
 + This function gets coordinates of a wall appropriate for map-generation
 + algorithms.  Because the map is mostly composed of walls, this function
 + is used to randomly select coordinates and then check that the selected
 + coordinate is a wall _and_ is adjacent to a non-wall (preferably floor)
 + coordinate.
 +
 + Params:
 +   m = The `Map` that we are searching for an appropriate wall
 +   y = A pointer to the y coordinate that will be generated for the selected
 +       wall.
 +   x = A pointer to the x coordinate that will be generated for the selected
 +       wall.
 +/
void select_random_adjacent_wall( Map m, byte* y, byte* x )
{

  // We're going to store a two-dimensional array representing valid
  // coordinates, since that's faster than checking each wall for adjacent
  // floor tiles
  bool[MAP_X][MAP_Y] valid;

  // Initialize `valid` with `false` values
  for( int _x = 0; _x < MAP_X; _x++ )
  {
    for( int _y = 0; _y < MAP_Y; _y++ )
    { valid[_x][_y] = false;
    }
  }

  // First we'll check to make sure that the map does indeed contain non-wall
  // tiles.  In other words, we're checking to make sure the map isn't empty.
  // While we're doing this, we'll also populate `valid` by checking each
  // floor-like tile for adjacent walls
  bool empty_map = true;
  for( int _x = 0; _x < MAP_X; _x++ )
  {

    for( int _y = 0; _y < MAP_Y; _y++ )
    {
      // Check what directions the tile at (_x, _y) blocks.  As a shortcut,
      // we're also going to veto door tiles, so we don't accidentally end up
      // with branching paths inside doorways.  Since both walls and doors
      // block cardinal movement, that's the only variable we need to check.
      if( !m.t[_x][_y].block_cardinal_movement )
      {
        // Mark the map as non-empty
        empty_map = false;

        // Now we check adjacent tiles to see if they are walls.  If so, we're
        // going to set the value corresponding to these coordinates in
        // `valid` to `true`.
        // Note that we're only checking in cardinal directions.
        if( _x > 0 )  if( m.t[_x - 1][_y].block_cardinal_movement )
        { valid[_x - 1][_y] = true;
        }
        if( _x < (MAP_X - 1) )  if( m.t[_x + 1][_y].block_cardinal_movement )
        { valid[_x + 1][_y] = true;
        }
        if( _y > 0 )  if( m.t[_x][_y - 1].block_cardinal_movement )
        { valid[_x][_y - 1] = true;
        }
        if( _y < (MAP_Y - 1) )  if( m.t[_x][_y + 1].block_cardinal_movement )
        { valid[_x][_y + 1] = true;
        }

      } // if( !m.t[_x][_y].block_cardinal_movement )

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

  // Next we're going to double-check and make sure we actually got some sets
  // of valid coordinates.  If for whatever reason this function was passed a
  // map that gave only floor tiles, `valid` won't contain any valid
  // coordinates.
  bool got_valid = false;
  foreach( row; valid )
  {
    if( got_valid )  break;

    foreach( col; row )
    {
      if( row[col] == true )
      {
        got_valid = true;
        break;
      }
    }
  }

  // If we did _not_ get any valid coordinates, return some placeholder values
  if( !got_valid )  goto did_not_get_adjacent_wall;

  // If the map is _not_ empty, we now have a two-dimensional array, `valid`,
  // filled with boolean values representing valid wall coordinates.  We're
  // now going to start selecting random x and y coordinates until we get a
  // `true` value from those coordinates in `valid`.
  do
  {
    x = cast(byte)uniform( 1, MAP_X, Lucky );
    y = cast(byte)uniform( 1, MAP_Y, Lucky );
  } while( valid[x][y] == false );

} // void select_random_adjacent_wall( Map, byte*, byte* )

/++
 + Generates a `Map` using Mike Anderson's algorithm
 +
 + This is a rooms-and-corridors map generator algorithm taken from
 + RogueBasin.  The algorithm was written by Mike Anderson and implemented for
 + SwashRL in D by Philip Pavlick.
 +
 + Origin:
 +   http://www.roguebasin.com/index.php?title=Dungeon-Building_Algorithm
 +
 + Params:
 +   mold = If `true`, grows mold on the generated level.  Has no effect if
 +          `FOLIAGE` is `false` at compile time.
 +
 + Returns:
 +   A `Map` level generated using Anderson's algorithm.
 +/
Map gen_anderson( bool mold = true )
{

  int reps = 0;

  // 1. Fill the whole map with solid earth
  Map m = empty_Map();

  // 2. Dig out a single room in the centre of the map
  Room[] r = { random_Room() };
  add_room( r[0], m );

  // 3. Pick a random wall.  Obviously since the map is composed _mostly_ of
  // walls, we'll want to pick one that's actually connected to something.
  // I've written a function that gets us some good coordinates.
  uint x1, y1;
  int dir;
anderson_step_3:
  // Check how many times we've repeated the scan-and-add process.  On
  // RogueBasin, Anderson recommended 400-500 repetitions.
  if( rep < 500 )  rep++;
  else  return m;

  select_random_adjacent_wall( m, &x1, &y1 );

  // Determine which floor tile this wall is adjacent to and as such what
  // direction we'll be moving in.
  dir = -1;
  if( x1 > 0 )  if( !m.t[x1 - 1][y1].blocks_cardinal_movement )
  { dir = MOVE_EAST;
  }
  if( x1 < (MAP_X - 1) )  if( !m.t[x1 + 1][y1].blocks_cardinal_movement )
  { dir = MOVE_WEST;
  }
  if( y1 > 0 )  if( !m.t[x1][y1 - 1].blocks_cardinal_movement )
  { dir = MOVE_SOUTH;
  }
  if( y1 < (MAP_Y - 1) )  if( !m.t[x1][y1 + 1].blocks_cardinal_movement )
  { dir = MOVE_NORTH;
  }

  // If for whatever reason we didn't get a valid direction, abort and try
  // again.
  if( dir <= 0 )  goto anderson_step_3;

  return m;

} // Map gen_anderson( bool? )

} // version( none )
