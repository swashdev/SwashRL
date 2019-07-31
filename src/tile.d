/*
 * Copyright 2015-2019 Philip Pavlick
 *
 * This software is provided 'as-is', without any express or implied
 * warranty.  In no event will the authors be held liable for any damages
 * arising from the use of this software.
 * 
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 * 
 * 1. The origin of this software must not be misrepresented; you must not
 *    claim that you wrote the original software. If you use this software
 *    in a product, an acknowledgment in the product documentation would be
 *    appreciated but is not required.
 * 2. Altered source versions must be plainly marked as such, and must not be
 *    misrepresented as being the original software.
 * 3. This notice may not be removed or altered from any source distribution.
 */

// tile.d:  Defines the `Tile` struct and the `Terrain` enum

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
