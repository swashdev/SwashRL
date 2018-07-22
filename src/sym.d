/*
 * Copyright (c) 2016-2018 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */

import global;

// the `symbol' struct, used to store information about symbols in the
// game.

struct symbol
{
  char ch;

static if( SPELUNK_CURSES )
{
  // attr_t from curses--note that the attribute values also store color,
  // hence the name
  attr_t color;
}

  // further members of this struct will be used when SDL is implemented for
  // images (possibly including sprites in the future)
}

symbol symdata( char character, ulong effects )
{

  symbol ret;
  ret.ch = character;

static if( SPELUNK_CURSES )
{
  ret.color = cast(attr_t)effects;
}

  return ret;
}
