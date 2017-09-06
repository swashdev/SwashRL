/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
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

player init_player( ubyte x, ubyte y );
