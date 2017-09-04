/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */

// This is the global file for Spelunk!.  It will import config.h and util.h
// for you and process the data in both of these files to configure how
// Spelunk! will compile.  THIS FILE SHOULD BE INCLUDED AT THE TOP OF EVERY
// FILE.  It will include all of the other files for you. */

/* SECTION 0: ****************************************************************
 * Spelunk! version control & configuration                                  *
 *****************************************************************************/

// The version number
// In the current version numbering system, the first number is the release
// number and the second is the three-digit revision number.
enum VERSION = 0.021

// Include the config file
import config

/* SECTION 1: ****************************************************************
 * Compiler configuration                                                    *
 *****************************************************************************/

// Include the sys file to detect operating system
import sys;

/* SECTION 2: ****************************************************************
 * curses configuration                                                      *
 *****************************************************************************/

/* import the necessary version of curses */

static if( IMPORT_NCURSES )
{ import ncurses;
}
static if( IMPORT_PDCURSES )
{ import pdcurses;
}
static if( IMPORT_CURSES )
{ import curses;
}

////Autodetect version of curses (to disambiguate curses.h)
//# if defined( __NCURSES_H )
//#  define USE_NCURSES
//# elif defined( __PDCURSES__ )
//#  define USE_PDCURSES
//# else
//#  warning "Unrecognized curses--Spelunk! supports ncurses and pdcurses."
//# endif

/* SECTION 3: ****************************************************************
 * Spelunk! final setup                                                      *
 *****************************************************************************/

// The size of the map in the display
// Spelunk! will always attempt to have one line open at the top for the
// message buffer and one at the bottom for the status bar.  If MAP_Y is
// smaller than that, this variable takes effect.  MAP_X will always take
// effect.  MAP_y and MAP_x are used for zero-counted for loops.  NUMTILES is
// the number of tiles allowable on a map (1,760 by default) */
enum MAP_Y = 22;
enum MAP_X = 80;

enum MAP_y = MAP_Y - 1;
enum MAP_x = MAP_X - 1;
enum NUMTILES = MAP_Y * MAP_X;

// include the utility file
import util;

/* SECTION 4: ****************************************************************
 * Global inclusion of all header files not yet included                     *
 *****************************************************************************/

// include the rest of Spelunk!'s files in the order appointed in
// notes/include

import dice;
import random;
import sym;
import tsyms;
import tflags;
import tile;
import tiles;
import iflags;
import item;
import inven;
import monst;
import you;
import map;
import tcfov;
import fov;
import display;
import message;
import keys;
import moves;
import move;
import invent;
