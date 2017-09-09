/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */

import global;

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

void sp_version()
{
  import std.string: toStringz;

  clear_message_line();
  mvprintw( 0, 0, "%s, version %.3f",
            toStringz("Spelunk!"), VERSION );
  getch();
  clear_message_line();
}

int main()
{
  import std.string: toStringz;

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
  int mv = 5;
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
      // display version information
      case MOVE_GETVERSION:
        sp_version();
        break;
      case MOVE_ALTKEYS:
        alt_hjkl = !alt_hjkl;
        mvprintw( 0, 0, "Alternate movement keys %sabled",
                  toStringz(alt_hjkl ? "en" : "dis") );
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
        moved = umove( &u, &Current_map, cast(ubyte)mv );
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
  { mvchgat( u.y + RESERVED_LINES, u.x, 1, A_DIM, cast(short)0, cast(void*)null );
  }

playerquit:

  message( "See you later..." );
  // view all the messages that you got just before you died
  read_messages();

  getch();
  endwin();
  return 0;
}
