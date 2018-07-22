/*
 * Copyright (c) 2016-2018 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */

import global;

// declare symbols for dungeon tiles--see ``sym.h'' for declaration of the
// `symbol' struct

// XXX: Find an elegant way to handle the loss of `A_NORMAL' and `A_REVERSE'
// when curses is gone (maybe define these ourselves for the SDL interface)
static if( !CURSES_ENABLED )
{
  enum A_NORMAL = 1, A_REVERSE = 2, A_DIM = 3;
}

static const symbol SYM_FLOOR  = symdata( '.', A_NORMAL  );
static const symbol SYM_WALL   = symdata( '#', A_REVERSE );
static const symbol SYM_STALA  = symdata( 'V', A_REVERSE );
static const symbol SYM_WATER  = symdata( '}', A_NORMAL  );
static const symbol SYM_DOOR   = symdata( '+', A_REVERSE );
static const symbol SYM_SHADOW = symdata( ' ', A_NORMAL );
