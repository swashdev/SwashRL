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

// iocurses.d: defines the interface for functions related to program output
// for the curses interface.

version( curses )
{

    import global;

    import std.string : toStringz;
    import std.ascii : toLower;
    import std.string : format;

    // This class contains functions for the curses display.  See iomain.d for
    // the Swash_IO interface.
    class Curses_IO : Swash_IO
    {

// SECTION 1: ////////////////////////////////////////////////////////////////
// Setup & Cleanup                                                          //
//////////////////////////////////////////////////////////////////////////////

        // This constructor will initialize the curses window.
        this( ubyte screen_size_vertical = 24,
              ubyte screen_size_horizontal = 80 )
        {
            // Initializing curses
            initscr();
    
            // pass raw input directly to curses
            raw();
    
            // do not echo user input
            noecho();
    
            // enable the keypad and function keys

            keypad( stdscr, 1 );

            // enable color:
            static if( COLOR )
            {
                start_color();
            }
        }

        // Close the curses window.
        void cleanup()
        {
            endwin();
        }

        // This function has no practical purpose and is only required because
        // the Swash_IO interface must define it for SDL compatibility.
        bool window_closed()
        {
            return false;
        }

// SECTION 2: ////////////////////////////////////////////////////////////////
// Curses Utility Functions                                                 //
//////////////////////////////////////////////////////////////////////////////

        // Takes in a color flag and returns a curses-style `attr_t`
        // representing that color.
        attr_t get_color( Colors color = Colors.Default )
        {
            return COLOR_PAIR( Clr[color].get_color_pair() );
        }

// SECTION 3: ////////////////////////////////////////////////////////////////
// Input                                                                    //
//////////////////////////////////////////////////////////////////////////////

        // Gets a character input from the user and returns it.
        char get_key()
        {
            return cast(char)getch();
        }

        // Outputs a question to the user and returns a `char` result based on
        // their answer.
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

            put_line( 0, 0, output );
            refresh_screen();

            char answer = '\0';

            while( true )
            {
                answer = get_key();

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
            }
        } // char ask( string, char[]?, bool? )

// SECTION 4: ////////////////////////////////////////////////////////////////
// Output                                                                   //
//////////////////////////////////////////////////////////////////////////////

        // General Output ////////////////////////////////////////////////////

        // Clears the screen.
        void clear_screen()
        {
            clear();
        }

        // Refreshes the screen to reflect the changes made by the below
        // `display` functions.
        void refresh_screen()
        {
            refresh();
        }

        // Outputs a text character at the given coordinates.
        void put_char( uint y, uint x, char c, Colors color = Colors.Default )
        {
            Color_Pair color_pair = Clr[color];
    
            static if( TEXT_EFFECTS )
            {
                if( color_pair.get_bright() )
                {
                    attron( A_BOLD );
                }
                else
                {
                    attroff( A_BOLD );
                }

                if( color_pair.get_inverted() )
                {
                    attron( A_REVERSE );
                }
                else
                {
                    attroff( A_REVERSE );
                }
            }

            static if( COLOR )
            {
                attron( COLOR_PAIR( color_pair.get_color_pair() ) );
            }

            mvaddch( y, x, c );

            static if( COLOR )
            {
                attroff( COLOR_PAIR( color_pair.get_color_pair() ) );
            }
        } // void put_char( uint, uint, char, Colors? )

        // The central display function.  If `center` is true, the cursor will
        // be moved over the place where the symbol was output.
        void display( uint y, uint x, Symbol sym, bool center = false )
        {
            put_char( y, x, sym.ascii, sym.color );

            if( center )
            {
                move( y, x );
            }
        }

        // Prints a string at the given coordinates.
        void put_line( T... )( uint y, uint x, T args )
        {
            string output = format( args );
            mvprintw( y, x, toStringz( output ) );
        }

        // The Message Line //////////////////////////////////////////////////

        // Clears the current message off the message line.
        void clear_message_line()
        {
            foreach( y; 0 .. MESSAGE_BUFFER_LINES )
            {
                foreach( x; 0 .. MAP_X )
                {
                    put_char( y, x, ' ' );
                }
            }
        }

        // Outputs all of the messages in the message queue.
        void read_messages()
        {
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
        }

        // Gives the player a menu containing their message history.
        void read_message_history()
        {
            clear_screen();

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
        } // void read_message_history()

        // The Status Bar ////////////////////////////////////////////////////

        // Refreshes the status bar.
        void refresh_status_bar( Player* plyr )
        {
            // Clear the status bar by covering it with space characters.
            foreach( x; 0 .. MAP_X )
            {
                put_char( 1 + MAP_Y, x, ' ' );
            }
    
            write_status_bar( plyr );
        }
    } // class Curses_IO
} // version( curses )
