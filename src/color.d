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
// Curses colors //
///////////////////

version( curses )
{

// If curses is enabled, perfect.  We simply use the predefined colors that
// come with curses.
// Note the mysterious absence of blue; we only use light blue to make it more
// visible against the black background.
enum CLR_DARKGRAY = COLOR_BLACK;
enum CLR_RED      = COLOR_RED;
enum CLR_GREEN    = COLOR_GREEN;
enum CLR_BROWN    = COLOR_YELLOW;

enum CLR_MAGENTA  = COLOR_MAGENTA;
enum CLR_CYAN     = COLOR_CYAN;
enum CLR_GRAY     = COLOR_WHITE;

// Lite (bold) colors:
enum CLR_BLACK       = COLOR_BLACK   | A_BOLD;
enum CLR_LITERED     = COLOR_RED     | A_BOLD;
enum CLR_LITEGREEN   = COLOR_GREEN   | A_BOLD;
enum CLR_YELLOW      = COLOR_YELLOW  | A_BOLD;
enum CLR_BLUE        = COLOR_BLUE    | A_BOLD;
enum CLR_LITEMAGENTA = COLOR_MAGENTA | A_BOLD;
enum CLR_LITECYAN    = COLOR_CYAN    | A_BOLD;
enum CLR_WHITE       = COLOR_WHITE   | A_BOLD;

} // version( curses )
else
{

// If curses is NOT enabled, we'll alias all of the colors that would have
// been defined by curses, so SDL can still refer to them
enum CLR_DARKGRAY = 0x000000;
enum CLR_RED      = 0x000001;
enum CLR_GREEN    = 0x000002;
enum CLR_BROWN    = 0x000004;

enum CLR_MAGENTA  = 0x000010;
enum CLR_CYAN     = 0x000020;
enum CLR_GRAY     = 0x000040;

// Lite (bold) colors:
enum CLR_BLACK       = 0x000080;
enum CLR_LITERED     = 0x000100;
enum CLR_LITEGREEN   = 0x000200;
enum CLR_YELLOW      = 0x000400;
enum CLR_BLUE        = 0x000800;
enum CLR_LITEMAGENTA = 0x001000;
enum CLR_LITECYAN    = 0x002000;
enum CLR_WHITE       = 0x004000;

// "Text effects" that we're using:
enum A_NORMAL  = 0x000000;
enum A_REVERSE = 0x010000;

} // else from version( curses )



////////////////
// SDL colors //
////////////////

version( sdl )
{

// RGB colors for SDL:
static SDL_Color SDL_DARKGRAY = SDL_Color(  64,  64,  64, 255 );
static SDL_Color SDL_RED      = SDL_Color( 128,   0,   0, 255 );
static SDL_Color SDL_GREEN    = SDL_Color(   0, 128,   0, 255 );
static SDL_Color SDL_BROWN    = SDL_Color( 150,  75,   0, 255 );
static SDL_Color SDL_MAGENTA  = SDL_Color( 128,   0, 128, 255 );
static SDL_Color SDL_CYAN     = SDL_Color(   0, 128, 128, 255 );
static SDL_Color SDL_GRAY     = SDL_Color( 162, 162, 162, 255 );

// Lite (bold) colors:
static SDL_Color SDL_BLACK       = SDL_Color(   0,   0,   0, 255 );
static SDL_Color SDL_LITERED     = SDL_Color( 255,   0,   0, 255 );
static SDL_Color SDL_LITEGREEN   = SDL_Color(   0, 255,   0, 255 );
static SDL_Color SDL_YELLOW      = SDL_Color( 255, 255,   0, 255 );
static SDL_Color SDL_BLUE        = SDL_Color(   0,   0, 255, 255 );
static SDL_Color SDL_LITEMAGENTA = SDL_Color( 255,   0, 255, 255 );
static SDL_Color SDL_LITECYAN    = SDL_Color(   0, 255, 255, 255 );
static SDL_Color SDL_WHITE       = SDL_Color( 255, 255, 255, 255 );

} // version( sdl )



/////////////////
// Color pairs //
/////////////////

// This struct is used to store color pairs
struct Color_pair
{
version( curses )
{
  attr_t fg, bg;
}
else
{
  ulong fg, bg;
}
  bool reverse;
}

version( curses )
{
Color_pair color_pair( attr_t foreground, attr_t background,
                       bool reversed = false )
{
  return Color_pair( foreground, background, reversed );
}
}
else
{
Color_pair color_pair( ulong foreground, ulong background,
                       bool reversed = false )
{
  return Color_pair( foreground, background, reversed );
}
}

// This "no color" is a special case used for when we want no color.
// Generally used for cases where we don't want a special background color for
// a particular glyph, so use the default or inherit the color that's already
// there.
enum CLR_NONE = 255;
