/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */
/* This file defines items and functions related to them */

#ifndef ITEM_H
# define ITEM_H

# include "global.h"

typedef struct
{
  symbol sym;
  str name;
  uint16 type, equip;
  /* modifiers to the player's dice rolls */
  int8 addd, addm;
} item;

static item No_item =
{
  .sym = '\0', .name = "NO ITEM", .addd = 0, .addm = 0
};

#endif /* !def ITEM_H */
