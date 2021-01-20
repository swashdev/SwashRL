/*
 * Copyright (c) 2018-2021 Philip Pavlick.  See '3rdparty.txt' for other
 * licenses.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *  * Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *  * Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *  * Neither the name of the SwashRL project nor the names of its
 *    contributors may be used to endorse or promote products derived from
 *    this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

// ioterm.d: defines the interface for functions related to program output for
// the SDL terminal interface.

version( sdl )
{

    import global;

    import std.string : fromStringz;
    import std.string : toStringz;
    import std.format;
    import std.ascii : toLower;

// SECTION 0: ////////////////////////////////////////////////////////////////
// Exceptions & Error Handling                                              //
//////////////////////////////////////////////////////////////////////////////

    // An exception used for catching errors when initializing or working with
    // SDL.
    class SDL_Exception : Exception
    {
        import std.exception : basicExceptionCtors;
        mixin basicExceptionCtors;
    }

    // Generates an SDLException.
    void sdl_error( string error = "" )
    {
        throw new SDL_Exception( format( "Error: %s.  SDL says: ", error,
                    fromStringz( SDL_GetError() ) ) );
    }

    // This class contains functions and other members for the SDL "virtual
    // terminal" display.  See iomain.d for the SwashIO interface.
    class SDL_Terminal_IO : Swash_IO
    {

// SECTION 1: ////////////////////////////////////////////////////////////////
// Setup & Cleanup                                                          //
//////////////////////////////////////////////////////////////////////////////

        // The SDL window itself.
        SDL_Window* window;
        // A renderer used to render textures onto the SDL window.
        SDL_Renderer* renderer;

        // The default tileset for drawing the map &c.
        SDL_Texture*[] tileset;
        // The special tileset for drawing the message line, status bar, and
        // other "messages".
        SDL_Texture*[] message_font;

        // Which of the above two tilesets we are currently using.
        SDL_Texture*[] cur_tileset;

        // This texture is used as a backup of the frame buffer, to prevent
        // errors when SDL's "back" and "front" frame buffers are swapped by
        // the `refresh_screen` function.
        SDL_Texture* frame_buffer;

        uint tile_width;
        uint tile_height;

        bool close_button_pressed = false;

        // This constructor will initialize the SDL window.
        this()
        {
            // Load SDL:
            DerelictSDL2.load();
            DerelictSDL2ttf.load();

            // Set tile height & width.
            if( FONT.tile_height > MESSAGE_FONT.tile_height )
            {
                tile_height = FONT.tile_height;
            }
            else
            {
                tile_height = MESSAGE_FONT.tile_height;
            }

            if( FONT.tile_width > MESSAGE_FONT.tile_width )
            {
                tile_width = FONT.tile_width;
            }
            else
            {
                tile_width = MESSAGE_FONT.tile_width;
            }

            if( SDL_Init( SDL_INIT_VIDEO ) < 0 )
            {
                sdl_error( "Could not initialize SDL" );
            }
            else if( TTF_Init() < 0 )
            {
                sdl_error( "Could not initialize SDL_ttf" );
            }
            else
            {
                // Disable antialiasing for the fonts:
                SDL_SetHint( SDL_HINT_RENDER_SCALE_QUALITY, "1" );

                // Create the SDL window:
                window = SDL_CreateWindow(
                        toStringz( format( "%s v0.\u221E", NAME ) ),
                        SDL_WINDOWPOS_UNDEFINED,
                        SDL_WINDOWPOS_UNDEFINED,
                        MAP_X * tile_width, (MAP_Y + 2) * tile_height,
                        SDL_WINDOW_SHOWN );
      
                if( window == null )
                {
                    sdl_error( "Could not create window" );
                }
                else
                {
                    // This code was cannibalized from Elronnd's SmugglerRL
                    // project:

                    // Get the renderer
                    renderer = SDL_CreateRenderer( window, -1,
                            SDL_RENDERER_ACCELERATED );

                    // Load the default font
                    if( !loadfont( FONT.filepath, tile_height, tileset ) )
                    {
                        sdl_error( "Could not import " ~ FONT.filepath );
                    }

                    // Load the message font
                    if( !loadfont( MESSAGE_FONT.filepath, tile_height,
                                   message_font ) )
                    {
                        sdl_error( "Could not import "
                                   ~ MESSAGE_FONT.filepath );
                    }

                    // Set the current font to default
                    cur_tileset = tileset;

                    // (end cannibalized code)

        
                    frame_buffer = SDL_CreateTexture( renderer,
                            SDL_PIXELFORMAT_RGB888,
                            SDL_TEXTUREACCESS_TARGET,
                            MAP_X * tile_width,
                            (MAP_Y + 2) * tile_height );
                } // else from if( window == null )
            } // else from else if( TTF_Init() < 0 )
        } // this()

        // Final clearing of the display before the game is closed.
        void cleanup()
        {
            // Destroy all textures in the tileset (cannibalized from
            // SmugglerRL):
            foreach( texture; tileset )
            {
                SDL_DestroyTexture( texture );
            }

            // Destroy the SDL window
            SDL_DestroyWindow( window );

            // Quit all SDL subsystems
            SDL_Quit();
        }

        // Used to determine if the "close window" button has been pressed.
        bool window_closed()
        {
            return close_button_pressed;
        }

// SECTION 2: ////////////////////////////////////////////////////////////////
// SDL Utility Functions                                                    //
//////////////////////////////////////////////////////////////////////////////

        // The following code was cannibalized from Elronnd's SmugglerRL
        // project:

        // Loads fonts into an `SDL_Texture` pointer represented by `target`.
        private bool loadfont( string fpath, uint height,
                               ref SDL_Texture*[] target )
        {
            // Load the font from the file specified by `fpath`
            TTF_Font* font = TTF_OpenFont( toStringz( fpath ), height );

            // Check if the font was loaded.  If not, return `false`; this
            // will cause the constructor to throw an `SDLException`
            if( !font )
            {
                return false;
            }

            // This is a "just-in-case" call to ensure that the font is
            // monospaced:
            TTF_SetFontKerning( font, 0 );

            // A temporary surface to render the font onto:
            SDL_Surface* surface;

            SDL_Color white = SDL_Color( 255, 255, 255, 0 );

            ushort[2] text;

            target = new SDL_Texture*[65536];

            // For each glyph provided by the font, render it onto `surface`
            // and then convert it into a `SDL_Texture` stored in `target`
            foreach( ushort character; 0 .. 65536 )
            {
                if( TTF_GlyphIsProvided( font, character ) )
                {
                    text[0] = character;
                    surface = TTF_RenderUNICODE_Blended( font, text.ptr,
                            white );
                    target[character]
                        = SDL_CreateTextureFromSurface( renderer, surface );
                    SDL_FreeSurface( surface );
                }
                else
                {
                    target[character] = null;
                }
            }

            // Release the font file
            TTF_CloseFont( font );

            // Report success
            return true;
        } // private bool loadfont( string, uint, ref SDL_Texture*[] )

        // Gets the maximum x coordinate for the SDL virtual terminal.
        uint max_x()
        {
            SDL_DisplayMode display_mode;
            SDL_GetCurrentDisplayMode( 0, &display_mode );
            return display_mode.w / tile_width;
        }

        // Gets the maximum y coordinate for the SDL virtual terminal.
        uint max_y()
        {
            SDL_DisplayMode display_mode;
            SDL_GetCurrentDisplayMode( 0, &display_mode );
            return display_mode.h / tile_height;
        }

        // (end cannibalized code)

// SECTION 3: ////////////////////////////////////////////////////////////////
// Input                                                                    //
//////////////////////////////////////////////////////////////////////////////

        // Gets a character input from the user and returns it.
        char get_key()
        {
            // The following code was cannibalized from Elronnd's SmugglerRL
            // project:

            SDL_Event event;

            SDL_StartTextInput();

            while( true )
            {
                if( SDL_WaitEvent( &event ) == 1 )
                {
                    if( event.type == SDL_TEXTINPUT )
                    {
                        return event.text.text[0];
                    }
                    
                    // gained focus, so we need to redraw.  IDK why
                    else if( event.type == SDL_WINDOWEVENT )
                    {
                        refresh_screen();
                        if( event.window.event == SDL_WINDOWEVENT_CLOSE )
                        {
                            close_button_pressed = true;
                            return 'Q';
                        }
                    }
                }
                else
                {
                    sdl_error( "Wait event failed" );
                }
            } // while( true )

            // (end cannibalized code)
        } // char get_key()

        // Outputs a question to the user and returns a char result
        char ask( string question, char[] options = ['y', 'n'],
                  bool assume_lower = false )
        {
            clear_message_line();

            char[] output = (question ~ " [").dup;

            foreach( letter; 0 .. options.length )
            {
                output ~= options[letter];
      
                if( letter + 1 < options.length )
                {
                    output ~= '/';
                }
            }

            output ~= ']';

            cur_tileset = message_font;
            put_line( 0, 0, output );
            cur_tileset = tileset;
            refresh_screen();

            char answer = '\0';

            while( true )
            {
                answer = get_key();

                // If the player attempted to close the window while SDL was
                // waiting for input, break the loop now and signal the
                // mainloop to shut down.
                if( close_button_pressed )
                {
                    return 255;
                }

                if( assume_lower )
                {
                    answer = toLower( answer );
                }

                foreach( count; 0 .. options.length )
                {
                    if( answer == options[count] )
                    {
                        return answer;
                    }
                }
            } // while( true )
        } // char ask( string, char[]?, bool? )

// SECTION 4: ////////////////////////////////////////////////////////////////
// Output                                                                   //
//////////////////////////////////////////////////////////////////////////////

        // General Output ////////////////////////////////////////////////////

        // Clears the screen.
        void clear_screen()
        {
            SDL_SetRenderTarget( renderer, frame_buffer );
            SDL_SetRenderDrawColor( renderer, 0, 0, 0, 255 );
            SDL_RenderClear( renderer );
        }

        // Refreshes the screen to reflect the changes made by the below
        // output functions. (cannibalized from SmugglerRL)
        void refresh_screen()
        {
            // Set the `renderer` back on the screen itself to copy the
            // contents of `frame_buffer` to the buffer before blitting
            // everything
            SDL_SetRenderTarget( renderer, null );
            SDL_RenderCopy( renderer, frame_buffer, null, null );

            SDL_RenderPresent( renderer );
        }

        // Outputs a text character at the given coordinates.
        void put_char( uint y, uint x, char letter,
                       Colors color = Colors.Default )
        {
            // Tell the renderer to draw to our own `frame_buffer' rather than
            // the screen so we have better control over the contents of the
            // backbuffer
            SDL_SetRenderTarget( renderer, frame_buffer );

            // The following code was cannibalized from Elronnd's SmugglerRL
            // project:

            SDL_Texture* renderedchar;

            Color_Pair color_pair = Clr[color];

            // null means there's no glyph, so fall back on a backup character
            if( cur_tileset[letter] is null )
            {
                renderedchar = cur_tileset['?'];
                color_pair = Clr[Colors.Error];
            }
            else
            {
                renderedchar = cur_tileset[letter];
            }

            // Draw a square with the background color (this will erase any
            // character that was there before), then draw the character on
            // top of it with transparency so we see the background
            SDL_Rect tile;

            tile.y = y * tile_height;
            tile.x = x * tile_width;
            tile.w = tile_width;
            tile.h = tile_height;

            // The color of the foreground and background, respectively.  Swap
            // these if the color is inverted.
            SDL_Color foreground, background;
            if( !color_pair.get_inverted() )
            {
                foreground = color_pair.get_foreground().get_sdl_color();
                background = color_pair.get_background().get_sdl_color();
            }
            else
            {
                background = color_pair.get_foreground().get_sdl_color();
                foreground = color_pair.get_background().get_sdl_color();
            }

            // Fill in the background first:
            SDL_SetRenderDrawColor( renderer, background.r, background.g,
                                    background.b, 255 );

            // Draw the rectangle:
            SDL_RenderFillRect( renderer, &tile );

            // Colorize the letter.  The parts that aren't the letter will
            // also get colorized, but that doesn't matter because they have
            // alpha 256
            SDL_SetTextureColorMod( renderedchar, foreground.r, foreground.g,
                                    foreground.b );

            // And finally, copy everything over to the actual renderer
            SDL_RenderCopy( renderer, renderedchar, null, &tile );

            // (end cannibalized code)
        } // void put_char( uint, uint, char, Colors? )

        // The central `display` function.  Displays a given `symbol` at given
        // coordinates.  The `center` parameter has no effect in SDL.
        void display( uint y, uint x, Symbol sym, bool center = true )
        {
            put_char( y, x, sym.ascii, sym.color );
        }

        // The Message Line //////////////////////////////////////////////////

        // Cover the message line with a black rectangle.
        void clear_message_line()
        {
            SDL_Rect rect;
            rect.y = rect.x = 0;
            rect.w = tile_width * MAP_X;
            rect.h = tile_height;

            SDL_SetRenderTarget( renderer, frame_buffer );

            SDL_SetRenderDrawColor( renderer, 0, 0, 0, 255 );

            SDL_RenderFillRect( renderer, &rect );
        }

        // Reads the player all of their messages one at a time
        void read_messages()
        {
            // Because we're writing to the message line, set the current
            // tileset to the special `message_font`:
            cur_tileset = message_font;

            while( !Messages.empty() )
            {
                clear_message_line();
                put_line( 0, 0, "%s%s", pop_message(),
                        Messages.empty() == false ? "  (More)" : "" );
                refresh_screen();

                if( !Messages.empty() )
                {
                    get_key();
                }
            }

            // We're done displaying messages, so set the current tileset back
            // to the default `tileset`:
            cur_tileset = tileset;
        }

        // Gives the player a menu containing their message history.
        void read_message_history()
        {
            clear_screen();

            // Because we're outputting a message, set the current tileset to
            // the special `message_font`:
            cur_tileset = message_font;

            uint line = 0;
            foreach( count; 0 .. Message_history.length )
            {
                if( line > 23 )
                {
                    refresh_screen();
                    get_key();
                    clear_screen();
                    line = 0;
                }

                put_line( line, 0, Message_history[count] );

                line++;
            }

            refresh_screen();
            get_key();
            clear_message_line();

            // We're done displaying messages, so set the current tileset back
            // to the default `tileset`:
            cur_tileset = tileset;
        } // read_message_history()

        // The Status Bar ////////////////////////////////////////////////////

        // Refreshes the status bar
        void refresh_status_bar( Player* plyr )
        {
            int hit_points = plyr.hit_points;
            int dice = plyr.attack_roll.dice
                       + plyr.inventory.items[INVENT_WEAPON].add_dice;
            int mod = plyr.attack_roll.modifier
                      + plyr.inventory.items[INVENT_WEAPON].add_mod;

            // Because the status bar is considered a "message," switch the
            // current tileset to the special `message_font`:
            cur_tileset = message_font;

            foreach( x; 0 .. MAP_X )
            {
                put_char( 1 + MAP_Y, x, ' ' );
            }

            put_line( 1 + MAP_Y, 0, "HP: %d    Attack: %ud %c %u",
                      hit_points, dice,
                      mod >= 0 ? '+' : '-', mod * ((-1) * mod < 0) );

            // We're done displaying messages, so set the current tileset back
            // to the default `tileset`:
            cur_tileset = tileset;
        } // void refresh_status_bar( Player* )
    } // class SDL_Terminal_IO
} // version( sdl )
