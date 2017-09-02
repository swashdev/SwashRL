/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */
/* This is the global file for FORRNIF.  It will import config.h and util.h
 * for you and process the data in both of these files to configure how
 * FORRNIF will compile.  THIS FILE SHOULD BE INCLUDED AT THE TOP OF EVERY
 * FILE.  It will include all of the other files for you. */

#ifndef GLOBAL_H
# define GLOBAL_H

/* SECTION 0: ****************************************************************
 * Spelunk! version control & configuration                                  *
 *****************************************************************************/

/* These flags determine the version number and name given when the version
 * data is being displayed. */
/* In the current version numbering system, the first number is the release
 * number and the second is the three-digit revision number. */
# define VERSION 0.021
# define FORRNIF "Spelunk!"

/* This flag defines whether or not this version of Spelunk! is still under
 * development */
# define DEV_RELEASE 1

/* This flag will activate a message in main which informs the player that the
 * license agreement has changed.  Only activate this if the license agreement
 * has, in fact, changed with THIS PARTICULAR VERSION NUMBER. */
# define NEW_LICENSE 1

/* Include the config file */
# include "config.h"

/* SECTION 1: ****************************************************************
 * Compiler configuration                                                    *
 *****************************************************************************/

/* Include the sys file to detect operating system */
# include "sys.h"

/* use these macros to determine (within a reasonable degree of uncertainty
 * given that standards appear to be optional in C) what standard of C we are
 * using.  Spelunk! is written with the desire to be compliant with ANSI C
 * specification X3.159-1989, also known as C89, for maximum portability.
 */
# if defined( __ANSI__ ) || defined( __STDC__ )
#  define C89
# endif /* def __ANSI__ or def __STDC__ */

# if defined( __STDC_VERSION__ )
/* C95 support, ISO/IEC 9899/AMD1:1995, an amendment for ANSI C */
#  if __STDC_VERSION__ >= 199409L
#   define C95
/* ISO/IEC 9899:1999 */
#   if __STDC_VERSION__ >= 199901L
#    define C99
/* ISO/IEC 9899:2011 */
#    if __STDC_VERSION__ >= 201112L
#     define C11
#    endif /* __STDC_VERSION__ >= 201112L */
#   endif /* __STDC_VERSION__ >= 19901L */
#  endif /* __STDC_VERSION__ >= 199409L */
# endif /* def __STDC_VERSION__ */

/* SECTION 2: ****************************************************************
 * curses configuration                                                      *
 *****************************************************************************/

/* import the necessary version of curses */

# if defined( IMPORT_NCURSES )
#  include "ncurses.h"
# elif defined( IMPORT_PDCURSES )
#  include "pdcurses.h"
# elif defined( IMPORT_CURSES )
#  include "curses.h"
# else
/* crash in the user's face */
#  error "No curses!  Please edit config.h."
# endif

/* Autodetect version of curses (to disambiguate curses.h) */
# if defined( __NCURSES_H )
#  define USE_NCURSES
# elif defined( __PDCURSES__ )
#  define USE_PDCURSES
# else
#  warning "Unrecognized curses--Spelunk! supports ncurses and pdcurses."
# endif

/* SECTION 3: ****************************************************************
 * Spelunk! final setup                                                      *
 *****************************************************************************/

/* Reserved spaces on the screen */
# define MESSAGE_BUFFER_LINES 1
# define STATUS_BAR_LINES 1
# define RESERVED_LINES MESSAGE_BUFFER_LINES

/* The size of the map in the display */
/* FORRNIF will always attempt to have one line open at the top for the
 * message buffer and one at the bottom for the status bar.  If MAP_Y is
 * smaller than that, this variable takes effect.  MAP_X will always take
 * effect.  MAP_y and MAP_x are used for zero-counted for loops.  NUMTILES is
 * the number of tiles allowable on a map (1,760 by default) */
# define MAP_Y 22
# define MAP_X 80

/* Automatically resize the map screen if necessary */
# if MAP_Y + MESSAGE_BUFFER_LINES + STATUS_BAR_LINES > 24
#  undef MAP_Y
#  define MAP_Y (24 - (MESSAGE_BUFFER_LINES + STATUS_BAR_LINES))
# endif

# define MAP_y (MAP_Y - 1)
# define MAP_x (MAP_X - 1)
# define NUMTILES (MAP_Y * MAP_X)

/* include the utility file */
# include "util.h"

/* SECTION 4: ****************************************************************
 * Global inclusion of all header files not yet included                     *
 *****************************************************************************/

/* include the rest of FORRNIF's files in the order appointed in
 * notes/include */

# include "erpanic.h"
/* # include "options.h" */
# include "dice.h"
# include "random.h"
# include "sym.h"
# include "tsyms.h"
# include "tflags.h"
# include "tile.h"
# include "tiles.h"
# include "iflags.h"
# include "item.h"
# include "inven.h"
# include "monst.h"
# include "you.h"
# include "map.h"
# include "tcfov.h"
# include "fov.h"
# include "display.h"
# include "message.h"
# include "keys.h"
# include "moves.h"
# include "move.h"
# include "invent.h"

#endif /* !def GLOBAL_H */
