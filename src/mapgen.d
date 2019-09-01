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

// Universal size configs for rooms:
enum MIN_ROOM_X =  4, MIN_ROOM_Y = 4;
enum MAX_ROOM_X = 18, MAX_ROOM_Y = 8;

// Universal limits to coordinates permissible inside cooridors:
enum MIN_HALL_X = 2, MAX_HALL_X = 76;
enum MIN_HALL_Y = 2, MAX_HALL_Y = 18;

const int[4][8] SECTORS =
[ [1, 19,  1,  9], [21, 37,  1,  9], [39, 55,  1,  9], [57, 77,  1,  9],
  [1, 19, 11, 19], [21, 37, 11, 19], [39, 55, 11, 19], [57, 77, 11, 19]
];

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
 + Generates a corridor, which may include corners, between two points on the
 + given map.
 +/
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
