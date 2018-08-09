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
    init_pair( CURSES_BLACK      , COLOR_BLACK           , black );
    init_pair( CURSES_RED        , COLOR_RED             , black );
    init_pair( CURSES_GREEN      , COLOR_GREEN           , black );
    init_pair( CURSES_BROWN      , COLOR_YELLOW          , black );
    init_pair( CURSES_MAGENTA    , COLOR_MAGENTA         , black );
    init_pair( CURSES_CYAN       , COLOR_CYAN            , black );
    init_pair( CURSES_GRAY       , COLOR_WHITE           , black );
    init_pair( CURSES_DARKGRAY   , COLOR_BLACK   | A_BOLD, black );
    init_pair( CURSES_LITERED    , COLOR_RED     | A_BOLD, black );
    init_pair( CURSES_LITEGREEN  , COLOR_GREEN   | A_BOLD, black );
    init_pair( CURSES_YELLOW     , COLOR_YELLOW  | A_BOLD, black );
    init_pair( CURSES_LITEBLUE   , COLOR_BLUE    | A_BOLD, black );
    init_pair( CURSES_LITEMAGENTA, COLOR_MAGENTA | A_BOLD, black );
    init_pair( CURSES_LITECYAN   , COLOR_CYAN    | A_BOLD, black );
    init_pair( CURSES_WHITE      , COLOR_WHITE   | A_BOLD, black );
}
  }

  /////////////////////
  // Setup & Cleanup //
  /////////////////////

  void cleanup()
  { endwin();
  }

  ///////////
  // Input //
  ///////////

  // Gets a character input from the user and returns it
  char get_key()
  { return cast(char)getch();
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
        return COLOR_PAIR( COLOR_BROWN );

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
        return COLOR_PAIR( CURSES_DARKGRAY );

      case CLR_LITERED:
        return COLOR_PAIR( CURSES_LITERED );

      case CLR_LITEGREEN:
        return COLOR_PAIR( CURSES_LITEGREEN );

      case CLR_YELLOW:
        return COLOR_PAIR( CURSES_YELLOW );

      case CLR_LITEBLUE:
        return COLOR_PAIR( CURSES_LITEBLUE );

      case CLR_LITEMAGENTA:
        return COLOR_PAIR( CURSES_LITEMAGENTA );

      case CLR_LITECYAN:
        return COLOR_PAIR( CURSES_LITECYAN );

      case CLR_WHITE:
        return COLOR_PAIR( CURSES_WHITE );

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
      { display( y, x, symdata( ' ', A_NORMAL ) );
      }
    }
  }

  void display( uint y, uint x, symbol s, bool center = false )
  {
    put_char( y, x, s.ch,
              COLOR ? s.color : Color( CLR_DEFAULT, s.color.reverse ) );

    if( center )
    { move( y, x );
    }
  }

} // class CursesIO

} // version( curses )
