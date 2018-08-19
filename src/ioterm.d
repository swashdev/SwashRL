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

// Defines the interface for functions related to program output for the
// SDL terminal interface.

version( sdl )
{

import global;

import std.string : fromStringz;
import std.string : toStringz;
import std.format;
import std.ascii : toLower;

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

class SDLTerminalIO : SwashIO
{

  SDL_Window* window;
  SDL_Renderer* renderer;

  // The default tileset for drawing the map &c:
  SDL_Texture*[] tileset;
  // The special tileset for drawing the message line, status bar, and other
  // "messages":
  SDL_Texture*[] message_font;

  // Which of the above two tilesets we are currently using
  SDL_Texture*[] cur_tileset;

  // This texture is used as a backup of the frame buffer, to prevent errors
  // when SDL's "back" and "front" frame buffers are swapped by the
  // `refresh_screen' function
  SDL_Texture* framebuffer;

  enum tile_width = TILE_WIDTH;
  enum tile_height = TILE_HEIGHT;

  bool close_button_pressed = false;

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
      // Disable antialiasing for the fonts:
      SDL_SetHint( SDL_HINT_RENDER_SCALE_QUALITY, "1" );

      // Create the SDL window:
      window = SDL_CreateWindow(
                               toStringz( format( "SwashRL v%.3f", VERSION ) ),
                                 SDL_WINDOWPOS_UNDEFINED,
                                 SDL_WINDOWPOS_UNDEFINED,
                                 MAP_X * tile_width, (MAP_Y + 2) * tile_height,
                                 SDL_WINDOW_SHOWN );


      if( window == null )
      { sdl_error( "Could not create window" );
      }
      else
      {
        // This code was cannibalized from Elronnd's SmugglerRL project:

        // Get the renderer
        renderer = SDL_CreateRenderer( window, -1,
          SDL_RENDERER_ACCELERATED );

        // Load the default font
        if( !loadfont( FONT, tile_height,
                       tileset ) )
        { sdl_error( "Could not import " ~ FONT );
        }

        // Load the message font
        if( !loadfont( MESSAGE_FONT, tile_height, message_font ) )
        { sdl_error( "Could not import " ~ MESSAGE_FONT );
        }

        // Set the current font to default
        cur_tileset = tileset;

        // (end cannibalized code)

        framebuffer = SDL_CreateTexture( renderer, SDL_PIXELFORMAT_RGB888,
                                         SDL_TEXTUREACCESS_TARGET,
                                         MAP_X * tile_width,
                                         (MAP_Y + 2) * tile_height );
      }
    }
  }

  bool window_closed()
  { return close_button_pressed;
  }

  // Final clearing of the display before the game is closed
  void cleanup()
  {
    // Destroy all textures in the tileset (cannibalized from SmugglerRL):
    foreach( texture; tileset )
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

  // Takes in a color index and returns an SDL color
  SDL_Color to_SDL_Color( ubyte color )
  {

    // Unfortunately this is one of those cases where we just have to use a
    // Switch Statement From Hell.
    switch( color )
    {
      case CLR_DARKGRAY:
        return SDL_DARKGRAY;

      case CLR_RED:
        return SDL_RED;

      case CLR_GREEN:
        return SDL_GREEN;

      case CLR_BROWN:
        return SDL_BROWN;

      case CLR_BLUE:
        // We don't use dark blue because it blends in with the black
        // background too much.
        goto case CLR_LITEBLUE;

      case CLR_MAGENTA:
        return SDL_MAGENTA;

      case CLR_CYAN:
        return SDL_CYAN;

      case CLR_GRAY:
        return SDL_GRAY;

      case CLR_BLACK:
        return SDL_BLACK;

      case CLR_LITERED:
        return SDL_LITERED;

      case CLR_LITEGREEN:
        return SDL_LITEGREEN;

      case CLR_YELLOW:
        return SDL_YELLOW;

      case CLR_LITEBLUE:
        return SDL_BLUE;

      case CLR_LITEMAGENTA:
        return SDL_LITEMAGENTA;

      case CLR_LITECYAN:
        return SDL_LITECYAN;
 
      case CLR_WHITE:
        return SDL_WHITE;

      // If we don't get a valid color, default to the "standard color"
      default:
        goto case CLR_GRAY;
    } // switch( color )
  } // SDL_Color to_SDL_Color( ubyte )

  ///////////
  // Input //
  ///////////

  char get_key()
  {
    // The following code was cannibalized from Elronnd's SmugglerRL project:

    SDL_Event e;

    SDL_StartTextInput();
    while( true )
    {
      if( SDL_WaitEvent( &e ) == 1 )
      {
        if( e.type == SDL_TEXTINPUT )
        { return e.text.text[0];
        }
        // gained focus, so we need to redraw.  IDK why
        else if( e.type == SDL_WINDOWEVENT )
        {
          refresh_screen();
          if ( e.window.event == SDL_WINDOWEVENT_CLOSE )
          {
            close_button_pressed = true;
            return 'Q';
          }
        }
      }
      else
      { sdl_error( "Wait event failed" );
      }
    }

    // (end cannibalized code)
  }

  // Outputs a question to the user and returns a char result
  char ask( string question, char[] options, bool assume_lower = false )
  {
    clear_message_line();
    char[] q = (question ~ " [").dup;
    foreach( c; 0 .. options.length )
    {
      q ~= options[c];
      if( c + 1 < options.length )
      { q ~= '/';
      }
    }
    q ~= ']';

    cur_tileset = message_font;
    put_line( 0, 0, q );
    cur_tileset = tileset;
    refresh_screen();

    char answer = '\0';

    while( true )
    {
      answer = get_key();

      // If the player attempted to close the window while SDL was waiting
      // for input, break the loop now and signal the mainloop to shut down.
      if( close_button_pressed ) return 255;

      if( assume_lower ) answer = toLower( answer );

      foreach( c; 0 .. options.length )
      { if( answer == options[c] ) return answer;
      }
    }
  }

  ////////////
  // Output //
  ////////////

  void put_char( uint y, uint x, char c,
                 Color color = Color( CLR_NONE, false ) )
  {

    // Tell the renderer to draw to our own `framebuffer' rather than the
    // screen so we have better control over the contents of the backbuffer
    SDL_SetRenderTarget( renderer, framebuffer );

    // The following code was cannibalized from Elronnd's SwashRL project:

    SDL_Texture* renderedchar;

    Color co = color;

    // null means there's no glyph, so fall back on a backup character
    if( cur_tileset[c] is null )
    {
      renderedchar = cur_tileset['?'];
      co = Color( CLR_LITERED, true );
    }
    else
    { renderedchar = cur_tileset[c];
    }

    // Draw a square with the background color (this will erase any character
    // that was there before), then draw the character on top of it with
    // transparency so we see the background
    SDL_Rect tile;

    tile.y = y * tile_height;
    tile.x = x * tile_width;
    tile.w = tile_width;
    tile.h = tile_height;

    // The color of the foreground and background, respectively
    SDL_Color fg, bg;

    // Assign `fg' and `bg' appropriately
    if( co.reverse )
    {
      fg = SDL_BLACK;
      bg = to_SDL_Color( co.fg );
    }
    else
    {
      fg = to_SDL_Color( co.fg );
      bg = SDL_BLACK;
    }

    // Fill in the background first:
    SDL_SetRenderDrawColor( renderer, bg.r, bg.g, bg.b, 255 );

    // Draw the rectangle:
    SDL_RenderFillRect( renderer, &tile );

    // Colorize the letter.  The parts that aren't the letter will also get
    // colorized, but that doesn't matter because they have alpha 256
    SDL_SetTextureColorMod( renderedchar, fg.r, fg.g, fg.b );

    // And finally, copy everything over to the actual renderer
    SDL_RenderCopy( renderer, renderedchar, null, &tile );

    // (end cannibalized code)
  }

  // Reads the player all of their messages one at a time
  void read_messages()
  {
    // Because we're writing to the message line, set the current tileset to
    // the special `message_font':
    cur_tileset = message_font;

    while( !Messages.empty() )
    {
      clear_message_line();
      put_line( 0, 0, "%s%s", pop_message(),
                Messages.empty() == false ? "  (More)" : "" );
      refresh_screen();

      if( !Messages.empty() )
      { get_key();
      }
    }

    // We're done displaying messages, so set the current tileset back to the
    // default `tileset':
    cur_tileset = tileset;
  }

  // Gives the player a menu containing their message history.
  void read_message_history()
  {
    clear_screen();

    // Because we're outputting a message, set the current tileset to the
    // special `message_font':
    cur_tileset = message_font;

    uint actual_c = 0;
    foreach( c; 0 .. Message_history.length )
    {
      if( actual_c > 23 )
      {
        refresh_screen();
        get_key();
        clear_screen();
        actual_c = 0;
      }

      put_line( actual_c, 0, Message_history[c] );

      actual_c++;
    }

    refresh_screen();
    get_key();
    clear_message_line();

    // We're done displaying messages, so set the current tileset back to the
    // default `tileset':
    cur_tileset = tileset;
  }

  // Refreshes the status bar
  void refresh_status_bar( player* u )
  {
    int hp = u.hp;
    int dice = u.attack_roll.dice + u.inventory.items[INVENT_WEAPON].addd;
    int mod = u.attack_roll.modifier + u.inventory.items[INVENT_WEAPON].addm;

    // Because the status bar is considered a "message," switch the current
    // tileset to the special `message_font':
    cur_tileset = message_font;

    foreach( x; 0 .. MAP_X )
    { put_char( 1 + MAP_Y, x, ' ' );
    }
    put_line( 1 + MAP_Y, 0, "HP: %d    Attack: %ud %c %u",
              hp, dice, mod >= 0 ? '+' : '-', mod * ((-1) * mod < 0) );

    // We're done displaying messages, so set the current tileset back to the
    // default `tileset':
    cur_tileset = tileset;
  }

  // Refreshes the screen to reflect the changes made by the below output
  // functions (cannibalized from SmugglerRL)
  void refresh_screen()
  {
    // Set the `renderer' back on the screen itself to copy the contents of
    // `framebuffer' to the buffer before blitting everything
    SDL_SetRenderTarget( renderer, null );
    SDL_RenderCopy( renderer, framebuffer, null, null );

    SDL_RenderPresent( renderer );
  }

  void clear_screen()
  {
    SDL_SetRenderTarget( renderer, framebuffer );
    SDL_SetRenderDrawColor( renderer, 0, 0, 0, 255 );
    SDL_RenderClear( renderer );
  }

  // Cover the message line with a black rectangle
  void clear_message_line()
  {
    SDL_Rect rect;
    rect.y = rect.x = 0;
    rect.w = tile_width * MAP_X;
    rect.h = tile_height;

    SDL_SetRenderTarget( renderer, framebuffer );

    SDL_SetRenderDrawColor( renderer, 0, 0, 0, 255 );

    SDL_RenderFillRect( renderer, &rect );
  }

  // The central `display' function.  Displays a given `symbol' at given
  // coordinates.  If `center', the cursor will be centered over the symbol
  // after drawing, rather than passing to the right of it as is standard in
  // curses.
  void display( uint y, uint x, symbol s, bool center = true )
  {
    put_char( y, x, s.ch,
              COLOR ? s.color : Color( CLR_GRAY, s.color.reverse ) );
  }
} // class SDLTerminalIO

} // version( sdl )
