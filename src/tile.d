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

// A struct for storing map tile data.
struct Tile
{
    // The symbol used to represent this map tile.
    Symbol sym;
  
    // Cardinal and diagonal movement are blocked separately beacuse some map
    // tiles like doors only block diagonal movement.
    bool block_cardinal_movement;
    bool block_diagonal_movement;

    // Disable seeing through this tile.
    bool block_vision;

    // Determines if the tile is illuminated.
    bool lit;

    // Determine if the player has seen this tile (in NetHack this is called
    // "memory.")
    bool seen;

    // A bitmask to determine if there are any hazards on this tile; use this
    // carefully, as some hazards might conflict (can't have a pit and a pool
    // of water on the same tile!)
    // note: this flag could potentially be used for other special tiles, not
    // just hazards--the sky's the limit when you're programming your own
    // universe!
    uint hazard;
} // struct Tile

// A collection of standard terrain elements.
static Tile TERRAIN_FLOOR,
            TERRAIN_WALL,
            TERRAIN_WATER,
            TERRAIN_DOOR;

// Initialize the standard terrain elements.
void init_terrain()
{
    TERRAIN_FLOOR = Tile( SYM_FLOOR, false, false, false, true, false, 0 );
    TERRAIN_WALL  = Tile( SYM_WALL,  true,  true,  true,  true, false, 0 );
    TERRAIN_WATER = Tile( SYM_WATER, false, false, false, true, false,
                          HAZARD_WATER );
    TERRAIN_DOOR  = Tile( SYM_DOOR,  false, true,  true,  true, false, 0 );
}
