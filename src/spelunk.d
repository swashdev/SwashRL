/*
 * Copyright (c) 2016-2018 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */

import global;

import std.string: toStringz;

static map Current_map;
static SpelunkIO io;
static int Current_keymap;

void help()
{
  message(
    "hjklyubn or number pad to move. PERIOD to wait, SPACE to clear." );
}

void sp_version()
{
  message( "%s, version %.3f", "Spelunk!", VERSION );
}

// `SDL_Mode' is a static variable used by the display functions to determine
// whether SDL or curses is being used.  `SDL_MODES' is an enum that stores
// the possible values of `SDL_Mode'.
// Depending on how your compile is configured, the default will be either
// `SDL_MODES.terminal' or `SDL_MODES.none' but can be set in the command
// line.  If the command line input conflicts with your compile, `SDL_Mode'
// will be reset in `main'.
enum SDL_MODES { none, terminal, full };
static SDL_MODES SDL_Mode = SDL_ENABLED ? SDL_MODES.terminal : SDL_MODES.none;

bool SDL_none()
{ return SDL_Mode == SDL_MODES.none;
}
bool SDL_terminal()
{ return SDL_Mode == SDL_MODES.terminal;
}
bool SDL_full()
{ return SDL_terminal();
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
    writeln( "Usage: spelunk [options]
  options:
    -h, --help        Displays this help output and then exits.
    -S, --sdl-mode    Sets the output mode for Spelunk!  Default \"terminal\"
                      Can be \"none\" for curses output or \"terminal\" or
                      \"full\" for an SDL terminal.  If your copy of Spelunk!
                      was compiled without SDL or curses, this option may
                      have no effect.
  examples:
    spelunk --sdl-mode none
    spelunk --sdl-mode terminal"
    );
    return 1;
  }

  // Check to make sure the SDL_Mode does not conflict with the way Spelunk!
  // was compiled:
  if( !CURSES_ENABLED && SDL_none() )
  { SDL_Mode = SDL_MODES.terminal;
  }
  if( !SDL_ENABLED && !SDL_none() )
  { SDL_Mode = SDL_MODES.none;
  }

  seed();

version( curses )
{
  if( SDL_none() )
  {
    io = new CursesIO();
  }
}

  // Initialize keymaps
  Keymaps = [ keymap(), keymap( "fgtdnxhb. iw,P " ), keymap() ];

  // Assign default keymap
  Current_keymap = 0;

  // Assign initial map
  Current_map = test_map();

  // Initialize the player
  player u = init_player( 1, 1 );

  // Initialize the fog of war
  static if( USE_FOV )
  { calc_visible( &Current_map, u.x, u.y );
  }

  clear_messages();

  // Initialize the status bar
  io.refresh_status_bar( &u );

  // Display the map and player
  io.display_map_and_player( Current_map, u );

  uint moved = 0;
  int mv = 5;
  while( mv != MOVE_QUIT && u.hp > 0 )
  {
    moved = 0;
    mv = io.getcommand();
    switch( mv )
    {
      case MOVE_UNKNOWN:
         message( "Command not recognized.  Press ? for help." );
         break;
      // display help
      case MOVE_HELP:
         io.help_screen();
         message( "You are currently using the %s keyboard layout.",
                  Keymap_labels[ Current_keymap ] );
         io.refresh_status_bar( &u );
         io.display_map_and_player( Current_map, u );
         break;
      // quit
      case MOVE_QUIT:
        goto playerquit;
      // display version information
      case MOVE_GETVERSION:
        sp_version();
        break;
      case MOVE_ALTKEYS:
        if( Current_keymap >= Keymaps.length )
        { Current_keymap = 0;
        }
        else
        { Current_keymap++;
        }
        message( "Control scheme swapped to %s", Keymap_labels[Current_keymap]
               );
        break;
      // print the message buffer
      case MOVE_MESS_DISPLAY:
        io.read_message_history();
        io.refresh_status_bar( &u );
        io.display_map_all( Current_map );
        break;
      // clear the message line
      case MOVE_MESS_CLEAR:
        io.clear_message_line();
        break;
      // wait
      case MOVE_WAIT:
        message( "You bide your time." );
        moved = 1;
        break;
      // inventory management
      case MOVE_INVENTORY:
        moved = io.control_inventory( &u );
        // we must redraw the screen after the inventory window is cleared
        io.display_map_all( Current_map );
        break;
      // all other commands go to umove
      default:
        io.clear_message_line();
        io.display( u.y, u.x, Current_map.t[u.y][u.x].sym );
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
      io.refresh_status_bar( &u );
      io.display_map_and_player( Current_map, u );
    }
    if( !Messages.empty() )
    { io.read_messages();
    }
    if( u.hp > 0 )
    { io.display_player( u );
    }
    else
    { break;
    }
    io.refresh_screen();
  }

playerdied:

  io.display( u.y, u.x, symdata( SMILEY, A_DIM ), true );

playerquit:

  message( "See you later..." );
  // view all the messages that you got just before you died
  io.read_messages();

  io.cleanup();
  return 0;
}
