/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */

import global;

dicebag Dice( ubyte d, short m, int f, int c )
{ 
  dicebag r = { dice:d, modifier:m, floor:f, ceiling:c };
  return r;
}
