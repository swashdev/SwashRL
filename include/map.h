/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */
#ifndef MAP_VARIABLE
# define MAP_VARIABLE

# include "global.h"

/* Defines a struct ``map'' which stores map data, including map tiles and
 * monsters and items on the map */

typedef struct
{
  tile  t[MAP_Y][MAP_X];
  /* `v' is our array of which tiles are visible */
  bool  v[MAP_Y][MAP_X];
  monst m[NUMTILES];
  uint16 m_siz;
  item i[MAP_Y][MAP_X];
} map;

map new_map();

map test_map();

void add_mon( map* mp, monst mn );

void remove_mon( map* mp, uint16 index );

#endif /* !MAP_VARIABLE */
