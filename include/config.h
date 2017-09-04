/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */

// This is the configuration file for Spelunk!.  It defines flags which affect
// how your copy of Spelunk! will compile.

/* SECTION 1: ****************************************************************
 * Instructions for the compiler                                             *
 *****************************************************************************/

// Set one of the following values to true to import a version of curses.
enum IMPORT_NCURSES  = false; // imports ncurses.h
enum IMPORT_PDCURSES = false; // imports pdcurses.h
enum IMPORT_CURSES   = false; // imports curses.h

/* SECTION 2: ****************************************************************
 * Display configuration                                                     *
 *****************************************************************************/

// What character to use for the player.  '@' is recommended.
enum SMILEY = '@'

// Enables special effects like the highlighted player and reversed walls.
// Only works if your curses standard uses these effects (it probably does).
enum TEXT_EFFECTS = true;

// Spelunk! uses blink very infrequently, normally to mark actively hostile
// monsters.  However, it does not work on all terminals (that is, it does not
// in fact blink but instead works as a different kind of highlight) and a lot
// of people have strong feelings about it.  Thus, it is disabled by default.
enum USE_BLINK = false;

// Easy configuration of some text effects //

// Whether to highlight the player in the game display--if your terminal uses
// a block-style cursor, this may be unnecessary.
enum HILITE_PLAYER = false;

// Whether to use reversed graphics to make walls look more solid and
// connected (this makes the game much more pleasing to the eye on a number
// of terminals I tested with it)
enum REVERSED_WALLS = true;

/* SECTION 3: ****************************************************************
 * Spelunk! configuration                                                    *
 *****************************************************************************/

// Set USE_FOV to false if you need to be able to see the whole map (say, for
// debugging, testing, &c
enum USE_FOV = true;

// The number of messagse to store in the message buffer
enum MAX_MESSAGE_BUFFER = 20;

// These lines will define the lowest and highest possible dice roll,
// including modifiers, that is possible in-game.  If adjusted they will not
// necessarily impact all die rolls, but will impact die rolls with a minimum
// and maximum result.  The standard of -1000 and 1000 essentially mean no
// limit, as it is highly improbable that you fill find a monster that hits
// that hard.
// Note to self: Are these values really necessary?
enum MINIMUM_DIE_ROLL = -1000
enum MAXIMUM_DIE_ROLL = 1000
