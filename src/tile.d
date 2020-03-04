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

// tile.d: defines structures related to map tile data

import global;

/++
 + The Tile struct
 +
 + This struct defines a map tile.  It does this using the following assets:
 +
 + `sym`: A `Symbol` used to define the tile's appearance in the display
 +
 + `block_cardinal_movement`: A `bool` which prevents monsters from moving in
 + cardinal directions through the tile
 +
 + `block_diagonal_movement`: A `bool` which prevents monsters from moving in
 + diagonal directions through the tile
 +
 + `block_vision`: A `bool` which prevents the player from seeing the tile or
 + spaces behind it
 +
 + `lit`: A `bool` which determines whether or not the tile is illuminated
 + (not currently implemented)
 +
 + `seen`: A `bool` which determines whether or not the player has seen this
 + tile already.  Used for map memory.
 +
 + `hazard`: A `ushort` containing flags which indicate what hazards and other
 + special properties the tile has.
 +/
struct Tile
{
  // the tile's symbol--this can be easily overwritten by functions intended
  // to change the properties of the tile
  Symbol sym;
  
  // attribute booleans
  // block_cardinal_movement and block_diagonal_movement do exactly what it
  // says on the tin.  The reason these are separated is because we need
  // some tiles to block only diagonal movement (like doors).
  bool block_cardinal_movement;
  bool block_diagonal_movement;

  // blocks *all* vision going through the tile
  bool block_vision;

  // determine if the tile is lit
  bool lit;

  // determine if the player has seen this tile before
  bool seen;

  // a bitmask to determine if there are any hazards on this tile; use this
  // carefully, as some hazards might conflict (can't have a pit and a pool of
  // water on the same tile!)
  // note: this flag could potentially be used for other special tiles, not
  // just hazards--the sky's the limit when you're programming your own
  // universe!
  uint hazard;
}

/++
 + A list of standard terrain elements
 +
 + This enum defines and names standard map tiles to be used by level
 + generation code.
 +
 + See_Also:
 +   <a href="#Tile">Tile</a>
 +/
enum Terrain {
  floor = Tile( SYM_FLOOR, false, false, false, true, false, 0            ),
  wall  = Tile( SYM_WALL,  true,  true,  true,  true, false, 0            ),
  water = Tile( SYM_WATER, false, false, false, true, false, HAZARD_WATER ),
  door  = Tile( SYM_DOOR,  false, true,  true,  true, false, 0            )
}
