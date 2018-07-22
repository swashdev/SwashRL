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

// This class contains functions for the curses display
// These functions should all be cross-compatible between pdcurses and ncurses
// since they don't do anything fancy or complicated.
class CursesIO : SpelunkIO
{

  ushort display_x = 80;
  ushort display_y = 24;

  //////////////////
  // Constructors //
  //////////////////

  this()
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
  this( uint screen_size_vertical, uint screen_size_horizontal )
  {
    display_x = screen_size_horizontal;
    display_y = screen_size_vertical;
    super();
  }

  /////////////////////
  // Setup & Cleanup //
  /////////////////////

  void cleanup()
  {
    getch();
    endwin();
  }

  ///////////
  // Input //
  ///////////

  int getcommand( bool alt_hjkl )
  {
    char c = cast(char)getch();
    switch( c )
    {
      case 'y':
      case '7':
      case KEY_HOME:
        return MOVE_NW;

      case 'k':
      case '8':
      case KEY_UP:
        return MOVE_NN;
      case 'u':
      case '9':
      case KEY_PPAGE: // pgup
        return MOVE_NE;
      case 'l':
      case '6':
      case KEY_RIGHT:
        return MOVE_EE;
      case 'n':
      case '3':
      case KEY_NPAGE: // pgdn
        return MOVE_SE;
      case 'j':
      case '2':
      case KEY_DOWN: // numpad "down"
        return MOVE_SS;
      case 'b':
      case '1':
      case KEY_END:
        return MOVE_SW;
      case 'h':
      case '4':
      case KEY_LEFT:
        return MOVE_WW;
      case MV_WT:
      case NP_WT:
        return MOVE_WAIT;

version( Windows )
{
    // numpad controls (Windows-specific)
      case KEY_A1:
        return MOVE_NW;
      case KEY_A2:
        return MOVE_NN;
      case KEY_A3:
        return MOVE_NE;
      case KEY_B1:
        return MOVE_WW;
      case KEY_B2:
        return MOVE_WAIT;
      case KEY_B3:
        return MOVE_EE;
      case KEY_C1:
        return MOVE_SW;
      case KEY_C2:
        return MOVE_SS;
      case KEY_C3:
        return MOVE_SE;
} /* version( Windows ) */

      case 'i':
        return MOVE_INVENTORY;

      case KY_GET:
        return MOVE_GET;

      case KY_MESS:
        return MOVE_MESS_DISPLAY;
      case KY_CLEAR:
        return MOVE_MESS_CLEAR;

      case KY_QUIT:
        return MOVE_QUIT;

      case 'v':
      case KY_VERSION:
        return MOVE_GETVERSION;

      default:
      case KY_HELP:
        return MOVE_HELP;
    }
  } /* int getcommand */

  void display( uint y, uint x, symbol s, bool center = false )
  {
    mvaddch( y, x, s.ch );

static if( TEXT_EFFECTS )
{
    mvchgat( y, x, 1, s.color, cast(short)0, cast(void*)null );
}

    if( !center )
    { move( y, x + 1 );
    }
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

  void refresh_status_bar( player* u )
  {
    int hp = u.hp;
    int dice = u.attack_roll.dice + u.inventory.items[INVENT_WEAPON].addd;
    int mod = u.attack_roll.modifier + u.inventory.items[INVENT_WEAPON].addm;

    foreach( x; 0 .. MAP_X )
    { mvaddch( 1 + MAP_Y, x, ' ', 0 );
    }
    mvprintw( 1 + MAP_Y, 0, "HP: %d    Attack: %ud %c %u",
              hp, dice, mod >= 0 ? '+' : '-', mod * ((-1) * mod < 0) );
  }

} /* class CursesDisplay */

} /* version( curses ) */
