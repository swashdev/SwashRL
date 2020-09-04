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

// colors.d: Defines colors and color pairs used by SwashRL.  See color.d for
// the `Color` and `Color_Pair` classes.

import global;

// SECTION 0: ////////////////////////////////////////////////////////////////
// Color Indexes                                                            //
//////////////////////////////////////////////////////////////////////////////

// Because curses defines color pairs according to index values, we must
// record them here or find useful substitutes.

///////////////////////////////
// Curses color pair indexes //
///////////////////////////////

// Indexes used to label color pairs for curses.  These enums refer directly
// to the standard curses color enums, but label them specifically as
// `CURSES_*` in order to disambiguate them from the SDL colors in the source
// code.

version( curses )
{

enum CURSES_DARK        =  COLOR_BLACK;
enum CURSES_RED         =  COLOR_RED;
enum CURSES_GREEN       =  COLOR_GREEN;
enum CURSES_BROWN       =  COLOR_YELLOW;
enum CURSES_BLUE        =  COLOR_BLUE;
enum CURSES_MAGENTA     =  COLOR_MAGENTA;
enum CURSES_CYAN        =  COLOR_CYAN;
enum CURSES_GRAY        =  COLOR_WHITE;

} // version( curses )
else
{

// NOTE: these placeholder values are taken from the pdcurses source code

enum CURSES_DARK    = 0;
enum CURSES_RED     = 1;
enum CURSES_GREEN   = 2;
enum CURSES_BLUE    = 4;
enum CURSES_BROWN   = 3;
enum CURSES_MAGENTA = 5;
enum CURSES_CYAN    = 6;
enum CURSES_GRAY    = 7;

}

// SECTION 1: ////////////////////////////////////////////////////////////////
// Colors                                                                   //
//////////////////////////////////////////////////////////////////////////////

static Color_Pair CLR_DARK_GRAY,
                  CLR_RED,
                  CLR_GREEN,
                  CLR_BLUE,
                  CLR_BROWN,
                  CLR_MAGENTA,
                  CLR_CYAN,
                  CLR_GRAY,
                  CLR_BLACK,
                  CLR_LITE_RED,
                  CLR_LITE_GREEN,
                  CLR_LITE_BLUE,
                  CLR_YELLOW,
                  CLR_PINK,
                  CLR_LITE_CYAN,
                  CLR_WHITE,
                  CLR_WALL,
                  CLR_MOLD,
                  CLR_MOLD_WALL,
                  CLR_BLOOD,
                  CLR_BLOOD_WALL;

static Color_Pair*[short] Curses_Color_Pairs;

