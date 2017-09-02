/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */
#include "global.h"

map new_map()
{
  map nu;
  nu.m_siz = 0;
  return nu;
}

void add_mon( map* mp, monst mn )
{
  unsigned int mndex = mp->m_siz;
  if( mndex < NUMTILES )
  {
    mp->m[mndex] = mn;
    mp->m_siz = mndex + 1;
  }
}

void remove_mon( map* mp, uint16 index )
{
  /* To remove a monster in a map's mon array, move all monsters that are
   * past it in the array up, thus overwriting it. */
  if( index < mp->m_siz )
  {
    int mn, max;
    for( mn = index + 1, max = mp->m_siz; mn < max; mn++ )
    {
      mp->m[mn - 1] = mp->m[mn];
    }
    mp->m_siz = max - 1;
  }
}

map test_map()
{
  map nu = new_map();

  uint8 y, x;
  for( y = 0; y < MAP_Y; y++ )
    for( x = 0; x < MAP_X; x++ )
    {
      nu.i[y][x] = No_item;
      if( y == 0 || y == MAP_y || x == 0 || x == MAP_x )
      {
	nu.t[y][x] = T_WALL;
      }
      else
      {
	if( (y < 13 && y > 9) && ((x > 19 && x < 24) || (x < 61 && x > 56)) )
	  nu.t[y][x] = T_WALL;
	else
	{
	  if( (y < 13 && y > 9) && (x > 30 && x < 50) )
	    nu.t[y][x] = T_WATER;
	  else
	    nu.t[y][x] = T_FLOOR;
	}
      }
    }

  monst goobling = new_monst_at( 'g', "goobling", 0, 0, 2, 2, 0, 10, 2, 0, 2,
                                 1000, 60, 20 );

  add_mon( &nu, goobling );

#if 0
  goobling.x = 50;
  add_mon( &nu, goobling );
  goobling.y = 10;
  add_mon( &nu, goobling );
#endif

  /* test items */

  /* a test item "old sword" which grants a +2 bonus to the player's
   * attack roll */
  item old_sword = { .sym = symdata( '(', A_NORMAL ),
                     .name = "old sword",
                     .type = ITEM_WEAPON, .equip = EQUIP_NO_ARMOR,
                     .addd = 0, .addm = 2 };
  nu.i[10][5] = old_sword;

  item ring = { .sym = symdata( '=', A_NORMAL ),
                .name = "tungsten ring",
                .type = ITEM_JEWELERY, .equip = EQUIP_JEWELERY_RING,
                .addd = 0, .addm = 0 };
  nu.i[10][2] = ring;
  nu.i[10][1] = ring;
  item helmet = { .sym = symdata( ']', A_NORMAL ),
                  .name = "hat",
                  .type = ITEM_ARMOR, .equip = EQUIP_HELMET,
                  .addd = 0, .addm = 0 };
  nu.i[10][3] = helmet;
  item scarf = { .sym = symdata( ']', A_NORMAL ),
                 .name = "fluffy scarf",
                 .type = ITEM_ARMOR, .equip = EQUIP_JEWELERY_NECK,
                 .addd = 0, .addm = 0 };
  nu.i[11][3] = scarf;
  item tunic = { .sym = symdata( ']', A_NORMAL ),
                 .name = "tunic",
                 .type = ITEM_ARMOR, .equip = EQUIP_CUIRASS,
                 .addd = 0, .addm = 0 };
  nu.i[12][3] = tunic;
  item gloves = { .sym = symdata( ']', A_NORMAL ),
                  .name = "pair of leather gloves",
                  .type = ITEM_ARMOR, .equip = EQUIP_BRACERS,
                  .addd = 0, .addm = 1 };
  nu.i[13][3] = gloves;
  item pants = { .sym = symdata( ']', A_NORMAL ),
                 .name = "pair of trousers",
                 .type = ITEM_ARMOR, .equip = EQUIP_GREAVES,
                 .addd = 0, .addm = 0 };
  nu.i[14][3] = pants;
  item kilt = { .sym = symdata( ']', A_NORMAL ),
                .name = "plaid kilt",
                .type = ITEM_ARMOR, .equip = EQUIP_KILT,
                .addd = 0, .addm = 0 };
  nu.i[15][3] = kilt;
  item boots = { .sym = symdata( ']', A_NORMAL ),
                 .name = "pair of shoes",
                 .type = ITEM_ARMOR, .equip = EQUIP_FEET,
                 .addd = 0, .addm = 0 };
  nu.i[16][3] = boots;
  item tailsheath = { .sym = symdata( ']', A_NORMAL ),
                      .name = "leather tailsheath",
                      .type = ITEM_ARMOR, .equip = EQUIP_TAIL,
                      .addd = 0, .addm = 1 };
  nu.i[17][3] = tailsheath;
  
  return nu;
}

/*
################################################################################
#..............................................................................#
#..............................................................................#
#..............................................................................#
#..............................................................................#
#..............................................................................#
#..............................................................................#
#..............................................................................#
#..............................................................................#
#..............................................................................#
#...................###..................................###...................#
#...................###..................................###...................#
#...................###..................................###...................#
#..............................................................................#
#..............................................................................#
#..............................................................................#
#..............................................................................#
#..............................................................................#
#..............................................................................#
#..............................................................................#
#..............................................................................#
#..............................................................................#
#..............................................................................#
################################################################################
*/
