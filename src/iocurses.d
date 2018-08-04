/*
 * Copyright (c) 2016-2018 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
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
class CursesIO : SpelunkIO
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

  void put_char( uint y, uint x, char c, bool reversed = false )
  {
static if( TEXT_EFFECTS )
{
    if( reversed )
    { attron( A_REVERSE );
    }
    else
    { attroff( A_REVERSE );
    }
}
    mvaddch( y, x, c );
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
static if( !TEXT_EFFECTS )
{
    put_char( y, x, s.ch );
}
else
{
    put_char( y, x, s.ch, s.color & A_REVERSE );
}

    if( !center )
    { move( y, x + 1 );
    }
  }

} // class CursesIO

} // version( curses )
