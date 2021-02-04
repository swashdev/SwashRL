/*
 * Copyright (c) 2020-2021 Philip Pavlick.  See '3rdparty.txt' for other
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

// Indexes used to label color pairs for curses.  These enums refer directly
// to the standard curses color enums, but label them specifically as
// `CURSES_*` in order to disambiguate them from the SDL colors in the source
// code.

version( curses )
{
    enum CURSES_BLACK   =  COLOR_BLACK;
    enum CURSES_RED     =  COLOR_RED;
    enum CURSES_GREEN   =  COLOR_GREEN;
    enum CURSES_BROWN   =  COLOR_YELLOW;
    enum CURSES_BLUE    =  COLOR_BLUE;
    enum CURSES_MAGENTA =  COLOR_MAGENTA;
    enum CURSES_CYAN    =  COLOR_CYAN;
    enum CURSES_GRAY    =  COLOR_WHITE;
}
else
{
    // NOTE: these placeholder values are taken from the pdcurses source code
    enum CURSES_BLACK   = 0;
    enum CURSES_RED     = 1;
    enum CURSES_GREEN   = 2;
    enum CURSES_BLUE    = 4;
    enum CURSES_BROWN   = 3;
    enum CURSES_MAGENTA = 5;
    enum CURSES_CYAN    = 6;
    enum CURSES_GRAY    = 7;
}

// SECTION 1: ////////////////////////////////////////////////////////////////
// Color Pairs                                                              //
//////////////////////////////////////////////////////////////////////////////

// The colors enum stores the names of the color pairs that SwashRL is able to
// use for the curses and SDL terminal interfaces.

enum Colors
{
    Default,
    Black,
    Red,
    Green,
    Dark_Blue,
    Brown,
    Magenta,
    Cyan,
    Gray,
    Dark_Gray,
    Lite_Red,
    Lite_Green,
    Blue,
    Yellow,
    Pink,
    Lite_Cyan,
    White,
    Inverted_Black,
    Inverted_Red,
    Inverted_Green,
    Inverted_Dark_Blue,
    Inverted_Brown,
    Inverted_Magenta,
    Inverted_Cyan,
    Inverted_Gray,
    Inverted_Dark_Gray,
    Inverted_Lite_Red,
    Inverted_Lite_Green,
    Inverted_Blue,
    Inverted_Yellow,
    Inverted_Pink,
    Inverted_Lite_Cyan,
    Inverted_White,
    Error,
    Player,
    Festive_Player,
    Water,
    Lava,
    Acid,
    Snow,
    Snow_Tree,
    Copper,
    Silver,
    Gold,
    Roentgenium,
    Money,
    Royal,
    Holy
} // enum Colors

// The Clr array stores the `Color_Pair` objects used to define the color
// arrays for the curses and SDL terminal interfaces.

static Color_Pair[Colors.max + 1] Clr;

// Defining Color Pairs //////////////////////////////////////////////////////

// Initialize the global color pairs.
void init_colors()
{
    Color C_BLACK      = new Color( CURSES_BLACK,     0,   0,   0 );
    Color C_RED        = new Color( CURSES_RED,     204,   0,   0 );
    Color C_GREEN      = new Color( CURSES_GREEN,    78, 154,   6 );
    Color C_BLUE       = new Color( CURSES_BLUE,     52, 101, 164 );
    Color C_BROWN      = new Color( CURSES_BROWN,   193, 125,  17 );
    Color C_MAGENTA    = new Color( CURSES_MAGENTA, 117,  80, 123 );
    Color C_CYAN       = new Color( CURSES_CYAN,      6, 152, 154 );
    Color C_GRAY       = new Color( CURSES_GRAY,    186, 189, 182 );

    Color C_DARK_GRAY  = new Color( CURSES_BLACK,    85,  87,  83 );
    Color C_LITE_RED   = new Color( CURSES_RED,     239,  41,  41 );
    Color C_LITE_GREEN = new Color( CURSES_GREEN,   138, 226,  52 );
    Color C_LITE_BLUE  = new Color( CURSES_BLUE,    115, 159, 207 );
    Color C_YELLOW     = new Color( CURSES_BROWN,   252, 233,  79 );
    Color C_PINK       = new Color( CURSES_MAGENTA, 173, 127, 168 );
    Color C_LITE_CYAN  = new Color( CURSES_CYAN,     52, 226, 226 );
    Color C_WHITE      = new Color( CURSES_GRAY,    255, 255, 255 );

    // The player's color, orange for SDL terminal interface but white for
    // curses (because the light red color in curses doesn't look right)
    Color C_PLAYER     = new Color( CURSES_GRAY,    255, 128,   0 );

    // "Royal" purple, aka Tyrian purple
    Color C_ROYAL      = new Color( CURSES_MAGENTA, 102,   2,  60 );

    // Ultramarine, a reference to lapis lazuli, often used in important
    // religious artwork
    Color C_HOLY       = new Color( CURSES_BLUE,     18,  10, 143 );

    // Copper, Silver, Gold, and Roentgennium: The "coinage metals"
    Color C_COPPER     = new Color( CURSES_BROWN,   184, 115,  51 );
    Color C_SILVER     = new Color( CURSES_GRAY,    192, 192, 192 );
    Color C_GOLD       = new Color( CURSES_BROWN,   255, 215,   0 );
    Color C_ROENTGENIUM = new Color( CURSES_BLACK,   132, 132, 130 );
    Color C_MONEY      = new Color( CURSES_GREEN,     0, 128,   0 );

    Clr[Colors.Default]   = new Color_Pair( C_GRAY, 0 ); // 0
    Clr[Colors.Black]     = new Color_Pair( C_BLACK   ); // 1
    Clr[Colors.Red]       = new Color_Pair( C_RED     ); // 2
    Clr[Colors.Green]     = new Color_Pair( C_GREEN   ); // 3
    Clr[Colors.Dark_Blue] = new Color_Pair( C_BLUE    ); // 4
    Clr[Colors.Brown]     = new Color_Pair( C_BROWN   ); // 5
    Clr[Colors.Magenta]   = new Color_Pair( C_MAGENTA ); // 6
    Clr[Colors.Cyan]      = new Color_Pair( C_CYAN    ); // 7
    Clr[Colors.Gray]      = new Color_Pair( C_GRAY    ); // 8

    // Bright Colors /////////////////////////////////////////////////////////

    // Because of the way that curses works, "bright" colors can't be defined
    // in the same way the standard colors were, because curses relies on
    // applying modifiers to color pairs.  Instead we're going to use the
    // extended constructor to tell the class to point to one of the existing
    // color pairs above and then apply the "bright" tag.

    Clr[Colors.Dark_Gray]  = new Color_Pair( C_DARK_GRAY,  1, true ); //  9
    Clr[Colors.Lite_Red]   = new Color_Pair( C_LITE_RED,   2, true ); // 10
    Clr[Colors.Lite_Green] = new Color_Pair( C_LITE_GREEN, 3, true ); // 11
    Clr[Colors.Blue]       = new Color_Pair( C_LITE_BLUE,  4, true ); // 12
    Clr[Colors.Yellow]     = new Color_Pair( C_YELLOW,     5, true ); // 13
    Clr[Colors.Pink]       = new Color_Pair( C_PINK,       6, true ); // 14
    Clr[Colors.Lite_Cyan]  = new Color_Pair( C_LITE_CYAN,  7, true ); // 15
    Clr[Colors.White]      = new Color_Pair( C_WHITE,      8, true ); // 16

    // Inverted Colors ///////////////////////////////////////////////////////

    // Versions of the standard & bright colors defined above which have been
    // "flipped" with the standard black background.
    Clr[Colors.Inverted_Black] 
        = new Color_Pair( C_BLACK,      1, false, true );
    Clr[Colors.Inverted_Red] 
        = new Color_Pair( C_RED,        2, false, true );
    Clr[Colors.Inverted_Green] 
        = new Color_Pair( C_GREEN,      3, false, true );
    Clr[Colors.Inverted_Dark_Blue] 
        = new Color_Pair( C_BLUE,       4, false, true );
    Clr[Colors.Inverted_Brown] 
        = new Color_Pair( C_BROWN,      5, false, true );
    Clr[Colors.Inverted_Magenta] 
        = new Color_Pair( C_MAGENTA,    6, false, true );
    Clr[Colors.Inverted_Cyan] 
        = new Color_Pair( C_CYAN,       7, false, true );
    Clr[Colors.Inverted_Gray] 
        = new Color_Pair( C_GRAY,       8, false, true );

    Clr[Colors.Inverted_Dark_Gray] 
        = new Color_Pair( C_DARK_GRAY,  1, true,  true );
    Clr[Colors.Inverted_Lite_Red] 
        = new Color_Pair( C_LITE_RED,   2, true,  true );
    Clr[Colors.Inverted_Lite_Green] 
        = new Color_Pair( C_LITE_GREEN, 3, true,  true );
    Clr[Colors.Inverted_Blue] 
        = new Color_Pair( C_LITE_BLUE,  4, true,  true );
    Clr[Colors.Inverted_Yellow] 
        = new Color_Pair( C_YELLOW,     5, true,  true );
    Clr[Colors.Inverted_Pink] 
        = new Color_Pair( C_PINK,       6, true,  true );
    Clr[Colors.Inverted_Lite_Cyan] 
        = new Color_Pair( C_LITE_CYAN,  7, true,  true );
    Clr[Colors.Inverted_White] 
        = new Color_Pair( C_WHITE,      8, true,  true );

    // Special Colors ////////////////////////////////////////////////////////

    // These are special colors which either build on top of the existing
    // colors above to create a special effect (such as an inverted color pair
    // for walls) or create a unique color combination (such as white-on red
    // for the festive hat)

    // CLR_ERROR is a special color pair used by the SDL terminal interface to
    // indicate that a character has been defined improperly.
    Clr[Colors.Error] = new Color_Pair( C_GRAY, C_RED, -1, false, false );

    // The player is displayed in a unique orange color to make them stand
    // out.  On the curses interface, they are instead displayed in white.
    Clr[Colors.Player] = new Color_Pair( C_PLAYER, 8, true,  false );

    // The "festive hat" the player receives during the month of December
    // causes them to appear in a white-on-red color scheme.
    Clr[Colors.Festive_Player] =
        new Color_Pair( C_WHITE, C_RED, -1, true, false );

    // The "Water" color scheme is for dangerous bodies of water.
    Clr[Colors.Water] =
        new Color_Pair( C_LITE_BLUE, C_BLUE, -1, true, false );

    // The "Lava" color scheme is used for lava pits.
    Clr[Colors.Lava] = new Color_Pair( C_YELLOW, C_RED, -1, true, false );

    // The "Acid" color scheme is used for pools of acid.
    Clr[Colors.Acid] = new Color_Pair( C_YELLOW, C_GREEN, -1, true, false );

    // The group 11 chemicals are often referred to as "coinage metals," owing
    // to their popularity as coinage metals in the real world.  The
    // stand-out, roentgenium, has yet to be encountered in nature and has
    // unknown chemical properties, but is predicted to be a silvery color and
    // is included in here essentially as a pun.  Its color is "old silver,"
    // to distinguish it from silver and suggest that it is impure.
    Clr[Colors.Copper] = new Color_Pair( C_COPPER, 5, false, false );
    Clr[Colors.Silver] = new Color_Pair( C_SILVER, 8, false, false );
    Clr[Colors.Gold]   = new Color_Pair( C_GOLD,   5, true,  false );
    Clr[Colors.Roentgenium] = new Color_Pair( C_ROENTGENIUM, 1, true, false );

    // The "Money" color is used for bank notes.
    Clr[Colors.Money] = new Color_Pair( C_WHITE, C_MONEY, -1, true, false );

    // "Royal" colors are used to mark members of the nobility and may be used
    // for banners in royal courts.
    Clr[Colors.Royal] = new Color_Pair( C_GOLD, C_ROYAL, -1, true, false );

    // Lapis lazuli was a blue pigment so coveted in the ancient world that it
    // was only used for the most important artworks, which is why it was
    // often used for religious pieces.
    Clr[Colors.Holy] = new Color_Pair( C_WHITE, C_HOLY, -1, true, false );

    // "Snow" is used for snowy environmnents.  "Snow_Tree" is used for
    // evergreen trees in snowy environments.
    Clr[Colors.Snow] = new Color_Pair( C_WHITE, C_GRAY, -1, true, true );
    Clr[Colors.Snow_Tree] =
        new Color_Pair( C_WHITE, C_GREEN, -1, true, true );
} // void init_colors()
