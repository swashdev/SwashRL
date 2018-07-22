/*
 * Copyright (c) 2016-2018 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */

// Defines functions related to program output (graphics, &c)

import global;

// This interface is the skeleton for all of the different display modes.
interface Display
{

  // Initial setup for the display
  void setup();

  // Final clearing of the display before the game is closed
  void cleanup();

  // The central `display' function.  Displays a given `symbol' at given
  // coordinates.  If `center', the cursor will be centered over the symbol
  // after drawing, rather than passing to the right of it as is standard in
  // curses.
  void display( uint y, uint x, symbol s, bool center = false );

  // uses `display' to draw the given `player'
  void display_player( player u );

  // uses `display' to draw the given `monst'er
  void display_mon( monst m );

  // uses `display_mon' to draw all the `monst'ers on the given `map'
  void display_map_mons( map to_display );

  // uses `display' to draw all of the map 'tile's on the given `map'
  void display_map( map to_display );

  // uses `display_map_mons' and `display_map' to draw the full `map'
  // including `monst'ers and `tile's
  void display_map_all( map to_display );

  // uses `display_map_all' and 'display_player' to draw the full `map' 
  // including `monst'ers, `tile's, and the given `player'
  void display_map_and_player( map to_display, player u )

  // uses `display' to clear the current message off the message line
  void clear_message_line();

  // refreshes the status bar with the given `player's status
  void refresh_status_bar( player* u );

} /* interface Display */

// Import the classes which expand on this template depending on what display
// outputs have been compiled:

static if( SPELUNK_CURSES )
{ import displayc; /* display interface for curses */
}

static if( !GFX_NONE )
{ import displayt; /* display interface for sdl terminal */
}
