/*
 * Copyright (c) 2016-2018 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */

// This is the configuration file for Spelunk!.  It defines flags which affect
// how your copy of Spelunk! will compile.

// SECTION 1: ////////////////////////////////////////////////////////////////
// Display configuration                                                    //
//////////////////////////////////////////////////////////////////////////////

// What character to use for the player.  '@' is recommended.
enum SMILEY = '@';

// Curses-only options: //

// Enables special effects like the highlighted player and reversed walls.
// Only works if your curses standard uses these effects (it probably does).
enum TEXT_EFFECTS = true;

// Whether to use reversed graphics to make walls look more solid and
// connected (this makes the game much more pleasing to the eye on a number
// of terminals I tested with it)
enum REVERSED_WALLS = true;

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
