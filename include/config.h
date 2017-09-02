/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */

/* This is the configuration file for FORRNIF.  It defines flags which affect
 * how your copy of FORRNIF will compile. */

#ifndef CONFIG_H
# define CONFIG_H

/* SECTION 1: ****************************************************************
 * Instructions for the compiler                                             *
 *****************************************************************************/

/* Uncomment the below line if your compiler or system treats int as 16-bit.
 * This is necessary for the definition of 32-bit integers.
 * Alternatively, you can compile with the C99 standard (gcc -std=c99) and
 * util.h will specify the C99 explicit integer types for you. */
/* # define USE_LONG */

/* Uncomment the below line which indicates the version of curses you will be
 * using.  As of version 0.0.13, one of these must be used for the program to
 * compile.  pdcurses is recommended for Windows, and a version of it is
 * functional for Linux.  ncurses is recommended for Linux. */
/* defining these macros will import the following files:
 * IMPORT_NCURSES:  ncurses.h
 * IMPORT_PDCURSES: pdcurses.h
 * IMPORT_CURSES:   curses.h */
/* # define IMPORT_NCURSES */
/* # define IMPORT_PDCURSES */
# define IMPORT_CURSES

/* SECTION 2: ****************************************************************
 * Display configuration                                                     *
 *****************************************************************************/

/* What character to use for the player--set to 1 to get a smiley, and 2 to
 * get a filled smiley.  Any other values will be treated as a char.  '@' is
 * recommended. */
# define SMILEY '@'

/* Enables special effects like the highlighted player and reversed walls.
 * Only works if your curses standard uses these effects. */
# define TEXT_EFFECTS

/* Spelunk! uses blink very infrequently, normally to mark actively hostile
 * monsters.  However, it does not work on all terminals (that is, it does not
 * in fact blink but instead works as a different kind of highlight) and a lot
 * of people have strong feelings about it.  Thus, it is disabled by default.
 */
/* # define USE_BLINK */

/* Easy configuration of some text effects */

/* whether to highlight the player in the game display--if your terminal uses
 * a block-style cursor, this may be unnecessary. */
/* # define HILITE_PLAYER */

/* whether to use reversed graphics to make walls look more solid and
 * connected (this makes the game much more pleasing to the eye on a number
 * of terminals I tested with it) */
# define REVERSED_WALLS


/* Undef USE_FOV if you need to be able to see the whole map (say, for
 * debugging, testing, &c */
# define USE_FOV

/* SECTION 3: ****************************************************************
 * Spelunk! configuration                                                    *
 *****************************************************************************/

/* Alternate keys for people who are used to keeping their fingers in the
 * typing position--gives hjkluinm rather than hjklyubn */
# define ALT_HJKL

/* These lines will define the lowest and highest possible dice roll,
 * including modifiers, that is possible in-game.  If adjusted they will not
 * necessarily impact all die rolls, but will impact die rolls with a minimum
 * and maximum result.  The standard of -1000 and 1000 essentially mean no
 * limit, as it is highly improbable that you fill find a monster that hits
 * that hard. */
# define MINIMUM_DIE_ROLL -1000
# define MAXIMUM_DIE_ROLL 1000

#endif /* !def CONFIG_H */
