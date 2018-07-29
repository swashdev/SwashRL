/*
 * Copyright (c) 2016-2018 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */

// Defines the interface for functions related to program output for the
// SDL terminal interface.

version( sdl )
{

import global;

import std.string : fromStringz;
import std.string : toStringz;
import std.format;

// For catching exceptions when initializing or working with SDL:
class SDLException : Exception
{
  import std.exception : basicExceptionCtors;
  mixin basicExceptionCtors;
}

void sdl_error( string error = "" )
{
  throw new SDLException( format( "Error: %s.  SDL says: ", error,
                          fromStringz( SDL_GetError() ) ) );
}

class SDLTerminalIO : SpelunkIO
{

  SDL_Window* window = null;
  SDL_Surface* screen_surface = null;

  /////////////////////
  // Setup & Cleanup //
  /////////////////////

  this()
  {
    import std.stdio : writeln;

    // Load SDL:
    DerelictSDL2.load();
    DerelictSDL2ttf.load();

    if( SDL_Init( SDL_INIT_VIDEO ) < 0 )
    { sdl_error( "Could not initialize SDL" );
    }
    else
    {
      // Create the SDL window:
      window = SDL_CreateWindow( toStringz( format( "Swash! v%f", VERSION ) ),
                                 SDL_WINDOWPOS_UNDEFINED,
                                 SDL_WINDOWPOS_UNDEFINED, 640, 480,
                                 SDL_WINDOW_SHOWN );

      if( window == null )
      { sdl_error( "Could not create window" );
      }
      else
      {
        // Get window surface
        screen_surface = SDL_GetWindowSurface( window );

        // Fill the surface with white
        SDL_FillRect( screen_surface, null,
                      SDL_MapRGB( screen_surface.format, 0xFF, 0xFF, 0xFF ) );
      }
    }
  }

  // Final clearing of the display before the game is closed
  void cleanup()
  {
  }

  ///////////
  // Input //
  ///////////

  // Takes in an input and returns an action.
  uint getcommand()
  {
    // XXX
    return 0;
  }

  // Reads the player all of their messages one at a time
  void read_messages()
  {
  }

  // Gives the player a menu containing their message history.
  void read_message_history()
  {
  }

  // Displays the `player's inventory and enables them to control it.  Returns
  // the number of turns the player spent on the inventory screen.
  uint control_inventory( player* u )
  {
    // XXX
    return 0;
  }

  ////////////
  // Output //
  ////////////

  // Refreshes the screen to reflect the changes made by the below output
  // functions
  void refresh_screen()
  { SDL_UpdateWindowSurface( window );
  }

  // Displays a help screen and then waits for the player to clear it
  void help_screen()
  {
  }

  // The central `display' function.  Displays a given `symbol' at given
  // coordinates.  If `center', the cursor will be centered over the symbol
  // after drawing, rather than passing to the right of it as is standard in
  // curses.
  void display( uint y, uint x, symbol s, bool center = true )
  {
  }

  // uses `display' to clear the current message off the message line
  void clear_message_line()
  {
  }

  // refreshes the status bar with the given `player's status
  void refresh_status_bar( player* u )
  {
  }
} // class SDLTerminalIO

} // version( sdl )
