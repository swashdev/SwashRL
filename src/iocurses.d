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

  void cleanup()
  {
    getch();
    endwin();
  }

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
