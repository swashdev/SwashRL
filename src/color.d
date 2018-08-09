/*
 * Copyright 2016-2018 Philip Pavlick
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License, excepting that
 * Derivative Works are not required to carry prominent notices in changed
 * files.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// Defines aliases for colors that can be used by the curses or SDL interfaces

import global;

///////////////////
// Color indexes //
///////////////////

// These enums will store indexes which will allow the `CursesIO' and
// `SDLTerminalIO' classes to determine what color to use in display
// functions.

// This is a "special case" color that will tell the terminal to adopt the
// color of the current square or use the default color, whichever applies.
enum CLR_NONE        = 16;

// These colors are defined in the same order as in the generic curses
// definitions, but the actual numeric values are different, so be careful.
enum CLR_BLACK       =  0;
enum CLR_RED         =  1;
enum CLR_GREEN       =  2;
enum CLR_BROWN       =  3;
enum CLR_BLUE        =  4;
enum CLR_MAGENTA     =  5;
enum CLR_CYAN        =  6;
enum CLR_GRAY        =  7;

enum CLR_DARKGRAY    =  8;
enum CLR_LITERED     =  9;
enum CLR_LITEGREEN   = 10;
enum CLR_YELLOW      = 11;
enum CLR_LITEBLUE    = 12;
enum CLR_LITEMAGENTA = 13;
enum CLR_LITECYAN    = 14;
enum CLR_WHITE       = 15;

/////////////////
// Color pairs //
/////////////////

// This struct is used to store color data
struct Color
{
  ubyte fg;
  // `reverse' determines if the foreground and background colors are
  // reversed.
  bool reverse;
}

enum CLR_DEFAULT = Color( CLR_GRAY, false );

///////////////////////////////
// Curses color pair indexes //
///////////////////////////////

// Indexes used to label color pairs for curses

version( curses )
{

enum CURSES_BLACK       =  0;
enum CURSES_RED         =  1;
enum CURSES_GREEN       =  2;
enum CURSES_BROWN       =  3;

enum CURSES_MAGENTA     =  4;
enum CURSES_CYAN        =  5;
enum CURSES_GRAY        =  6;
enum CURSES_DARKGRAY    =  7;
enum CURSES_LITERED     =  8;
enum CURSES_LITEGREEN   =  9;
enum CURSES_YELLOW      = 10;
enum CURSES_LITEBLUE    = 11;
enum CURSES_LITEMAGENTA = 12;
enum CURSES_LITECYAN    = 13;
enum CURSES_WHITE       = 14;

enum CURSES_BLUE = CURSES_LITEBLUE;

} // version( curses )

///////////////////////
// SDL color presets //
///////////////////////

version( sdl )
{

// RGB colors for SDL:
enum SDL_DARKGRAY = SDL_Color(  64,  64,  64, 255 );
enum SDL_RED      = SDL_Color( 128,   0,   0, 255 );
enum SDL_GREEN    = SDL_Color(   0, 128,   0, 255 );
enum SDL_BROWN    = SDL_Color( 150,  75,   0, 255 );
enum SDL_MAGENTA  = SDL_Color( 128,   0, 128, 255 );
enum SDL_CYAN     = SDL_Color(   0, 128, 128, 255 );
enum SDL_GRAY     = SDL_Color( 162, 162, 162, 255 );

// Lite (bold) colors:
enum SDL_BLACK       = SDL_Color(   0,   0,   0, 255 );
enum SDL_LITERED     = SDL_Color( 255,   0,   0, 255 );
enum SDL_LITEGREEN   = SDL_Color(   0, 255,   0, 255 );
enum SDL_YELLOW      = SDL_Color( 255, 255,   0, 255 );
enum SDL_LITEBLUE    = SDL_Color(   0,   0, 255, 255 );
enum SDL_LITEMAGENTA = SDL_Color( 255,   0, 255, 255 );
enum SDL_LITECYAN    = SDL_Color(   0, 255, 255, 255 );
enum SDL_WHITE       = SDL_Color( 255, 255, 255, 255 );

enum SDL_BLUE = SDL_LITEBLUE;

} // version( sdl )
