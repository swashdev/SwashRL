/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */
#include "global.h"

tile Floor()
{ return (tile) { SYM_FLOOR, FALSE, FALSE, FALSE, FALSE, TRUE, 0 };
}

tile Wall()
{ return (tile) { SYM_WALL, TRUE, TRUE, TRUE, FALSE, TRUE, 0 };
}

tile Water()
{ return (tile) { SYM_WATER, FALSE, FALSE, FALSE, FALSE, TRUE, HAZARD_WATER };
}
