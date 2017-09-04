/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */

include global;

/* the `symbol' struct, used to store information about symbols in the
 * game. */

struct symbol
{
  char ch;

  static if( TEXT_EFFECTS )
  {
    /* attr_t from curses--note that the attribute values also store color,
     * hence the name */
    attr_t color;
  }
  else
  {
    ushort color;
  }

  /* further members of this struct will be used when SDL is implemented for
   * images (possibly including sprites in the future */
}

symbol symdata( char character
static if( TEXT_EFFECTS )
{
                , attr_t effects
}
              )
{
  symbol ret = { ch:character, color:effects };
  return ret;
}
# define symdata( character, effects ) ((symbol) { character, effects })
# define symdat( character ) ((symbol) { character, A_NORMAL })
