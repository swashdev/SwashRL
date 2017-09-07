/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */

// This file defines items and functions related to them

import global;

struct item
{
  symbol sym;
  string name;
  ushort type, equip;
  /* modifiers to the player's dice rolls */
  byte addd, addm;
}

item No_item = { sym:'\0', name:"NO ITEM", addd:0, addm:0 };
