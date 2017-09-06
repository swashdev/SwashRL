/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */

import global;

tile tiledata( symbol sym, bool block_c, bool block_d, bool block_v,
               bool light, short special )
{
  tile t = { sym:sym,
             block_cardinal_movement:block_c, block_diagonal_movement:block_d,
             block_vision:block_v,
             seen:false, lit:light,
             hazard:special
           };
  return t;
}

tile Floor()
{ return tiledata( SYM_FLOOR, FALSE, FALSE, FALSE, TRUE, 0 );
}

tile Wall()
{ return tiledata( SYM_WALL, TRUE, TRUE, TRUE, TRUE, 0 );
}

tile Water()
{ return tiledata( SYM_WATER, FALSE, FALSE, FALSE, TRUE, HAZARD_WATER );
}
