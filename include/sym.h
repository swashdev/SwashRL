/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */
#ifndef SYM_H
# define SYM_H

# include "global.h"

/* the `symbol' struct, used to store information about symbols in the
 * game. */

typedef struct
{
  char ch;

# ifdef TEXT_EFFECTS
  /* attr_t from curses--note that the attribute values also store color,
   * hence the name */
  attr_t color;
# else
  /* a quick-and-dirty backup plan */
  uint16 color;
# endif /* def TEXT_EFFECTS */

  /* further members of this struct will be used when SDL is implemented for
   * images (possibly including sprites in the future */
} symbol;

# define symdata( character, effects ) ((symbol) { character, effects })
# define symdat( character ) ((symbol) { character, A_NORMAL })

#endif /* !def SYM_H */
