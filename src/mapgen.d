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
enum MAX_ROOM_X = 10, MAX_ROOM_Y = 6;

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
  uint room_width  = cast(uint)random.uniform( "[]", MIN_ROOM_X, MAX_ROOM_X, Lucky );
  uint room_height = cast(uint)random.uniform( "[]", MIN_ROOM_Y, MAX_ROOM_Y, Lucky );

  r.x1 = cast(uint)random.uniform( 1, (80 - MAX_ROOM_X), Lucky );
  r.x2 = r.x1 + room_width;
  r.y1 = cast(uint)random.uniform( 1, (22 - MAX_ROOM_Y), Lucky );
  r.y2 = r.y1 + room_height;

  return r;

} // Room random_Room()

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
 +   m  The `Map` that we are searching for an appropriate wall
 +   y  A pointer to the y coordinate that will be generated for the selected
 +      wall.
 +   x  A pointer to the x coordinate that will be generated for the selected
 +      wall.
 +/
void select_random_adjacent_wall( Map m, byte* y, byte* x )
{

  // We're going to store a two-dimensional array representing valid
  // coordinates, since that's faster than checking each wall for adjacent
  // floor tiles
  bool[MAP_X][MAP_Y] valid;

  foreach( row in valid )  foreach( col in row )  valid[row][col] = false;

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
        if( _x > 0 )  if( !m.t[_x - 1][_y].block_cardinal_movement )
        { valid[_x - 1][_y] = true;
        }
        if( _x < (MAP_X - 1) )  if( !m.t[_x + 1][_y].block_cardinal_movement )
        { valid[_x + 1][_y] = true;
        }
        if( _y > 0 )  if( !m.t[_x][_y - 1].block_cardinal_movement )
        { valid[_x][_y - 1] = true;
        }
        if( _y < (MAP_Y - 1) )  if( !m.t[_x][_y + 1].block_cardinal_movement )
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
  foreach( row in valid )
  {
    if( got_valid )  break;

    foreach( col in row )
    {
      if( col == true )
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
    x = cast(byte)random.uniform( 1, MAP_X, Lucky );
    y = cast(byte)random.uniform( 1, MAP_Y, Lucky );
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
 +   mold  If `true`, grows mold on the generated level.  Has no effect if
 +         `FOLIAGE` is false at compile time.
 +
 + Returns:
 +   A `Map` level generated using Anderson's algorithm.
 +/
Map gen_anderson( bool mold = true )
{

  // 1. Fill the whole map with solid earth
  Map m = empty_Map();

  // 2. Dig out a single room in the centre of the map
  Room r[] = { random_Room() };
  add_room( r[0], m );

  // 3. Pick a random wall.  Obviously since the map is composed _mostly_ of
  // walls, we'll want to pick one that's actually connected to something.
  // I've written a function that gets us some good coordinates.
  int wall;
  uint x1, y1;
anderson_step_3:
  r1 = r.length > 1 ? r.choice( Lucky ) : r[0];

  // I'll just use the movement enums for the direction flags, no need to get
  // all redundant about this.
  wall = [MOVE_NORTH, MOVE_SOUTH, MOVE_EAST, MOVE_WEST].choice( Lucky );

  // Now we need starting coordinates for the "scan" in step 5.
  switch( wall )
  {

    case MOVE_NORTH:
      y1 = r.y1 - 1;
      x1 = random.uniform( r.x1, r.x2 + 1, Lucky );
      break;

    case MOVE_SOUTH:
      y1 = r.y2 + 1;
      x1 = random.uniform( r.x1, r.x2 + 1, Lucky );
      break;

    case MOVE_EAST:
      x1 = r.x2 + 1;
      y1 = random.uniform( r.y1, r.y2 + 1, Lucky );
      break;

    case MOVE_WEST:
      x1 = r.x1 - 1;
      y1 = random.uniform( r.y1, r.y2 + 1, Lucky );
      break;

  } // switch( wall )

  return mp;

} // Map gen_anderson( bool? )
