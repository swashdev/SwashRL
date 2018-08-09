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

import global;

import std.string: toStringz;

static map Current_map;
static SwashIO IO;

void help()
{
  message(
    "hjklyubn or number pad to move. PERIOD to wait, SPACE to clear." );
}

void sp_version()
{
  message( "%s, version %.3f", "SwashRL", VERSION );
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
//  11 Exit due to KeymapException
//  21 Exit due to SDLException
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
    writeln( "Usage: swashrl [options]
  options:
    -h, --help        Displays this help output and then exits.
    -S, --sdl-mode    Sets the output mode for SwashRL.  Default \"terminal\"
                      Can be \"none\" for curses output or \"terminal\" for an
                      SDL terminal.  If your copy of SwashRL was compiled
                      without SDL or curses, this option may have no effect.
  examples:
    swashrl -S none
    swashrl -S terminal"
    );
    return 1;
  }

  // Check to make sure the SDL_Mode does not conflict with the way SwashRL
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
    IO = new CursesIO();
  }
}
version( sdl )
{
  try
  {
    if( SDL_terminal() )
    {
      IO = new SDLTerminalIO();
    }
  }
  catch( SDLException e )
  {
    writeln( e.msg );
    return 21;
  }
}

  try
  {
    // Initialize keymaps
    Keymaps = [ keymap(), keymap( "ftgdnxhb.iw,P " ), keymap() ];
  }
  catch( InvalidKeymapException e )
  {
    writeln( e.msg );
    return 11;
  }

  // Assign default keymap
  Current_keymap = 0;

  // Assign initial map
version( testmap )
{
  Current_map = test_map();
}
else
{
  Current_map = generate_new_map();
}

  // Initialize the player
  player u = init_player( Current_map.player_start[0],
                          Current_map.player_start[1] );

  // if the game is configured to highlight the player, and the SDL terminal
  // is being used, highlight the player.
  if( SDL_terminal() )
  { u.sym = symdata( SMILEY, Color( CLR_WHITE, HILITE_PLAYER ) );
  }

  // Initialize the fog of war
  static if( USE_FOV )
  { calc_visible( &Current_map, u.x, u.y );
  }

  clear_messages();

  // Initialize the status bar
  IO.refresh_status_bar( &u );

  // Display the map and player
  IO.display_map_and_player( Current_map, u );

  uint moved = 0;
  int mv = 5;
  while( mv != MOVE_QUIT && u.hp > 0 )
  {
    moved = 0;
    mv = IO.getcommand();
    switch( mv )
    {
      case MOVE_UNKNOWN:
         message( "Command not recognized.  Press ? for help." );
         break;
      // display help
      case MOVE_HELP:
         IO.help_screen();
         message( "You are currently using the %s keyboard layout.",
                  Keymap_labels[ Current_keymap ] );
         IO.refresh_status_bar( &u );
         IO.display_map_and_player( Current_map, u );
         break;
      // quit
      case MOVE_QUIT:
        goto playerquit;
      // display version information
      case MOVE_GETVERSION:
        sp_version();
        break;
      case MOVE_ALTKEYS:
        if( Current_keymap >= Keymaps.length - 1 )
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
        IO.read_message_history();
        IO.refresh_status_bar( &u );
        IO.display_map_all( Current_map );
        break;
      // clear the message line
      case MOVE_MESS_CLEAR:
        IO.clear_message_line();
        break;
      // wait
      case MOVE_WAIT:
        message( "You bide your time." );
        moved = 1;
        break;
      // inventory management
      case MOVE_INVENTORY:
        moved = IO.control_inventory( &u );
        // we must redraw the screen after the inventory window is cleared
        IO.display_map_and_player( Current_map, u );
        break;
      // all other commands go to umove
      default:
        IO.clear_message_line();
        IO.display( u.y + 1, u.x, Current_map.t[u.y][u.x].sym );
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
      IO.refresh_status_bar( &u );
      IO.display_map_and_player( Current_map, u );
    }
    if( !Messages.empty() )
    { IO.read_messages();
    }
    if( u.hp > 0 )
    { IO.display_player( u );
    }
    else
    { break;
    }
    IO.refresh_screen();
  }

playerdied:

  IO.display( u.y + 1, u.x, symdata( SMILEY, Color( CLR_DARKGRAY, false ) ),
              true );

playerquit:

  message( "See you later..." );
  // view all the messages that you got just before you died
  IO.read_messages();

  // Wait for the user to press any key and then close the graphical mode and
  // quit the program.
  IO.get_key();
  IO.cleanup();
  return 0;
}
