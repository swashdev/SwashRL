/*
 * Copyright (c) 2016-2018 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */

import global;

// Macros for getting the function keys (we'll only use 12 here since that's
// the standard)

// Because some configurations no longer rely on curses we can't define keys
// using existing curses macros anymore, at least not every time
static if( SPELUNK_CURSES )
{
  enum KEY_F1  = (KEY_F0 +  1);
  enum KEY_F2  = (KEY_F0 +  2);
  enum KEY_F3  = (KEY_F0 +  3);
  enum KEY_F4  = (KEY_F0 +  4);
  enum KEY_F5  = (KEY_F0 +  5);
  enum KEY_F6  = (KEY_F0 +  6);
  enum KEY_F7  = (KEY_F0 +  7);
  enum KEY_F8  = (KEY_F0 +  8);
  enum KEY_F9  = (KEY_F0 +  9);
  enum KEY_F10 = (KEY_F0 + 10);
  enum KEY_F11 = (KEY_F0 + 11);
  enum KEY_F12 = (KEY_F0 + 12);
}

// vi-like keys (nethack-like keys?)
enum MV_NN = 'k';
enum MV_NE = 'u';
enum MV_EE = 'l';
enum MV_SE = 'n';
enum MV_SS = 'j';
enum MV_SW = 'b';
enum MV_WW = 'h';
enum MV_NW = 'y';

enum KY_INV = 'i';
enum KY_WIELD = 'w';

enum MV_WT = '.';

// alt vi-like keys; hjkl are the same, but diagonal movement is mapped closer
// to the right hand.  'i'nventory is moved to 'b' (for bag)
enum AL_NN = 'k';
enum AL_NE = 'i';
enum AL_EE = 'l';
enum AL_SE = 'm';
enum AL_SS = 'j';
enum AL_SW = 'n';
enum AL_WW = 'h';
enum AL_NW = 'u';

enum AL_INV = 'b';

// numpad keys
enum NP_NN = '8';
enum NP_NE = '9';
enum NP_EE = '6';
enum NP_SE = '3';
enum NP_SS = '2';
enum NP_SW = '1';
enum NP_WW = '4';
enum NP_NW = '7';

enum NP_WT = '5';

// other keys

enum KY_GET = ',';

// spacebar to clear the message bar
enum KY_CLEAR = ' ';
// display the message buffer
enum KY_MESS  = 'P';

static if( SPELUNK_CURSES )
{
  enum KY_HJKL = KEY_F12;
}

// admin keys
enum KY_QUIT    = 'Q';

static if( SPELUNK_CURSES )
{
  enum KY_HELP    = KEY_F1;
  enum KY_VERSION = KEY_F4;
}
