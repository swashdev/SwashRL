/*
 * Copyright (c) 2016-2018 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */

// This is the global file for Spelunk!.  It will public import config.h and
// util.h for you and process the data in both of these files to configure how
// Spelunk! will compile.  THIS FILE SHOULD BE INCLUDED AT THE TOP OF EVERY
// FILE.  It will include all of the other files for you.

/* SECTION 0: ***************************************************************
 * Spelunk! version control & configuration                                 *
 ****************************************************************************/

// The version number
// In the current version numbering system, the first number is the release
// number and the second is the three-digit revision number.
enum VERSION = 0.023;
version( full )
{ pragma( msg, "Compiling for release number: ", VERSION );
}

// Include the config file
public import config;

/* SECTION 1: ***************************************************************
 * Compiler configuration                                                   *
 ****************************************************************************/

// Include the sys file to detect operating system
public import sys;

/* SECTION 2: ***************************************************************
 * curses configuration                                                     *
 ****************************************************************************/

/* public import the necessary version of curses */

// which version of curses we import is determined by a `version' check as
// defined in ``dub.json''.  Building with the `pdcurses' configuration will
// import pdcurses, `ncurses' will import ncurses.  The `version' given by
// those configurations has the same name as the configuration itself.
// `SPELUNK_CURSES' evaluates to `true' if either ncurses or pdcurses is being
// used and `false' otherwise.

version( ncurses )
{
  public import deimos.ncurses.curses;
  enum CURSES_ENABLED = true;
}
else version( pdcurses )
{
  public import pdcurses;
  enum CURSES_ENABLED = true;
}
else
{
  enum CURSES_ENABLED = false;
}

version( sdl )
{
  public import derelict.sdl2.sdl, derelict.sdl2.ttf;
  enum SDL_ENABLED = true;
}
else
{
  enum SDL_ENABLED = false;
}

/* SECTION 3: ***************************************************************
 * Spelunk! final setup                                                     *
 ****************************************************************************/

// The size of the map in the display
// Spelunk! will always attempt to have one line open at the top for the
// message buffer and one at the bottom for the status bar.  If MAP_Y is
// smaller than that, this variable takes effect.  MAP_X will always take
// effect.  MAP_y and MAP_x are used for zero-counted for loops.  NUMTILES is
// the number of tiles allowable on a map (1,760 by default)
enum MAP_Y = 22;
enum MAP_X = 80;

enum MAP_y = MAP_Y - 1;
enum MAP_x = MAP_X - 1;
enum NUMTILES = MAP_Y * MAP_X;

enum RESERVED_LINES = MESSAGE_BUFFER_LINES;
enum Y_OFFSET = RESERVED_LINES;

// include the utility file
public import util;

/* SECTION 4: ***************************************************************
 * Global inclusion of all header files not yet included                    *
 ****************************************************************************/

// include the rest of Spelunk!'s files in the order appointed in
// notes/include

public import dice;
public import sym;
public import tsyms;
public import tflags;
public import tile;
public import iflags;
public import item;
public import inven;
public import monst;
public import you;
public import map;
public import fov;
public import msg;
public import iomain;
public import iocurses;
public import ioterm;
public import moves;
public import controls;
public import keymaps;
public import mov;
public import invent;
