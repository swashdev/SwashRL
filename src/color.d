/*
 * Copyright 2015-2019 Philip Pavlick
 *
 * This software is provided 'as-is', without any express or implied
 * warranty.  In no event will the authors be held liable for any damages
 * arising from the use of this software.
 * 
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 * 
 * 1. The origin of this software must not be misrepresented; you must not
 *    claim that you wrote the original software. If you use this software
 *    in a product, an acknowledgment in the product documentation would be
 *    appreciated but is not required.
 * 2. Altered source versions must be plainly marked as such, and must not be
 *    misrepresented as being the original software.
 * 3. This notice may not be removed or altered from any source distribution.
 */

// Defines aliases for colors that can be used by the curses or SDL interfaces

import global;

/////////////////
// Color pairs //
/////////////////

/++
 + Used to store color data
 +
 + This struct is passed into functions that display colored text to determine
 + what colors to use.
 +
 + The `fg` variable stores a flag defined in color.d which determines what
 + the foreground color is.
 +
 + The `reverse` variable determines if the foreground and background colors
 + should be swapped.
 +
 + Note that there is no variable which determines the background color; the
 + background is always black.
 +/
struct Color
{
  uint fg;
  // `reverse' determines if the foreground and background colors are
  // reversed.
  bool reverse;
}

/// A "default" color used if no color is specified during a function call.
enum CLR_DEFAULT = Color( CLR_GRAY, false );

///////////////////
// Color indexes //
///////////////////

// These enums will store indexes which will allow the `CursesIO' and
// `SDLTerminalIO' classes to determine what color to use in display
// functions.

/++
 + No color
 +
 + This is a "special case" color that will tell the terminal to adopt the
 + color of the current square or use the default color, whichever applies.
 + Deprecated: This flag is not used; instead `CLR_DEFAULT` is a default
 + parameter in functions which accept a `Color` value.
 +/
enum CLR_NONE        = 16;

/// Black
enum CLR_BLACK       =  0;
/// Red
enum CLR_RED         =  1;
/// Green
enum CLR_GREEN       =  2;
/// Brown or "dim yellow"
enum CLR_BROWN       =  3;
/// Blue
/// Deprecated:  The standard "blue" color is too dark and blends into the
/// black background of most terminals.  This flag behaves the same as
/// `CLR_LITEBLUE`
enum CLR_BLUE        =  4;
/// Magenta
enum CLR_MAGENTA     =  5;
/// Cyan
enum CLR_CYAN        =  6;
/// Gray or "dim white"
enum CLR_GRAY        =  7;

/// Dark gray or "light black"
enum CLR_DARKGRAY    =  8;
/// Light red
enum CLR_LITERED     =  9;
/// Light green
enum CLR_LITEGREEN   = 10;
/// Yellow
enum CLR_YELLOW      = 11;
/// Light blue
enum CLR_LITEBLUE    = 12;
/// Light magenta
enum CLR_LITEMAGENTA = 13;
/// Light cyan
enum CLR_LITECYAN    = 14;
/// White or "light gray"
enum CLR_WHITE       = 15;

///////////////////////////////
// Curses color pair indexes //
///////////////////////////////

// Indexes used to label color pairs for curses

version( curses )
{

/// The predefined value of "black" in curses
enum CURSES_BLACK       =  COLOR_BLACK;
/// The predefined value of "red" in curses
enum CURSES_RED         =  COLOR_RED;
/// The predefined value of "green" in curses
enum CURSES_GREEN       =  COLOR_GREEN;
/// The predefined value of "brown" or "dim yellow" in curses
enum CURSES_BROWN       =  COLOR_YELLOW;
/// The predefined value of "blue" in curses
enum CURSES_BLUE        =  COLOR_BLUE;
/// The predefined value of "magenta" in curses
enum CURSES_MAGENTA     =  COLOR_MAGENTA;
/// The predefined value of "cyan" in curses
enum CURSES_CYAN        =  COLOR_CYAN;
/// The predefined value of "gray" or "dim white" in curses
enum CURSES_GRAY        =  COLOR_WHITE;

} // version( curses )

///////////////////////
// SDL color presets //
///////////////////////

version( sdl )
{

/// An SDL definition of the `CLR_DARKGRAY` color
enum SDL_DARKGRAY = SDL_Color(  64,  64,  64, 255 );
/// An SDL definition of the `CLR_RED` color
enum SDL_RED      = SDL_Color( 128,   0,   0, 255 );
/// An SDL definition of the `CLR_GREEN` color
enum SDL_GREEN    = SDL_Color(   0, 128,   0, 255 );
/// An SDL definition of the `CLR_BROWN' color
enum SDL_BROWN    = SDL_Color( 150,  75,   0, 255 );
/// An SDL definition of the `CLR_MAGENTA` color
enum SDL_MAGENTA  = SDL_Color( 128,   0, 128, 255 );
/// An SDL definition of the `CLR_CYAN` color
enum SDL_CYAN     = SDL_Color(   0, 128, 128, 255 );
/// An SDL definition of the `CLR_GRAY` color
enum SDL_GRAY     = SDL_Color( 162, 162, 162, 255 );

/// An SDL definition of the `CLR_BLACK` color
enum SDL_BLACK       = SDL_Color(   0,   0,   0, 255 );
/// An SDL definition of the `CLR_LITERED` color
enum SDL_LITERED     = SDL_Color( 255,   0,   0, 255 );
/// An SDL definition of the `CLR_LITEGREEN` color
enum SDL_LITEGREEN   = SDL_Color(   0, 255,   0, 255 );
/// An SDL definition of the `CLR_YELLOW` color
enum SDL_YELLOW      = SDL_Color( 255, 255,   0, 255 );
/// An SDL definition of the `CLR_LITEBLUE` color
enum SDL_LITEBLUE    = SDL_Color(   0,   0, 255, 255 );
/// An SDL definition of the `CLR_LITEMAGENTA` color
enum SDL_LITEMAGENTA = SDL_Color( 255,   0, 255, 255 );
/// An SDL definition of the `CLR_LITECYAN` color
enum SDL_LITECYAN    = SDL_Color(   0, 255, 255, 255 );
/// An SDL definition of the `CLR_WHITE` color
enum SDL_WHITE       = SDL_Color( 255, 255, 255, 255 );

/// An alias which defines `SDL_BLUE` the same as `SDL_LITEBLUE` (see the
/// deprecation note in `CLR_BLUE`
enum SDL_BLUE = SDL_LITEBLUE;

} // version( sdl )
