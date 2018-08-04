/*
 * Copyright (c) 2016-2018 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */

import global;

// declare symbols for dungeon tiles--see ``sym.d'' for declaration of the
// `symbol' struct and `symdata' function.

// XXX: Find an elegant way to handle the loss of `A_NORMAL' and `A_REVERSE'
// when curses is gone (maybe define these ourselves for the SDL interface)
static if( !CURSES_ENABLED )
{
  enum A_NORMAL = 0x00, A_REVERSE = 0x01, A_DIM = 0x02;
}

static const symbol SYM_FLOOR  = symdata( '.', A_NORMAL  );
static if( REVERSED_WALLS )
{
static const symbol SYM_WALL   = symdata( '#', A_REVERSE );
static const symbol SYM_STALA  = symdata( 'V', A_REVERSE );
static const symbol SYM_DOOR   = symdata( '+', A_REVERSE );
}
else
{
static const symbol SYM_WALL   = symdata( '#', A_NORMAL  );
static const symbol SYM_STALA  = symdata( 'V', A_NORMAL  );
static const symbol SYM_DOOR   = symdata( '+', A_NORMAL  );
}
static const symbol SYM_WATER  = symdata( '}', A_NORMAL  );
static const symbol SYM_SHADOW = symdata( ' ', A_NORMAL  );
