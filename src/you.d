/*
 * Copyright (c) 2016-2018 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */

import global;

struct player
{
  symbol sym;
  ushort x, y;
  int hp;
  inven inventory;
  dicebag attack_roll;
}

player init_player( ubyte y, ubyte x )
{
  player u;
  if( x < 80 )
  { u.x = x;
  }
  else
  { u.x = 1;
  }
  if( y < 24 )
  { u.y = y;
  }
  else
  { u.y = 1;
  }
static if( HILITE_PLAYER )
{
  if( SDL_Terminal() )
  { u.sym = symdata( SMILEY, A_REVERSE );
  }
  else
  { u.sym = symdata( SMILEY, A_NORMAL );
  }
}
else
{
  u.sym = symdata( SMILEY, A_NORMAL );
}
  u.hp = roll( 3, 2 );

  foreach( count; 0 .. 40 )
  { u.inventory.items[count] = No_item;
  }
  u.inventory.quiver_count = 0;
  u.inventory.coins = 0;
  u.attack_roll = Dice( 2, 0, 0, 1000 );
  return u;
}
