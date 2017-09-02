/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */
#ifndef YOU_H
# define YOU_H

# include "global.h"

typedef struct
{
  symbol sym;
  uint16 x, y;
  int32 hp;
  inven inventory;
  dicebag attack_roll;
} player;

player init_player( uint8 x, uint8 y );

#endif /* !def YOU_H */