// Initialize the global color pairs.
void init_colors()
{

  Color C_DARK_GRAY  = new Color( CURSES_DARK,     64,  64,  64 );
  Color C_RED        = new Color( CURSES_RED,     128,   0,   0 );
  Color C_GREEN      = new Color( CURSES_GREEN,     0, 128,   0 );
  Color C_BLUE       = new Color( CURSES_BLUE,      0,   0, 255 );
  Color C_BROWN      = new Color( CURSES_BROWN,   150,  75,   0 );
  Color C_MAGENTA    = new Color( CURSES_MAGENTA, 128,   0, 128 );
  Color C_CYAN       = new Color( CURSES_CYAN,      0, 128, 128 );
  Color C_GRAY       = new Color( CURSES_GRAY,    162, 162, 162 );

  Color C_BLACK      = new Color( CURSES_DARK,      0,   0,   0 );
  Color C_LITE_RED   = new Color( CURSES_RED,     255,   0,   0 );
  Color C_LITE_GREEN = new Color( CURSES_GREEN,     0, 255,   0 );
  Color C_LITE_BLUE  = new Color( CURSES_BLUE,      0,   0, 255 );
  Color C_YELLOW     = new Color( CURSES_BROWN,   255, 255,   0 );
  Color C_PINK       = new Color( CURSES_MAGENTA, 255,   0, 255 );
  Color C_LITE_CYAN  = new Color( CURSES_CYAN,      0, 255, 255 );
  Color C_WHITE      = new Color( CURSES_GRAY,    255, 255, 255 );

  CLR_DARK_GRAY = new Color_Pair( C_DARK_GRAY ); // 1
  CLR_RED       = new Color_Pair( C_RED       ); // 2
  CLR_GREEN     = new Color_Pair( C_GREEN     ); // 3
  CLR_BLUE      = new Color_Pair( C_BLUE      ); // 4
  CLR_BROWN     = new Color_Pair( C_BROWN     ); // 5
  CLR_MAGENTA   = new Color_Pair( C_MAGENTA   ); // 6
  CLR_CYAN      = new Color_Pair( C_CYAN      ); // 7
  CLR_GRAY      = new Color_Pair( C_GRAY      ); // 8

  // Special case: CLR_BLUE will always be bright, to avoid being too dark on
  // standard terminal screens
  CLR_BLUE.set_bright( true );

  // Fill in `Curses_Color_Pairs` with the color pair values of the above
  // standard color pairs.  Note that 0 is unnecessary since none of our
  // colors can override that color pair in curses anyway.
  Curses_Color_Pairs[1] = &CLR_DARK_GRAY;
  Curses_Color_Pairs[2] = &CLR_RED;
  Curses_Color_Pairs[3] = &CLR_GREEN;
  Curses_Color_Pairs[4] = &CLR_BLUE;
  Curses_Color_Pairs[5] = &CLR_BROWN;
  Curses_Color_Pairs[6] = &CLR_MAGENTA;
  Curses_Color_Pairs[7] = &CLR_CYAN;
  Curses_Color_Pairs[8] = &CLR_GRAY;

  // Bright Colors ///////////////////////////////////////////////////////////

  // Because of the way that curses works, "bright" colors can't be defined in
  // the same way the standard colors were, because curses relies on color
  // pairs.  Instead we're going to use the extended constructor to tell the
  // class to point to one of the existing color pairs above and then apply
  // the "bright" tag.

  CLR_BLACK      = new Color_Pair( C_BLACK,      1, true );
  CLR_LITE_RED   = new Color_Pair( C_LITE_RED,   2, true );
  CLR_LITE_GREEN = new Color_Pair( C_LITE_GREEN, 3, true );
  CLR_LITE_BLUE  = new Color_Pair( C_LITE_BLUE,  4, true );
  CLR_YELLOW     = new Color_Pair( C_YELLOW,     5, true );
  CLR_PINK       = new Color_Pair( C_PINK,       6, true );
  CLR_LITE_CYAN  = new Color_Pair( C_LITE_CYAN,  7, true );
  CLR_WHITE      = new Color_Pair( C_WHITE,      8, true );

  // Special Colors //////////////////////////////////////////////////////////

  // These are special colors which either build on top of the existing colors
  // above to create a special effect (such as an inverted color pair for
  // walls) or create a unique color combination (such as white-on red for the
  // festive hat)

  // `CLR_WALL` is a reversed version of `CLR_GRAY`, unless `REVERSED_WALLS`
  // is disabled
  CLR_WALL       = new Color_Pair( C_GRAY,       8, false, REVERSED_WALLS );

  // `CLR_MOLD` & `CLR_MOLD_WALL` define the colors of the mold patches which
  // generate naturally in the dungeon.  Like `CLR_WALL`, `CLR_MOLD_WALL` is
  // only inverted if `REVERSED_WALLS` is true.
  CLR_MOLD       = new Color_Pair( C_GREEN,      3, false, false );
  CLR_MOLD_WALL  = new Color_Pair( C_GREEN,      3, false, REVERSED_WALLS );

  // `CLR_BLOOD` & `CLR_BLOOD_WALL` define the color of blood smears that
  // generate during combat.
  CLR_BLOOD      = new Color_Pair( C_RED,        1, false, false );
  CLR_BLOOD_WALL = new Color_Pair( C_RED,        1, false, REVERSED_WALLS ); 
} /* void init_colors() */
