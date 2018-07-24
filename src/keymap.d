/*
 * Copyright (c) 2016-2018 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */

// Declares a class `Keymap' which stores control schemes.

class Keymap
{
  // Standard movement keys
  char nn = 'k';
  char ne = 'u';
  char ee = 'l';
  char se = 'n';
  char ss = 'j';
  char sw = 'b';
  char ww = 'h';
  char nw = 'y';
  char wait = '.'

  // Menu navigation keys
  char menu_up    = 'k';
  char menu_down  = 'j';
  char menu_left  = 'h';
  char menu_right = 'l';

  // Inventory management
  char inv   = 'i';
  char wield = 'w';
  char get   = ',';

  // Messages
  char clear_msg = ' ';
  char read_msg  = 'P';

  // NOTE: The "quit," "help," "version," and "switch control scheme" keys are
  // not determined by this class; they are set in ``keys.d''.
  // Additionally, the normal numpad key commands are not determined by this
  // class; they are standardized, so they are kept in ``keys.d''.
}

// The default control scheme:
Keymap Standard = new Keymap();
