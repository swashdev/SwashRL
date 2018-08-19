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
// curses interface.

version( curses )
{

import global;

import std.string: toStringz;
import std.ascii : toLower;

// This class contains functions for the curses display
// These functions should all be cross-compatible between pdcurses and ncurses
// since they don't do anything fancy or complicated.
class CursesIO : SwashIO
{

  //////////////////
  // Constructors //
  //////////////////

  this( ushort screen_size_vertical = 24, ushort screen_size_horizontal = 80 )
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

    short black = COLOR_BLACK;

    // Initialize color pairs:
    init_pair( cast(short)CURSES_BLACK  , cast(short)COLOR_BLACK  , black );
    init_pair( cast(short)CURSES_RED    , cast(short)COLOR_RED    , black );
    init_pair( cast(short)CURSES_GREEN  , cast(short)COLOR_GREEN  , black );
    init_pair( cast(short)CURSES_BROWN  , cast(short)COLOR_YELLOW , black );
    init_pair( cast(short)CURSES_BLUE   , cast(short)COLOR_BLUE   , black );
    init_pair( cast(short)CURSES_MAGENTA, cast(short)COLOR_MAGENTA, black );
    init_pair( cast(short)CURSES_CYAN   , cast(short)COLOR_CYAN   , black );
    init_pair( cast(short)CURSES_GRAY   , cast(short)COLOR_WHITE  , black );
}
  }

  /////////////////////
  // Setup & Cleanup //
  /////////////////////

  void cleanup()
  { endwin();
  }

  bool window_closed()
  { return false;
  }

  ///////////
  // Input //
  ///////////

  // Gets a character input from the user and returns it
  char get_key()
  { return cast(char)getch();
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
  attr_t get_color( ubyte color )
  {
    switch( color )
    {
      case CLR_BLACK:
        return COLOR_PAIR( CURSES_BLACK );

      case CLR_RED:
        return COLOR_PAIR( CURSES_RED );

      case CLR_GREEN:
        return COLOR_PAIR( CURSES_GREEN );

      case CLR_BROWN:
        return COLOR_PAIR( CURSES_BROWN );

      case CLR_BLUE:
        // We don't use dark blue because it blends in with the black
        // background too much.
        goto case CLR_LITEBLUE;

      case CLR_MAGENTA:
        return COLOR_PAIR( CURSES_MAGENTA );

      case CLR_CYAN:
        return COLOR_PAIR( CURSES_CYAN );

      case CLR_GRAY:
        return COLOR_PAIR( CURSES_GRAY );

      case CLR_DARKGRAY:
        return COLOR_PAIR( CURSES_BLACK ) | A_BOLD;

      case CLR_LITERED:
        return COLOR_PAIR( CURSES_RED ) | A_BOLD;

      case CLR_LITEGREEN:
        return COLOR_PAIR( CURSES_GREEN ) | A_BOLD;

      case CLR_YELLOW:
        return COLOR_PAIR( CURSES_BROWN ) | A_BOLD;

      case CLR_LITEBLUE:
        return COLOR_PAIR( CURSES_BLUE ) | A_BOLD;

      case CLR_LITEMAGENTA:
        return COLOR_PAIR( CURSES_MAGENTA ) | A_BOLD;

      case CLR_LITECYAN:
        return COLOR_PAIR( CURSES_CYAN ) | A_BOLD;

      case CLR_WHITE:
        return COLOR_PAIR( CURSES_GRAY ) | A_BOLD;

      // If we don't get a valid color, default to the "standard color"
      default:
        goto case CLR_GRAY;
    } // switch( color )
  } // attr_t get_color( ubyte color )

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

  void put_line( T... )( uint y, uint x, T args )
  {
    import std.string : toStringz;
    string output = format( args );
    mvprintw( y, x, toStringz( output ) );
  }

  // Reads the player all of their messages one at a time
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

  // Gives the player a menu containing their message history.
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

  // Refreshes the status bar
  void refresh_status_bar( player* u )
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


  void refresh_screen()
  { refresh();
  }

  void clear_screen()
  { clear();
  }

  void clear_message_line()
  {
    foreach( y; 0 .. MESSAGE_BUFFER_LINES )
    {
      foreach( x; 0 .. MAP_X )
      { put_char( y, x, ' ' );
      }
    }
  }

  void display( uint y, uint x, symbol s, bool center = false )
  {
    put_char( y, x, s.ch,
              COLOR ? s.color : Color( CLR_GRAY, s.color.reverse ) );

    if( center )
    { move( y, x );
    }
  }

} // class CursesIO

} // version( curses )
