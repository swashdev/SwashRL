/*
 * Copyright (c) 2016-2018 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */

// Defines functions related to program output (graphics, &c)

import global;

// This interface is the skeleton for all of the different display modes.
interface SpelunkIO
{

  /////////////////////
  // Setup & Cleanup //
  /////////////////////

  // Final clearing of the display before the game is closed
  void cleanup();

  ///////////
  // Input //
  ///////////

  // Takes in an input and returns an action.
  int read();

  ////////////
  // Output //
  ////////////

  // The central `display' function.  Displays a given `symbol' at given
  // coordinates.  If `center', the cursor will be centered over the symbol
  // after drawing, rather than passing to the right of it as is standard in
  // curses.
  void display( uint y, uint x, symbol s, bool center = true );

  // uses `display' to draw the given `player'
  final void display_player( player u )
  { display( u.y, u.x, u.sym, true );
  }

  // uses `display' to draw the given `monst'er
  final void display_mon( monst m )
  { display( m.y, m.x, m.sym );
  }

  // uses `display_mon' to draw all the `monst'ers on the given `map'
  final void display_map_mons( map to_display )
  {
    size_t d = to_display.m.length;
    monst mn;
    foreach( c; 0 .. d )
    {
      mn = to_display.m[c];

static if( USE_FOV )
{
     if( to_display.v[mn.y][mn.x] )
     { display_mon( mn );
     }
}
else
{
     display_mon( mn );
}

    } /* foreach( c; 0 .. d ) */
  }

  // uses `display' to draw all of the map 'tile's on the given `map'
  final void display_map( map to_display )
  {
    foreach( y; 0 .. MAP_Y )
    {
      foreach( x; 0 .. MAP_X )
      {
        symbol output = to_display.t[y][x].sym;

        if( to_display.i[y][x].sym.ch != '\0' )
        { output = to_display.i[y][x].sym;
        }

static if( USE_FOV )
{
        if( !to_display.v[y][x] )
        { output = SYM_SHADOW;
        }
} /* static if( USE_FOV ) */

        display( y + 1, x, output );
      } /* foreach( x; 0 .. MAP_X ) */
    } /* foreach( y; 0 .. MAP_Y ) */
  }

  // uses `display_map_mons' and `display_map' to draw the full `map'
  // including `monst'ers and `tile's
  final void display_map_all( map to_display )
  {
    display_map( to_display );
    display_map_mons( to_display );
  }

  // uses `display_map_all' and 'display_player' to draw the full `map' 
  // including `monst'ers, `tile's, and the given `player'
  final void display_map_and_player( map to_display, player u )
  {
    display_map_all( to_display );
    display_player( u );
  }

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
