/*
 * Copyright (c) 2015-2020 Philip Pavlick.  See '3rdparty.txt' for other
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

// color.d: Defines aliases for colors that can be used by the curses or SDL
// interfaces

import global;

/////////////////
// Color pairs //
/////////////////

/*
 * Used to store color data
 *
 * This struct is passed into functions that display colored text to determine
 * what colors to use.
 *
 * The `fg` variable stores a flag defined in color.d which determines what
 * the foreground color is.
 *
 * The `reverse` variable determines if the foreground and background colors
 * should be swapped.
 *
 * Note that there is no variable which determines the background color; the
 * background is always black.
 */
struct Color
{
  uint fg;
  // `reverse' determines if the foreground and background colors are
  // reversed.
  bool reverse;
}

// A "default" color used if no color is specified during a function call.
enum CLR_DEFAULT = Color( CLR_GRAY, false );

///////////////////
// Color indexes //
///////////////////

// These enums will store indexes which will allow the `CursesIO' and
// `SDLTerminalIO' classes to determine what color to use in display
// functions.

/* This is a "special case" color that will tell the terminal to adopt the
 * color of the current square or use the default color, whichever applies.
 * Deprecated: This flag is not used; instead `CLR_DEFAULT` is a default
 * parameter in functions which accept a `Color` value.
 */
enum CLR_NONE        = 16;

enum CLR_BLACK       =  0;
enum CLR_RED         =  1;
enum CLR_GREEN       =  2;
enum CLR_BROWN       =  3;
enum CLR_MAGENTA     =  5;
enum CLR_CYAN        =  6;
enum CLR_GRAY        =  7;

// Note that CLR_BLUE has a different index from CLR_LITEBLUE, but it behaves
// exactly the same; both the curses and SDL terminal interfaces will treat it
// like they are the same color.  This is because dark blue is too dark to be
// used to any significant degree on a dark background.
enum CLR_BLUE        =  4;

enum CLR_DARKGRAY    =  8;
enum CLR_LITERED     =  9;
enum CLR_LITEGREEN   = 10;
enum CLR_YELLOW      = 11;
enum CLR_LITEBLUE    = 12;
enum CLR_LITEMAGENTA = 13;
enum CLR_LITECYAN    = 14;
enum CLR_WHITE       = 15;

///////////////////////////////
// Curses color pair indexes //
///////////////////////////////

// Indexes used to label color pairs for curses.  These enums refer directly
// to the standard curses color enums, but label them specifically as
// `CURSES_*` in order to disambiguate them from the SDL colors in the source
// code.

version( curses )
{

enum CURSES_BLACK       =  COLOR_BLACK;
enum CURSES_RED         =  COLOR_RED;
enum CURSES_GREEN       =  COLOR_GREEN;
enum CURSES_BROWN       =  COLOR_YELLOW;
enum CURSES_BLUE        =  COLOR_BLUE;
enum CURSES_MAGENTA     =  COLOR_MAGENTA;
enum CURSES_CYAN        =  COLOR_CYAN;
enum CURSES_GRAY        =  COLOR_WHITE;

} // version( curses )

///////////////////////
// SDL color presets //
///////////////////////

// Structs used to define standard colors used by the SDL terminal interface.
// Note the parallel naming scheme with the `CLR_*` indexes above.

version( sdl )
{

enum SDL_DARKGRAY = SDL_Color(  64,  64,  64, 255 );
enum SDL_RED      = SDL_Color( 128,   0,   0, 255 );
enum SDL_GREEN    = SDL_Color(   0, 128,   0, 255 );
enum SDL_BROWN    = SDL_Color( 150,  75,   0, 255 );
enum SDL_MAGENTA  = SDL_Color( 128,   0, 128, 255 );
enum SDL_CYAN     = SDL_Color(   0, 128, 128, 255 );
enum SDL_GRAY     = SDL_Color( 162, 162, 162, 255 );

enum SDL_BLACK       = SDL_Color(   0,   0,   0, 255 );
enum SDL_LITERED     = SDL_Color( 255,   0,   0, 255 );
enum SDL_LITEGREEN   = SDL_Color(   0, 255,   0, 255 );
enum SDL_YELLOW      = SDL_Color( 255, 255,   0, 255 );
enum SDL_LITEBLUE    = SDL_Color(   0,   0, 255, 255 );
enum SDL_LITEMAGENTA = SDL_Color( 255,   0, 255, 255 );
enum SDL_LITECYAN    = SDL_Color(   0, 255, 255, 255 );
enum SDL_WHITE       = SDL_Color( 255, 255, 255, 255 );

// An alias which defines `SDL_BLUE` the same as `SDL_LITEBLUE` (see the
// deprecation note in `CLR_BLUE`
enum SDL_BLUE = SDL_LITEBLUE;

} // version( sdl )
