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

// This is the configuration file for Spelunk!.  It defines flags which affect
// how your copy of Spelunk! will compile.

// SECTION 1: ////////////////////////////////////////////////////////////////
// Display configuration                                                    //
//////////////////////////////////////////////////////////////////////////////

// What character to use for the player.  '@' is recommended.
enum SMILEY = '@';

// Whether to use reversed graphics to make walls look more solid and
// connected (this makes the game much more pleasing to the eye on a number
// of terminals I tested with it)
enum REVERSED_WALLS = true;

// Enables color.
enum COLOR = true;

// Enables foliage.  Foliage grows randomly in dungeons and has no practical
// effect on gameplay other than turning tiles green.
enum FOLIAGE = false;  // NOT YET IMPLEMENTED

// Enables blood.  Blood splatter will appear on map tiles when a creature is
// hit.  This has no practical effect other than turning map tiles red.
enum BLOOD = false;  // NOT YET IMPLEMENTED

// Curses-only options: //

// Enables special effects like the highlighted player and reversed walls.
// Only works if your curses standard uses these effects (it probably does).
enum TEXT_EFFECTS = true;

// SDL-only options //

// Whether to highlight the player in the game display.  This only has an
// effect on the SDL virtual terminal display, as the curses terminal
// highlights the player using the cursor.
enum HILITE_PLAYER = true;

// SECTION 2: ////////////////////////////////////////////////////////////////
// Spelunk! configuration                                                   //
//////////////////////////////////////////////////////////////////////////////

// Set USE_FOV to false if you need to be able to see the whole map (say, for
// debugging, testing, &c)
enum USE_FOV = true;

// The number of messages to store in the message buffer
enum MAX_MESSAGE_BUFFER = 20;

// These lines will define the lowest and highest possible dice roll,
// including modifiers, that is possible in-game.  If adjusted they will not
// necessarily impact all die rolls, but will impact die rolls with a minimum
// and maximum result.  The standard of -1000 and 1000 essentially mean no
// limit, as it is highly improbable that you fill find a monster that hits
// that hard.
// XXX: Are these values really necessary?
enum MINIMUM_DIE_ROLL = -1000;
enum MAXIMUM_DIE_ROLL = 1000;
