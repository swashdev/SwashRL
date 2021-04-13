/*
 * Copyright (c) 2015-2021 Philip Pavlick.  See '3rdparty.txt' for other
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

// This is the configuration file for SwashRL.  It defines flags which affect
// how your copy of SwashRL will compile.

// SECTION 0: ////////////////////////////////////////////////////////////////
// Instructions for the compiler                                            //
//////////////////////////////////////////////////////////////////////////////

// Setting this to `true` will cause the program to output the current git
// commit number when asked for the version number.  This will not affect
// version numbers which are output to save files for compatibility purposes.
// If you are not compiling from a git repository, you'll have to set this to
// `false` in order to compile.
enum INCLUDE_COMMIT = true;

// SECTION 1: ////////////////////////////////////////////////////////////////
// Display configuration                                                    //
//////////////////////////////////////////////////////////////////////////////

// What character to use for the player.  `'@'` is recommended.
enum SMILEY = '@';

// Whether to use reversed graphics to make walls look more solid and
// connected (this makes the game much more pleasing to the eye on a number
// of terminals I tested with it)
enum REVERSED_WALLS = true;

// Color settings ////////////////////////////////////////////////////////////

// Enables color.  This setting will also enable the FOLIAGE and BLOOD
// settings, defined below, if they are set to `true`.
enum COLOR = true;

// Enables foliage.  Foliage grows randomly in dungeons and has no practical
// effect on gameplay other than turning tiles green.
enum FOLIAGE = true;

// Enables blood.  Blood splatter will appear on map tiles when a creature is
// hit.  This has no practical effect other than turning map tiles red.
enum BLOOD = true;

// Curses-specific options ///////////////////////////////////////////////////

// Enables special effects like the highlighted player and reversed walls.
// Only works if your curses standard uses these effects (it probably does).
enum TEXT_EFFECTS = true;

// SDL-specific options //////////////////////////////////////////////////////

// These configuration settings will define the font used by the SDL terminal
// interface.  `FONT` must be either a blank string "" or a string
// representing a path to a TTF font file.  `FONT_HEIGHT` and `FONT_WIDTH`
// represent the height and width of tiles created by the font, respectively.
// If the specified font doesn't exist, or `FONT` is an empty string, SwashRL
// will use the built-in font bd-font as a fallback.
enum FONT = "assets/fonts/DejaVuSansMono.ttf";
enum FONT_HEIGHT = 16;
enum FONT_WIDTH = 8;

// `STRETCH_FONT` will stretch bd-font to 16x8 rather than 8x8.  Might be
// more readable for some users.  Has no effect if a TTF font is specified
// above.
enum STRETCH_FONT = true;

// SECTION 2: ////////////////////////////////////////////////////////////////
// SwashRL configuration                                                    //
//////////////////////////////////////////////////////////////////////////////

// The number of messages to store in the message buffer
enum MAX_MESSAGE_BUFFER = 20;

// Add more test monsters to the test map.  Only relevant to debug builds.
debug
{
    enum MORE_TEST_MONSTERS = false;
}
