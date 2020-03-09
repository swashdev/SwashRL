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

// Define the standard set of colors.

enum Color CLR_DARK    = new Color( CURSES_DARK,     64,  64,  64 );
enum Color CLR_RED     = new Color( CURSES_RED,     128,   0,   0 );
enum Color CLR_GREEN   = new Color( CURSES_GREEN,     0, 128,   0 );
enum Color CLR_BLUE    = new Color( CURSES_BLUE,      0,   0, 255 );
enum Color CLR_BROWN   = new Color( CURSES_BROWN,   150,  75,   0 );
enum Color CLR_MAGENTA = new Color( CURSES_MAGENTA, 128,   0, 128 );
enum Color CLR_CYAN    = new Color( CURSES_CYAN,      0, 128, 128 );
enum Color CLR_GRAY    = new Color( CURSES_GRAY,    162, 162, 162 );

// SECTION 2: ////////////////////////////////////////////////////////////////
// Color Pairs                                                              //
//////////////////////////////////////////////////////////////////////////////

// Define the standard color pairs.

enum Color_Pair PAIR_DARK    = new Color_Pair( CLR_DARK    );
enum Color_Pair PAIR_RED     = new Color_Pair( CLR_RED     );
enum Color_Pair PAIR_GREEN   = new Color_Pair( CLR_GREEN   );
enum Color_Pair PAIR_BLUE    = new Color_Pair( CLR_BLUE    );
enum Color_Pair PAIR_BROWN   = new Color_Pair( CLR_BROWN   );
enum Color_Pair PAIR_MAGENTA = new Color_Pair( CLR_MAGENTA );
enum Color_Pair PAIR_CYAN    = new Color_Pair( CLR_CYAN    );
enum Color_Pair PAIR_GRAY    = new Color_Pair( CLR_GRAY    );

// SECTION 3: ////////////////////////////////////////////////////////////////
// The Full Color Set                                                       //
//////////////////////////////////////////////////////////////////////////////

// We're going to put all of the color pairs into an enum named `Colors` so
// we can easily access them later.

enum Colors
{
  Dark_Gray = PAIR_DARK,
  Red       = PAIR_RED,
  Green     = PAIR_GREEN,
  Blue      = PAIR_BLUE,
  Brown     = PAIR_BROWN,
  Magenta   = PAIR_MAGENTA,
  Cyan      = PAIR_CYAN,
  Gray      = PAIR_GRAY,

// Bright Colors /////////////////////////////////////////////////////////////

  // Because of the way that curses works, "bright" colors can't be defined in
  // the same way the standard colors were, because curses relies on color
  // pairs.  Instead we're going to "brighten" the existing color pairs.

  Black      = PAIR_DARK.brighten(      0,   0,   0 ),
  Lite_Red   = PAIR_RED.brighten(     255,   0,   0 ),
  Lite_Green = PAIR_GREEN.brighten(     0, 255,   0 ),
  Lite_Blue  = PAIR_BLUE.brighten(      0,   0, 255 ),
  Yellow     = PAIR_BROWN.brighten(   255, 255,   0 ),
  Pink       = PAIR_MAGENTA.brighten( 255,   0, 255 ),
  Lite_Cyan  = PAIR_CYAN.brighten(      0, 255, 255 ),
  White      = PAIR_GRAY.brighten(    255, 255, 255 )

} /* enum Colors */
