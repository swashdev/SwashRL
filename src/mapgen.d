/*
 * Copyright 2016-2019 Philip Pavlick
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License.  You may obtain a copy
 * of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * SwashRL is distributed with a special exception to the normal Apache
 * License 2.0.  See LICENSE for details.
 */

/* mapgen.d -- dungeon generator functions */

import std.random;

import global;

// Some universal configuration variables:
enum MIN_ROOM_X =  3, MIN_ROOM_Y = 3;
enum MAX_ROOM_X = 10, MAX_ROOM_Y = 5;

/++
 + Generates a random `Room`
 +
 + This is your one-stop random room generator.  It uses the enums
 + `MIN_ROOM_X`, `MIN_ROOM_Y`, `MAX_ROOM_X`, and `MAX_ROOM_Y` as the
 + dimensions of the room.
 +
 + Returns:
 +   A `Room` struct.
 +/
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
  int[4][12] sectors =
  [ [1, 19,  1,  7], [21, 39,  1,  7], [41, 59,  1,  7], [61, 79,  1,  7],
    [1, 19,  9, 13], [21, 39,  9, 13], [41, 59,  9, 13], [61, 79,  9, 13],
    [1, 19, 15, 21], [21, 39, 15, 21], [41, 59, 15, 21], [61, 79, 15, 21]
  ];

  Room[12] rs;
  size_t s;
  for( s = 0; s < sectors.length; s++ )
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
    r.x1 = uniform!"[]"( sectors[s][0], sectors[s][1] - MIN_ROOM_X, Lucky );
    r.x2 = uniform!"[]"( r.x1 + MIN_ROOM_X, sectors[s][1], Lucky );
    r.y1 = uniform!"[]"( sectors[s][2], sectors[s][3] - MIN_ROOM_Y, Lucky );
    r.y2 = uniform!"[]"( r.y1 + MIN_ROOM_Y, sectors[s][3], Lucky );

    rs[s] = r;
  } // for( size_t s = 0; s < sectors.length; s++ )

  Map m;

  // Now we go through the list of generated rooms and carve out the ones that
  // are "real rooms"
  for( s = 0; s < rs.length; s++ )
  {
    if( 0 >= (rs[s].x2 - rs[s].x1) )  continue;
    add_room( rs[s], &m );

    
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
