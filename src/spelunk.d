/*
 * Copyright (c) 2016-2018 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */

import global;
import std.string: toStringz;

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

// `SDL_Mode' is a static variable used by the display functions to determine
// whether SDL or curses is being used.  `SDL_MODES' is an enum that stores
// the possible values of `SDL_Mode'.
// Depending on how your compile is configured, the default will be either
// `SDL_MODES.terminal' or `SDL_MODES.none' but can be set in the command
// line.  If the command line input conflicts with your compile, `SDL_Mode'
// will be reset in `main'.
enum SDL_MODES { none, terminal, full };
static SDL_MODES SDL_Mode = GFX_NONE ? SDL_MODES.none : SDL_MODES.terminal;

bool SDL_none()
{ return SDL_Mode == SDL_MODES.none;
}
bool SDL_terminal()
{ return SDL_Mode == SDL_MODES.terminal;
}
bool SDL_full()
{ return SDL_terminal()
}

// Exit codes for `main':
//   0 Exit without error
//   1 Exit due to --help prompt, no errors
// 100 Catch-all error code

int main( string[] args )
{
  import std.getopt;
  import std.stdio: writeln;

  // use getopt to get command-line arguments
  auto clarguments = getopt( args,
    // the display mode, either an SDL "terminal" or "none" for curses ("full"
    // is the same as "terminal" until a full graphics version of the game is
    // finished)
    "sdl-mode", &SDL_Mode,
    "S",        &SDL_Mode
  );

  if( clarguments.helpWanted )
  {
    writeln( "Usage: spelunk [options]\n
  options:\n
    -h, --help        Displays this help output and then exits.
    -S, --sdl-mode    Sets the output mode for Spelunk!  Default \"terminal\"\n
                      Can be \"none\" for curses output or \"terminal\" or
                      \"full\" for an SDL terminal.  If your copy of Spelunk!\n
                      was compiled without SDL or curses, this option may
                      have no effect.
  examples:\n
    spelunk --sdl-mode none
    spelunk --sdl-mode terminal"
    );
    return 1;
  }

  // Check to make sure the SDL_Mode does not conflict with the way Spelunk!
  // was compiled:
  if( !SPELUNK_CURSES && SDL_Mode == SDL_MODES.none )
  { SDL_Mode = SDL_MODES.terminal;
  }
  if( GFX_NONE && SDL_Mode != SDL_MODES.none )
  { SDL_Mode = SDL_MODES.none;
  }

  seed();

  Display mainout;

static if( SPELUNK_CURSES )
{
  if( SDL_none() )
  {
    mainout = new CursesDisplay();
    mainout.setup();

    // Control characters are passed directly to the program
    raw();
    // Enable keypad & other function keys
    keypad( stdscr, 1 );
  }
}

  Current_map = test_map();

  player u = init_player( 1, 1 );

  static if( USE_FOV )
  { calc_visible( &Current_map, u.x, u.y );
  }

  Buffered_messages = MAX_MESSAGE_BUFFER;
  clear_messages();

  mainout.refresh_status_bar( &u );

  mainout.display_map_and_player( Current_map, u );

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
        message( "Alternate movement keys %sabled",
                 toStringz( alt_hjkl ? "en" : "dis" ) );
        break;
      // print the message buffer
      case MOVE_MESS_DISPLAY:
        message_history();
        mainout.clear_message_line();
        mainout.refresh_status_bar( &u );
        mainout.display_map_all( Current_map );
        break;
      // clear the message line
      case MOVE_MESS_CLEAR:
        mainout.clear_message_line();
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
        mainout.display_map_all( Current_map );
        break;
      // all other commands go to umove
      default:
        mainout.clear_message_line();
        mainout.display( u.y, u.x, Current_map.t[u.y][u.x].sym );
        moved = umove( &u, &Current_map, cast(ubyte)mv );
        if( u.hp <= 0 )
        { goto playerdied;
        }
        break;
    }
    if( moved > 0 )
    {
      while( moved > 0 )
      {
        map_move_all_monsters( &Current_map, &u );
        moved--;
      }
      static if( USE_FOV )
      { calc_visible( &Current_map, u.x, u.y );
      }
      mainout.refresh_status_bar( &u );
      mainout.display_map_and_player( Current_map, u );
    }
    if( Buffered_messages > 0 )
    { read_messages();
    }
    if( u.hp > 0 )
    { mainout.display_player( u );
    }
    else
    { break;
    }
    refresh();
  }

playerdied:

  display( u.y, u.x, symdata( SMILEY, A_DIM ), true );

playerquit:

  message( "See you later..." );
  // view all the messages that you got just before you died
  read_messages();

  mainout.cleanup();
  return 0;
}
