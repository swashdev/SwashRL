/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */

import global;

#include <time.h>
#include <stdlib.h>
#include <stdio.h>

static map Current_map;

void help( bool alt_hjkl )
{
  clear_message_line();
  mvprintw( 0, 0, "hjkl" );
  if( alt_hjkl )
  { printw( "uinm" );
  }
  else
  { printw( "yubn" );
  }
  printw( " or number pad to move.  Q to quit." );
  getch();
  clear_message_line();
}

void version()
{
  clear_message_line();
  mvprintw( 0, 0, "%s, version %.3f",
            "Spelunk!", VERSION );
  getch();
  clear_message_line();
}

int main()
{
  seed();

  initscr();
  // Control characters are passed directly to the program
  raw(); 
  // Do not echo user input
  noecho();
  // Enable keypad & other function keys
  keypad(stdscr, 1);

  Current_map = test_map();

  player u = init_player( 1, 1 );

  static if( USE_FOV )
  { calc_visible( &Current_map, u.x, u.y );
  }

  Buffered_messages = MAX_MESSAGE_BUFFER;
  clear_messages();

  refresh_status_bar( &u );

  display_map_and_player( Current_map, u );

  bool alt_hjkl = false;

  uint moved = 0;
  ubyte mv = 5;
  while( mv != MOVE_QUIT && u.hp > 0 )
  {
    moved = 0;
    mv = getcommand( alt_hjkl );
    switch( mv )
    {
      // display help
      case MOVE_HELP:
         help( alt_hjkl );
         break;
      // quit
      case MOVE_QUIT:
        goto playerquit;
        break; 
      // display version information
      case MOVE_GETVERSION:
        version();
        break;
      case MOVE_ALTKEYS:
        alt_hjkl = !alt_hjkl;
        mvprintw( 0, 0, "Alternate movement keys %sabled",
                  alt_hjkl ? "en" : "dis" );
        buffer_message();
        break;
      // print the message buffer
      case MOVE_MESS_DISPLAY:
        message_history();
        clear_message_line();
        refresh_status_bar( &u );
        display_map_and_player( Current_map, u );
        break;
      // clear the message line
      case MOVE_MESS_CLEAR:
        clear_message_line();
        break;
      // wait
      case MOVE_WAIT:
        message( "You bide your time." );
        moved = 1;
        break;
      // inventory management
      case MOVE_INVENTORY:
        moved = uinventory( &u );
        // we must redraw the screen after the inventory window is cleared
        display_map_and_player( Current_map, u );
        break;
      // all other commands go to umove
      default:
        clear_message_line();
        moved = umove( &u, &Current_map, mv );
        if( u.hp <= 0 )
          goto playerdied;
        display_player( u );
        break;
    }
    if( moved )
    {
      while( moved )
      {
        map_move_all_monsters( &Current_map, &u );
        moved--;
      }
      static if( USE_FOV )
      { calc_visible( &Current_map, u.x, u.y );
      }
      refresh_status_bar( &u );
      display_map_and_player( Current_map, u );
    }
    if( Buffered_messages > 0 )
    { read_messages();
    }
    if( u.hp > 0 )
    { move( u.y + RESERVED_LINES, u.x );
    }
    else
    { break;
    }
    refresh();
  }

playerdied:

  mvaddch( u.y + RESERVED_LINES, u.x, SMILEY );
  static if( TEXT_EFFECTS )
  { mvchgat( u.y + RESERVED_LINES, u.x, 1, A_DIM, 0, NULL );
  }

playerquit:

  message( "See you later..." );
  // view all the messages that you got just before you died
  read_messages();

  getch();
  endwin();
  return SP_NO_ERRORS;

panic_memory_allocation_error:
  return SP_MEMORY_ALLOCATION_ERROR;
panic_user_error:
  return SP_USER_ERROR;
panic_error_unknown:
  return SP_UNKNOWN_ERROR;
}

void panic( byte error )
{
  endwin();
  switch( error )
  {
    case SP_UNKNOWN_ERROR:
      printf( "\aPANIC: %d (Unknown error!)", error );
      break;
    case SP_MEMORY_ALLOCATION_ERROR:
      printf( "\aPANIC %d (Memory allocation error)", error );
      break;
    case SP_TERMINATED_EARLY_NO_ERROR:
    case SP_NO_ERRORS:
      printf( "\aPANIC %d (No errors--why was panic called?)", error );
      break;
    case SP_USER_ERROR:
      printf( "\aPANIC %d (PEBCAK error)", error );
      break;
  }
  exit( error );
}
