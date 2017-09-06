/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
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

  // to be used when we implement map memory
  bool seen;

  // determine if the tile is lit
  bool lit;

  // a bitmask to determine if there are any hazards on this tile; use this
  // carefully, as some hazards might conflict (can't have a pit and a pool of
  // water on the same tile!
  // note: this flag could potentially be used for other special tiles, not
  // just hazards--the sky's the limit when you're programming your own
  // universe!
  short hazard;
}

tile tiledata( symbol sym, bool block_c, bool block_d, bool block_v,
               bool light, short special );

bool block_movement( tile t );
bool block_all_movement( tile t );

tile Floor();
tile Wall();
tile Water();
