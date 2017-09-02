/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */
#include "global.h"

dicebag Dice( uint8 d, int16 m, int32 f, int32 c )
{ 
  dicebag r = { d, m, f, c };
  return r;
}
