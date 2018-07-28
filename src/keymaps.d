/*
 * Copyright (c) 2016-2018 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */

// Defines control schemes, referred to herein as "Keymaps"

import global;

// Because some configurations no longer rely on curses we can't define keys
// using existing curses macros anymore, at least not every time
// TODO: Implement these keys in SDL
static if( CURSES_ENABLED )
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

/////////////
// Keymaps //
/////////////

// The global list of labels for keymaps; thise are used in the "Control
// scheme swapped to %s" message.  The first value will be the name of the
// default control scheme.  The "Custom" label should always be last.
static string[] Keymap_labels = ["Standard", "Dvorak",
"Custom"];

// IMPORTANT: Make sure `Keymap_labels' and `Keymaps' are the same length,
// and the keymaps in `Keymaps' are in the same order as the labels in
// `Keymap_labels'.  IE, Keymap_labels[0] should be the label for Keymaps[0]

// The global list of `Keymaps'--this is defined in main()
static uint[char][] Keymaps;
static uint Current_keymap = 0;
