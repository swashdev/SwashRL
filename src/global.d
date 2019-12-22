/*
 * Copyright (c) 2015-2019 Philip Pavlick.  See '3rdparty.txt' for other
 * licenses.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *  * Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *  * Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *  * Neither the name of the SwashRL project nor the names of its
 *    contributors may be used to endorse or promote products derived from
 *    this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

// This is the global file for SwashRL.  It will public import config.d and
// util.d for you and process the data in both of these files to configure
// how SwashRL will compile.  THIS FILE SHOULD BE IMPORTED AT THE TOP OF
// EVERY FILE.  It will import all of the other files for you.

// SECTION 0: ////////////////////////////////////////////////////////////////
// SwashRL version control & configuration                                  //
//////////////////////////////////////////////////////////////////////////////

/++
 + The name of the compiled game
 +
 + If you're using the source code for a derivative software product, change
 + this value to the name of your game to change all references to SwashRL.
 +/
enum NAME = "SwashRL";

/++
 + The version number
 +
 + In the current version numbering system, the first number is the release
 + number and the second is the three-digit revision number.  This number
 + is stored as a floating-point number.
 +/
enum VERSION = 0.031;

/++
 + The commit ID
 +
 + This string value represents the first seven digits of the commit number
 + that the git repository was in when SwashRL was compiled.  This acts as
 + the "patch number" for that version of the program.
 +
 + This value will be declared as "HOMEMOD" if `INCLUDE_COMMIT` is `false`
 +
 + See_Also: <a href="#VERSION">VERSION</a>
 +/
static if( INCLUDE_COMMIT )
{
import std.string : split;

enum COMMIT = import( ".git/" ~ import( ".git/HEAD" ).split[1] )[0 .. 7];
}
else
{
enum COMMIT = "HOMEMOD";
}

// Include the config file
public import config;

// SECTION 1: ////////////////////////////////////////////////////////////////
// Compiler configuration                                                   //
//////////////////////////////////////////////////////////////////////////////

// Include the sys file to detect operating system
public import sys;

// SECTION 2: ////////////////////////////////////////////////////////////////
// curses configuration                                                     //
//////////////////////////////////////////////////////////////////////////////

// public import the necessary version of curses

// which version of curses we import is determined by a `version' check as
// defined in ``dub.json''.  Building with the `pdcurses' configuration will
// import pdcurses, `ncurses' will import ncurses.  The `version' given by
// those configurations has the same name as the configuration itself.
// `SPELUNK_CURSES' evaluates to `true' if either ncurses or pdcurses is being
// used and `false' otherwise.

/// This value is used by some `static if` statements to determine whether or
/// not curses is available for the program to use.
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

/// This value is used by some `static if` statements to determine whether or
/// not SDL2 is available for the program to use.
version( sdl )
{
  public import derelict.sdl2.sdl, derelict.sdl2.ttf;
  enum SDL_ENABLED = true;
}
else
{
  enum SDL_ENABLED = false;
}

// SECTION 3: ////////////////////////////////////////////////////////////////
// SwashRL final setup                                                      //
//////////////////////////////////////////////////////////////////////////////

/// Used to determine the height of the map.
/// 22 is recommended.
enum MAP_Y = 22;

/// Used to determine the width of the map.
/// 80 is recommended.
enum MAP_X = 80;

/// Used by some `for` loops as a maximum value for zero-counted arrays.
/// Always equal to `MAP_Y - 1`.
enum MAP_y = MAP_Y - 1;

/// Used by some `for` loops as a maximum value for zero-counted arrays.
/// Always equal to `MAP_X - 1`.
enum MAP_x = MAP_X - 1;

/// The number of tiles on the map.  Always equal to `MAP_Y * MAP_X`.
enum NUMTILES = MAP_Y * MAP_X;

/++
 + The number of reserved lines at the top of the display.
 +
 + The message buffer appears at the top of the display.  The number of lines
 + it takes up is listed here as `RESERVED_LINES`.  Map display functions use
 + this value to offset the y coordinate of the draw functions.
 +/
enum RESERVED_LINES = MESSAGE_BUFFER_LINES;

/// An alias for `RESERVED_LINES`
enum Y_OFFSET = RESERVED_LINES;

// include the utility file
public import util;

// SECTION 4: ////////////////////////////////////////////////////////////////
// Global inclusion of all header files not yet included                    //
//////////////////////////////////////////////////////////////////////////////

// include the rest of SwashRL's files in the order appointed in
// notes/include

public import cheats;
public import dice;
public import color;
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
public import mapgen;
public import mapalgo;
public import fov;
public import msg;
public import iomain;
public import iocurses;
public import ioterm;
public import moves;
public import keymaps;
public import mov;
public import savefile;
