/*
 * Copyright 2016-2018 Philip Pavlick
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License, excepting that
 * Derivative Works are not required to carry prominent notices in changed
 * files.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import global;

// New in version 0.021--tiles are a struct rather than a bitmask.  Hopefully
// this doesn't blow up in my face.
struct tile
{
  // the tile's symbol--this can be easily overwritten by functions intended
  // to change the properties of the tile
  symbol sym;
  
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
  ushort hazard;
}

enum Terrain {
  floor = tile( SYM_FLOOR, false, false, false, true, false, 0            ),
  wall  = tile( SYM_WALL,  true,  true,  true,  true, false, 0            ),
  water = tile( SYM_WATER, false, false, false, true, false, HAZARD_WATER ),
  door  = tile( SYM_DOOR,  false, true,  true,  true, false, 0            )
}
