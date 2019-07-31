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

// This is the configuration file for Spelunk!.  It defines flags which affect
// how your copy of Spelunk! will compile.

// SECTION 0: ////////////////////////////////////////////////////////////////
// Instructions for the compiler                                            //
//////////////////////////////////////////////////////////////////////////////

/// Setting this to `true` will cause the program to output the current git
/// commit number when asked for the version number.  This will not affect
/// version numbers which are output to save files for compatibility purposes.
/// If you are not compiling from a git repository, you'll have to set this to
/// `false` in order to compile.
enum INCLUDE_COMMIT = true;

// SECTION 1: ////////////////////////////////////////////////////////////////
// Display configuration                                                    //
//////////////////////////////////////////////////////////////////////////////

/// What character to use for the player.  `'@'` is recommended.
enum SMILEY = '@';

/// Whether to use reversed graphics to make walls look more solid and
/// connected (this makes the game much more pleasing to the eye on a number
/// of terminals I tested with it)
enum REVERSED_WALLS = true;

/// Enables color.
enum COLOR = true;

/// Enables foliage.  Foliage grows randomly in dungeons and has no practical
/// effect on gameplay other than turning tiles green.
enum FOLIAGE = true;

/// Enables blood.  Blood splatter will appear on map tiles when a creature is
/// hit.  This has no practical effect other than turning map tiles red.
enum BLOOD = true;

// Curses-only options: //

/// Enables special effects like the highlighted player and reversed walls.
/// Only works if your curses standard uses these effects (it probably does).
enum TEXT_EFFECTS = true;

// SDL-only options //

/// A path to a font file to use for the map
enum FONT = "assets/fonts/DejaVuSansMono.ttf";
//enum FONT = "assets/fonts/DejaVuSansMono-Bold.ttf";
/// A path to a font file to use for the message buffer, status bar, and other
/// messages
enum MESSAGE_FONT = "assets/fonts/DejaVuSansMono-Bold.ttf";

/// The height to use for each tile in pixels
enum TILE_HEIGHT = 16;
/// The width to use for each tile in pixels
enum TILE_WIDTH = 8;

/// Whether to highlight the player in the game display.  This only has an
/// effect on the SDL virtual terminal display, as the curses terminal
/// highlights the player using the cursor.
enum HILITE_PLAYER = true;

// SECTION 2: ////////////////////////////////////////////////////////////////
// Spelunk! configuration                                                   //
//////////////////////////////////////////////////////////////////////////////

/// The number of messages to store in the message buffer
enum MAX_MESSAGE_BUFFER = 20;
