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

  SDL_Window* window;
  SDL_Renderer* renderer;

  SDL_Texture*[] tileset;

  enum tile_width = 7;
  enum tile_height = 11;

  /////////////////////
  // Setup & Cleanup //
  /////////////////////

  this()
  {
    // Load SDL:
    DerelictSDL2.load();
    DerelictSDL2ttf.load();

    if( SDL_Init( SDL_INIT_VIDEO ) < 0 )
    { sdl_error( "Could not initialize SDL" );
    }
    else if( TTF_Init() < 0 )
    { sdl_error( "Could not initialize SDL_ttf" );
    }
    else
    {
      // Create the SDL window:
      window = SDL_CreateWindow( toStringz( format( "Spelunk! v%f", VERSION ) ),
                                 SDL_WINDOWPOS_UNDEFINED,
                                 SDL_WINDOWPOS_UNDEFINED, MAP_X * tile_width, MAP_Y * tile_height,
                                 SDL_WINDOW_SHOWN );

      if( window == null )
      { sdl_error( "Could not create window" );
      }
      else
      {
        // This code was cannibalized from Elronnd's SmugglerRL project:

        // Get the renderer
        renderer = SDL_CreateRenderer( window, -1,
          SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC );

        // Load the default font
        if( !loadfont( "assets/fonts/ProggySquareSZ.ttf", 11, tileset ) )
        { sdl_error( "Could not import ProggySquareSZ" );
        }

        // (end cannibalized code)
      }
    }
  }

  // Final clearing of the display before the game is closed
  void cleanup()
  {
    // Destroy all textures in the tileset (cannibalized from SmugglerRL):
    foreach( ref texture; tileset )
    { SDL_DestroyTexture( texture );
    }

    // Destroy the SDL window
    SDL_DestroyWindow( window );

    // Quit all SDL subsystems
    SDL_Quit();
  }

  //////////////////////////////////
  // SDL-specific setup functions //
  //////////////////////////////////

  // The following code was cannibalized from Elronnd's SmugglerRL project:

  // Load fonts into an `SDL_Texture' pointer represented by `target'.
  // Returns `true' if successful, `false' otherwise.
  private bool loadfont( string fpath, ushort height,
                         ref SDL_Texture*[] target )
  {
    import std.string : toStringz;

    // Load the font from the file specified by `fpath'
    TTF_Font* font = TTF_OpenFont( toStringz( fpath ), height );

    // Check if the font was loaded.  If not, return `false'; this will cause
    // the constructor to throw an `SDLException'
    if( !font )
    { return false;
    }

    // This is a "just-in-case" call to ensure that the font is monospaced:
    TTF_SetFontKerning( font, 0 );

    // A temporary surface to render the font onto:
    SDL_Surface* surface;
    SDL_Color white = SDL_Color( 255, 255, 255, 0 );

    ushort[2] text;

    target = new SDL_Texture*[65536];

    // For each glyph provided by the font, render it onto `surface' and then
    // convert it into a `SDL_Texture' stored in `target'
    foreach( ushort i; 0 .. 65536 )
    {
      if( TTF_GlyphIsProvided( font, i ) )
      {
        text[0] = i;
        surface = TTF_RenderUNICODE_Blended( font, text.ptr, white );
        target[i] = SDL_CreateTextureFromSurface( renderer, surface );
        SDL_FreeSurface( surface );
      }
      else
      { target[i] = null;
      }
    }

    // Release the font file
    TTF_CloseFont( font );

    // Report success
    return true;
  }

  uint max_x()
  {
    SDL_DisplayMode dm;
    SDL_GetCurrentDisplayMode( 0, &dm );
    return dm.w / tile_width;
  }

  uint max_y()
  {
    SDL_DisplayMode dm;
    SDL_GetCurrentDisplayMode( 0, &dm );
    return dm.h / tile_height;
  }

  // (end cannibalized code)

  ///////////
  // Input //
  ///////////

  // Takes in an input and returns an action.
  uint getcommand()
  {
    // You might recognize `c' here from the CursesIO version of this function
    // Unlike Elronnd's original function, we have to handle command
    // interpretation in this function (probably something to genericize later
    // TODO)
    char c;

    // The following code was cannibalized from Elronnd's SmugglerRL project:

    SDL_Event e;

    SDL_StartTextInput();
    while( true )
    {
      if( SDL_WaitEvent( &e ) == 1 )
      {
        if( e.type == SDL_TEXTINPUT )
        { c = e.text.text[0];
          break;
        }
        // gained focus, so we need to redraw.  IDK why
        else if( e.type == SDL_WINDOWEVENT )
        { refresh_screen();
          if ( e.window.event == SDL_WINDOWEVENT_CLOSE )
          { return MOVE_QUIT;
          }
        }
      }
      else
      { sdl_error( "Wait event failed" );
      }
    }

    // (end cannibalized code--the rest of this function is identical to
    // `CursesIO.getcommand()', except without curses key definitions)

    // First check if `c' is contained in the player's keymap (see `keymap.d')
    uint* cmd = (c in Keymaps[Current_keymap]);

    // If so, return the appropriate command:
    if( cmd !is null )
    { return Keymaps[Current_keymap].get( c, MOVE_UNKNOWN );
    }

    // If not, check the standard prompts:
    switch( c )
    {

      // Number pad keys:
      case '7':
        return MOVE_NW;
      case '8':
        return MOVE_NN;
      case '9':
        return MOVE_NE;
      case '6':
        return MOVE_EE;
      case '3':
        return MOVE_SE;
      case '2':
        return MOVE_SS;
      case '1':
        return MOVE_SW;
      case '4':
        return MOVE_WW;
      case '5':
        return MOVE_WAIT;

      // If it's not in any of the standard controls or the number pad
      // controls, check the "admin keys":
      case 'Q':
        return MOVE_QUIT;
      case 'v':
        return MOVE_GETVERSION;
      case '@':
        return MOVE_ALTKEYS;
      case '?':
        return MOVE_HELP;

      default:
        // Handle the default case outside this switch statement
        break;

    } // switch( c )

    // If none of the above command prompts match, default to the "command
    // not recognized" response.
    return MOVE_UNKNOWN;


  } // uint getcommand()

  // Reads the player all of their messages one at a time
  void read_messages()
  {
    // XXX
  }

  // Gives the player a menu containing their message history.
  void read_message_history()
  {
    // XXX
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
  // functions (cannibalized from SmugglerRL)
  void refresh_screen()
  { SDL_RenderPresent( renderer );
  }

  // Displays a help screen and then waits for the player to clear it
  void help_screen()
  {
  }

  // The central `display' function.  Displays a given `symbol' at given
  // coordinates.  If `center', the cursor will be centered over the symbol
  // after drawing, rather than passing to the right of it as is standard in
  // curses.
  // This function was cannibalized from Elronnd's SmugglerRL project
  // (although his original function was more detailed)
  void display( uint y, uint x, symbol s, bool center = true )
  {
    char ch = s.ch;

    SDL_Texture* renderedchar;

    // null means there's no glyph, so fall back on a backup character
    if( tileset[ch] is null )
    { renderedchar = tileset['?'];
    }
    else
    { renderedchar = tileset[ch];
    }

    // Draw a square with the background color (this will erase any character
    // that was there before), then draw the character on top of it with
    // transparency so we see the background
    SDL_Rect tile;

    tile.y = y * tile_height;
    tile.x = x * tile_width;
    tile.w = tile_width;
    tile.h = tile_height;

    // TODO: Implement color (when we eventually get around to implementing
    // color for the game)
    // TODO: Implement reverse
    SDL_SetRenderDrawColor( renderer, 0, 0, 0, 255 );

    // Draw the rectangle:
    SDL_RenderFillRect( renderer, &tile );

    // Colorize the letter.  The parts that aren't the letter will also get
    // colorized, but that doesn't matter because they have alpha 256
    SDL_SetTextureColorMod( renderedchar, 255, 255, 255 );

    // And finally, copy everything over to the actual renderer
    SDL_RenderCopy( renderer, renderedchar, null, &tile );
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
