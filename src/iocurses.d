/*
 * Copyright 2016-2019 Philip Pavlick
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License.  You may obtain a copy
 * of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * SwashRL is distributed with a special exception to the normal Apache
 * License 2.0.  See LICENSE for details.
 */

// Defines the interface for functions related to program output for the
// curses interface.

version( curses )
{

import global;

import std.string : toStringz;
import std.ascii : toLower;
import std.string : format;

/++
 + This class contains functions for the curses display
 +
 + These functions should all be cross-compatible between pdcurses and ncurses
 + since they don't do anything fancy or complicated.
 +
 + See_Also:
 +   <a href="iomain.html">SwashIO</a>
 +/
class CursesIO : SwashIO
{

  //////////////////
  // Constructors //
  //////////////////

  /++
   + The constructor for the CursesIO class
   +
   + The parameters don't actually do anything, but are placeholder values to
   + make the SwashIO() constructor work with both CursesIO and SDLTerminalIO.
   +
   + If `COLOR` is turned on, curses color pairs will be defined here.
   +/
  this( ubyte screen_size_vertical = 24, ubyte screen_size_horizontal = 80 )
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

    short black = CURSES_BLACK;

    // Initialize color pairs:
    init_pair( 1, CURSES_BLACK  , black );
    init_pair( 2, CURSES_RED    , black );
    init_pair( 3, CURSES_GREEN  , black );
    init_pair( 4, CURSES_BROWN  , black );
    init_pair( 5, CURSES_BLUE   , black );
    init_pair( 6, CURSES_MAGENTA, black );
    init_pair( 7, CURSES_CYAN   , black );
    init_pair( 8, CURSES_GRAY   , black );
}
  }

  /////////////////////
  // Setup & Cleanup //
  /////////////////////

  /++
   + Performs final cleanup functions for the input/output module, to close
   + the display before exiting the program.
   +
   + See_Also:
   +   <a href="iomain.html#SwashIO.cleanup">SwashIO.cleanup</a>
   +/
  void cleanup()
  { endwin();
  }

  /++
   + Used to determine if the "close window" button has been pressed.
   +
   + This function has no purpose for the curses interface because the curses
   + interface is run from the terminal.  This function only exists because
   + it's necessary for the `SwashIO` class to contain it in order for the
   + `SDLTerminalIO` class to use it in the mainloop.
   +
   + See_Also:
   +   <a href="iomain.html#SwashIO.window_closed">SwashIO.window_closed</a>
   +
   + Returns:
   +   `false`
   +/
  bool window_closed()
  { return false;
  }

  ///////////
  // Input //
  ///////////

  /++
   + Gets a character input from the user and returns it
   +
   + See_Also:
   +   <a href="iomain.html#SwashIO.get_key">SwashIO.get_key</a>
   +/
  char get_key()
  { return cast(char)getch();
  }

  /++
   + Outputs a question to the user and returns a `char` result.
   +
   + See_Also:
   +   <a href="iomain.html#SwashIO.ask">SwashIO.ask</a>
   +/
  char ask( string question, char[] options = ['y', 'n'],
            bool assume_lower = false )
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

    put_line( 0, 0, q );
    refresh_screen();

    char answer = '\0';

    while( true )
    {
      answer = get_key();

      if( assume_lower ) answer = toLower( answer );

      foreach( c; 0 .. options.length )
      { if( answer == options[c] ) return answer;
      }
    }
  }

  ////////////
  // Output //
  ////////////

  // Takes in a `color' and returns a curses-style `attr_t' representing that
  // color
  /++
   + Takes in a color value and returns a curses-style `attr_t`
   +
   + This function converts the color flags defined in color.d to a
   + `COLOR_PAIR` that curses can use.
   +
   + See_Also:
   +   <a href="ioterm.html#SDLTerminalIO.to_SDL_Color">SDLTerminalIO.to_SDL_Color</a>
   +
   + Params:
   +   color = The color to be converted
   +
   + Returns:
   +   An `attr_t` which can be used to activate colors in the curses
   +   interface
   +/
  attr_t get_color( uint color )
  {
    switch( color )
    {
      case CLR_BLACK:
        return COLOR_PAIR( 1 );

      case CLR_RED:
        return COLOR_PAIR( 2 );

      case CLR_GREEN:
        return COLOR_PAIR( 3 );

      case CLR_BROWN:
        return COLOR_PAIR( 4 );

      case CLR_BLUE:
        // We don't use dark blue because it blends in with the black
        // background too much.
        goto case CLR_LITEBLUE;

      case CLR_MAGENTA:
        return COLOR_PAIR( 6 );

      case CLR_CYAN:
        return COLOR_PAIR( 7 );

      case CLR_GRAY:
        return COLOR_PAIR( 8 );

      case CLR_DARKGRAY:
        return COLOR_PAIR( 1 ) | A_BOLD;

      case CLR_LITERED:
        return COLOR_PAIR( 2 ) | A_BOLD;

      case CLR_LITEGREEN:
        return COLOR_PAIR( 3 ) | A_BOLD;

      case CLR_YELLOW:
        return COLOR_PAIR( 4 ) | A_BOLD;

      case CLR_LITEBLUE:
        return COLOR_PAIR( 5 ) | A_BOLD;

      case CLR_LITEMAGENTA:
        return COLOR_PAIR( 6 ) | A_BOLD;

      case CLR_LITECYAN:
        return COLOR_PAIR( 7 ) | A_BOLD;

      case CLR_WHITE:
        return COLOR_PAIR( 8 ) | A_BOLD;

      // If we don't get a valid color, default to the "standard color"
      default:
        goto case CLR_GRAY;
    } // switch( color )
  } // attr_t get_color( ubyte color )

  /++
   + Outputs a text character at the given coordinates with a certain color
   +
   + See_Also:
   +   <a href="iomain.html#SwashIO.put_char">SwashIO.put_char</a>
   +/
  void put_char( uint y, uint x, char c,
                 Color color = Color( CLR_NONE, false ) )
  {
static if( TEXT_EFFECTS )
{
    if( color.reverse )
    { attron( A_REVERSE );
    }
    else
    { attroff( A_REVERSE );
    }
}
static if( COLOR )
{
    if( color.fg != CLR_NONE )
    { attron( get_color( color.fg ) );
    }
}
    mvaddch( y, x, c );
static if( COLOR )
{
    if( color.fg != CLR_NONE )
    { attroff( get_color( color.fg ) );
    }
}
  }

  /++
   + Prints a `string` at the given coordinates
   +
   + See_Also:
   +   <a href="iomain.html#SwashIO.put_line">SwashIO.put_line</a>
   +/
  void put_line( T... )( uint y, uint x, T args )
  {
    import std.string : toStringz;
    string output = format( args );
    mvprintw( y, x, toStringz( output ) );
  }

  /++
   + Reads the player all of their messages one at a time
   +
   + See_Also:
   +   <a href="iomain.html#SwashIO.read_messages">SwashIO.read_messages</a>
   +/
  void read_messages()
  {
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
  }

  // 
  /++
   + Gives the player a menu containing their message history.
   +
   + See_Also:
   +   <a href="iomain.html#SwashIO.read_message_history">SwashIO.read_message_history</a>
   +/
  void read_message_history()
  {
    clear_screen();

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
  }

  /++
   + Refreshes the status bar
   +
   + See_Also:
   +   <a href="iomain.html#SwashIO.refresh_status_bar">SwashIO.refresh_status_bar</a>
   +/
  void refresh_status_bar( Player* u )
  {
    int hp = u.hp;
    int dice = u.attack_roll.dice + u.inventory.items[INVENT_WEAPON].addd;
    int mod = u.attack_roll.modifier + u.inventory.items[INVENT_WEAPON].addm;

    foreach( x; 0 .. MAP_X )
    { put_char( 1 + MAP_Y, x, ' ' );
    }
    put_line( 1 + MAP_Y, 0, "HP: %d    Attack: %ud %c %u",
              hp, dice, mod >= 0 ? '+' : '-', mod * ((-1) * mod < 0) );
  }

  /++
   + Refreshes the screen to reflect the changes made by the below `display`
   + functions
   +
   + See_Also:
   +   <a href="iomain.html#SwashIO.refresh_screen">SwashIO.refresh_screen</a>
   +/
  void refresh_screen()
  { refresh();
  }

  /++
   + Clears the screen
   +
   + See_Also:
   +   <a href="iomain.html#SwashIO.clear_screen">SwashIO.clear_screen</a>
   +/
  void clear_screen()
  { clear();
  }

  /++
   + Clears the current message off the message line
   +
   + See_Also:
   +   <a href="iomain.html#SwashIO.clear_message_line">SwashIO.clear_message_line</a>
   +/
  void clear_message_line()
  {
    foreach( y; 0 .. MESSAGE_BUFFER_LINES )
    {
      foreach( x; 0 .. MAP_X )
      { put_char( y, x, ' ' );
      }
    }
  }

  /++
   + The central display function
   +
   + See_Also:
   +   <a href="iomain.html#SwashIO.display">SwashIO.display</a>
   +/
  void display( uint y, uint x, Symbol s, bool center = false )
  {
    put_char( y, x, s.ch,
              COLOR ? s.color : Color( CLR_GRAY, s.color.reverse ) );

    if( center )
    { move( y, x );
    }
  }

} // class CursesIO

} // version( curses )
