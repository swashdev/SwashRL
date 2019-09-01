/*
 * Copyright (c) 2015-2019 Philip Pavlick.  See '3rdparty.txt' for other
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
 * ARE DISCLAIMED. IN NO EVENT SHALL Elijah Stone BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
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
