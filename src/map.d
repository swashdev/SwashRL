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

import global;

// A `struct' used to store `Room's for the Map generation code
struct Room
{
  int x1, y1, x2, y2;
}

// Defines a struct ``Map'' which stores Map data, including Map Tiles and
// Monsters and Items on the Map

/++
 + The Map struct
 +
 + This struct defines a Map.
 +
 + It contains a two-layered array of `Tile`s, `t`, which represents Map
 + Tiles; a dynamic array of `Monst`s, `m`, which represents the Monsters on
 + the Map; a two-layered array of `Item`s, `i`, which represents the Items
 + contained on each Tile of the Map.
 +
 + The Map also contains an array of two `ubyte`s, `player_start`, which
 + represents where the player starts out when the Map is loaded.  This is
 + currently only used for opening save files.
 +
 + The Map also contains an array of nine `Room`s, `r`, which is not currently
 + used by any function.
 +/
struct Map
{
  Tile[MAP_X][MAP_Y]   t; // `t'iles
  Monst[]              m; // 'm'onsters
  Item[MAP_X][MAP_Y]   i; // 'i'tems

  Room[12] r;

  bool[MAP_X][MAP_Y] v; // 'v'isibility

  ubyte[2] player_start;

}

/++
 + Adds a Monster to the given Map.
 +
 + This function adds a given `Monst` to the given `Map`'s `m` array.
 +
 + See_Also:
 +   <a href="#remove_mon">remove_mon</a>
 +
 + Params:
 +   mp = A pointer to the Map which mn is to be added to.  mp will be changed
 +        by the function, hence why it needs to be a pointer.
 +   mn = The Monster to be added to mp.
 +/
void add_mon( Map* mp, Monst mn )
{
  size_t mndex = mp.m.length;
  if( mndex < NUMTILES )
  {
    mp.m.length++;
    mp.m[mndex] = mn;
  }
}

/++
 + Removes a Monster from the given Map.
 +
 + This function will remove the Monster given by index from `mp`'s `m` array.
 + The Monster is removed by overwriting it with all of the Monsters to the
 + right of it in the array and then truncating the length of the array.
 +
 + See_Also:
 +   <a href="#add_mon">add_mon</a>
 +
 + Params:
 +   mp    = A pointer to the Map which the Monster at index is to be removed
 +           from.  mp will be changed by the function, hence why it needs to
 +           be a pointer.
 +   index = The index in `mp.m` which is to be removed.
 +/
void remove_mon( Map* mp, uint index )
{
  // To remove a Monster in a Map's mon array, move all Monsters that are
  // past it in the array up, thus overwriting it.
  if( index < mp.m.length )
  {
    foreach( mn; index + 1 .. mp.m.length )
    { mp.m[mn - 1] = mp.m[mn];
    }
    mp.m.length--;
  }
}
