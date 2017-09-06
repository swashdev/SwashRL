/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */

import "global.h";

// Defines a struct ``map'' which stores map data, including map tiles and
// monsters and items on the map

struct map
{
  tile[MAP_Y][MAP_X] t; // `t'iles
  static if( USE_FOV )
  { bool[MAP_Y][MAP_X] v; // 'v'isibility
  }
  monst[NUMTILES]    m; // 'm'onsters
  item[MAP_Y][MAP_X] i; // 'i'tems
}

map new_map();

map test_map();

void add_mon( map* mp, monst mn );

void remove_mon( map* mp, ushort index );
