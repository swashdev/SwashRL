/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */
#include "global.h"

player init_player( uint8 x, uint8 y )
{
  player u;
  if( x < 80 )
    u.x = x;
  else
    u.x = 1;
  if( y < 24 )
    u.y = y;
  else
    u.y = 1;
  u.sym = symdata( SMILEY, A_NORMAL );
  u.hp = roll( 3, 2 );
  uint8 count;
  for( count = 0; count < 40; count++ )
  { u.inventory.items[count] = No_item;
  }
  u.inventory.quiver_count = 0;
  u.inventory.coins = 0;
  u.attack_roll = Dice( 2, 0, 0, 1000 );
  return u;
}
