/*
 * Copyright (c) 2015-2020 Philip Pavlick.  See '3rdparty.txt' for other
 * licenses.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *  * Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *  * Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *  * Neither the name of the SwashRL project nor the names of its
 *    contributors may be used to endorse or promote products derived from
 *    this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

// main.d: The mainfile for the computer game SwashRL.

import global;

// SECTION 0: ////////////////////////////////////////////////////////////////
// Not The Mainloop                                                         //
//////////////////////////////////////////////////////////////////////////////

import std.string;
import std.getopt;
import std.stdio : writeln;
import std.stdio : writefln;
import std.ascii : toLower;
import std.file;

import std.datetime.systime;
import std.datetime : Month;

// Global Values & Configuration /////////////////////////////////////////////

static Map Current_map;
static uint Current_level;
static SwashIO IO;

// An enum representing valid values for `SDL_Mode`.
enum SDL_MODES { none, terminal, full };

// Used to determine how the SDL interface will behave, or if it will be
// foregone in favor of the curses interface.
static SDL_MODES SDL_Mode = SDL_ENABLED ? SDL_MODES.terminal : SDL_MODES.none;

// These functions all act as shortcuts for the phrase
// `SDL_Mode == SDL_MODES.*`
bool SDL_none()
{ return SDL_Mode == SDL_MODES.none;
}
bool SDL_terminal()
{ return SDL_Mode == SDL_MODES.terminal;
}
bool SDL_full()
{ return SDL_terminal();
}

// Utility Functions for Main ////////////////////////////////////////////////

// Returns the version number as a string.
string sp_version()
{
  return format( "%.3f-%s", VERSION, COMMIT );
}

// Greet the player according to the current date.
string greet_player()
{
  SysTime current_time = Clock.currTime();
  Month month = current_time.month;
  ubyte date  = current_time.day;

  // New Year's Eve/Day
  if((month == Month.dec && date == 31) || (month == Month.jan && date == 1))
    return "Happy New Year!  ";

  // Christmas (and Christmas Eve)
  if( month == Month.dec && (date == 24 || date == 25) )
    return "Merry Christmas!  ";

  // Halloween
  if( month == Month.oct && date == 31 )
    return "Happy Halloween!  ";

  // Hanami (Cherry Blossom Festival, in this case set as Hanamatsuri, the
  // date of Buddha's birthday)
  if( month == Month.apr && date == 8 )
    return "Happy Hanami!  ";

  // Test date greeting (I coded this feature on 2019-12-21, so on that date
  // give the player this test output to make sure it's working)
debug
{
  if( month == Month.dec && date == 21 )
    return "Happy date that I coded this stupid feature!  ";
}

  // Default return:
  return "";
}

int main( string[] args )
{

// SECTION 1: ////////////////////////////////////////////////////////////////
// Initialization                                                           //
//////////////////////////////////////////////////////////////////////////////

  bool disp_version = false;
  string saved_lev;

  bool gen_map = false;

  uint moved = 0;
  int mv = 5;

  // Command-Line Arguments //////////////////////////////////////////////////

  // Get the name of the executable:
  string Name = args[0];

  auto clarguments = getopt( args,
    // v, display the version number and then exit
    "v",        &disp_version,
    "version",  &disp_version,
    // s, the file name of a saved game
    "s",        &saved_lev,
    "save",     &saved_lev,
    // the display mode, either an SDL "terminal" or "none" for curses ("full"
    // is the same as "terminal" until a full graphics version of the game is
    // finished)
    "sdl-mode", &SDL_Mode,
    "m",        &SDL_Mode,
    // For debugging purposes, this "test map" can be generated at runtime
    // to test new features or other changes to the game.
    "test-map", &Use_test_map,
    // the "mapgen" mode generates a sample map, displays it, and then exits
    // without starting a game
    "mapgen",   &gen_map,
    // Cheat modes (keep these a secret):
    "dqd",      &Degreelessness,
    "esm",      &Infinite_weapon,
    "spispopd", &Noclip,
    "eoa",      &No_shadows
  );

  if( clarguments.helpWanted )
  {
    writefln( "Usage: %s [options]
  options:
    -h, --help        Displays this help output and then exits.
    -v, --version     Displays the version number and then exits.
    -s, --save        Sets the saved level that SwashRL will load in.  The
                      game will load in your input save file name with
                      \".lev\" appended to the end in the save/lev directory.
    -m, --sdl-mode    Sets the output mode for SwashRL.  Default \"terminal\"
                      Can be \"none\" for curses output or \"terminal\" for an
                      SDL terminal.  If your copy of SwashRL was compiled
                      without SDL or curses, this option may have no effect.
    --mapgen          Displays a sample map and then exits without starting a
                      game.
    --test-map        Debug builds only: Starts the game on a test map.  Will
                      have no effect if -s or --save was used.
  examples:
    %s -s save0
    %s -m terminal
You are running %s version %s",
      Name, Name, Name, NAME, sp_version() );
    return 1;
  }

  if( disp_version )
  {
    writefln( "%s, version %s", NAME, sp_version() );
    return 1;
  }

  // Activate Cheat / Debug Modes ////////////////////////////////////////////

  // If all we're doing is a quick mapgen, turn on the Silent Cartographer and
  // ignore the rest.
  if( gen_map )  No_shadows = true;
  else
  {

    // Announce cheat modes
    if( Degreelessness )
    { message( "Degreelessness mode is turned on." );
    }
    if( Infinite_weapon )
    { message( "Killer heels mode is turned on." );
    }
    if( Noclip )
    {
      message( "Xorn mode is turned on." );
      No_shadows = true;
    }
    if( No_shadows )
    { message( "Silent Cartographer is turned on." );
    }

  } // else from `if( gen_map )`

  // Initialize Input / Output ///////////////////////////////////////////////

  // Check to make sure the SDL_Mode does not conflict with the way SwashRL
  // was compiled:
  if( !CURSES_ENABLED && SDL_none() )  SDL_Mode = SDL_MODES.terminal;

  if( !SDL_ENABLED && !SDL_none() ) SDL_Mode = SDL_MODES.none;
  }

version( curses )
{

  if( SDL_none() )  IO = new CursesIO();

}
version( sdl )
{

  try
  {

    if( SDL_terminal() )  IO = new SDLTerminalIO();

  }
  catch( SDLException e )
  {

    writeln( e.msg );
    return 21;

  }

} // version( sdl )

  // Initialize Random Number Generator //////////////////////////////////////

  seed();

  // Map Generator ///////////////////////////////////////////////////////////

  // If we're just doing a sample map generation, do that now.
  if( gen_map )  Current_map = generate_new_map();

  else
  {

    // Check if we're loading a map from a saved file.
    if( saved_lev.length > 0 )
    {
      Current_map = level_from_file( saved_lev );
    }
    else
    {
      // Check if we're using the test map.
      if( Use_test_map )
      {
   debug
        Current_map = test_map();
   else
   {

        writeln( "The test map is only available for debug builds of the game.
Try compiling with dub build -b debug" );
        return 31;

   }
      }
      else
      {
        Current_map = generate_new_map();
      } // else from if( Use_test_map )

    } // else from if( saved_lev.length > 0 )
    Current_level = 0;

  } // else from `if( gen_map )`

  // Initialize Keymaps //////////////////////////////////////////////////////

  try
  {
    Keymaps = [ keymap(), keymap( "ftgdnxhb.ie,pP S" ) ];
    Keymap_labels = ["Standard", "Dvorak"];
  }
  catch( InvalidKeymapException e )
  {
    writeln( e.msg );
    return 11;
  }

  // Assign default keymap
  Current_keymap = 0;

  // Initialize the Player ///////////////////////////////////////////////////

  Monst u = init_player( Current_map.player_start[0],
                         Current_map.player_start[1] );

  // If the game is configured to highlight the player, and the SDL terminal
  // is being used, highlight the player.
  if( SDL_terminal() )
  {
     u.sym = symdata( SMILEY, Color( CLR_WHITE, HILITE_PLAYER ) );
  }

  // Initialize Field-of-Vision //////////////////////////////////////////////

  if( !No_shadows )  calc_visible( &Current_map, u.x, u.y );

  // If fog of war has been disabled, set all tiles to visible.
  else
  {
    foreach( vy; 0 .. MAP_Y )
    {
      foreach( vx; 0 .. MAP_X )
      {
        Current_map.v[vy][vx] = true;
      }
    }
  }

  // Initial Display /////////////////////////////////////////////////////////

  // If we're just doing a map gen, there's no need to display anything else
  if( gen_map )
  {
    IO.display_map( Current_map );
    message( "%s, version %s", NAME, sp_version() );
    IO.read_messages();
    IO.get_key();

    // skip the rest of main
    goto skip_main;
  }

  // Initialize the status bar
  IO.refresh_status_bar( &u );

  // Display the map and player
  IO.display_map_and_player( Current_map, u );

  // Fill in the message line
  IO.clear_message_line();

  // Greet the Player ////////////////////////////////////////////////////////

  message( "%sWelcome back to SwashRL!", greet_player() );
  IO.read_messages();

// Section 2: ////////////////////////////////////////////////////////////////
// The Main Loop                                                            //
//////////////////////////////////////////////////////////////////////////////

  while( u.hp > 0 )
  {

    // Input /////////////////////////////////////////////////////////////////

    if( IO.window_closed() ) goto abrupt_quit;

    moved = 0;
    mv = IO.get_command();

    if( IO.window_closed() ) goto abrupt_quit;

    // The Player's Turn(s) //////////////////////////////////////////////////

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

      // save and quit
      case MOVE_SAVE:

        if( 'y' == IO.ask( "Really save?", ['y', 'n'], true ) )
        {
          save_level( Current_map, u, "save0" );
          goto playerquit;
        }

        break;

      // quit
      case MOVE_QUIT:

        if( 'y' == IO.ask( "Really quit?", ['y', 'n'], true ) )
        {
          goto playerquit;
        }

        break;

      // display version information
      case MOVE_GETVERSION:

        message( "%s, version %s", NAME, sp_version() );

        break;

      case MOVE_ALTKEYS:

        if( Current_keymap >= Keymaps.length - 1 )  Current_keymap = 0;
        else  Current_keymap++;

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

      // display the inventory screen
      case MOVE_INVENTORY:

        // If the player's inventory is empty, don't waste their time.
        if( !Item_here( u.inventory.items[INVENT_BAG] ) )
        {
          message( "You don't have anything in your bag at the moment." );
          break;
        }

        // If the inventory is NOT empty, display it:
        //IO.display_inventory( &u );
        IO.manage_inventory( &u );

        // Have the inventory screen exit to the equipment screen:
        goto case MOVE_EQUIPMENT;

      // inventory management
      case MOVE_EQUIPMENT:

        moved = IO.manage_equipment( &u );

        // we must redraw the screen after the equipment screen is cleared
        IO.refresh_status_bar( &u );
        IO.display_map_and_player( Current_map, u );

        break;

      // all other commands go to umove
      default:

        IO.clear_message_line();
        IO.display( u.y + 1, u.x, Current_map.t[u.y][u.x].sym );

        moved = umove( &u, &Current_map, cast(ubyte)mv );

        if( u.hp <= 0 )  goto playerdied;
        break;
    }

    // The Monsters' Turn(s) /////////////////////////////////////////////////

    if( moved > 0 )
    {
      while( moved > 0 )
      {
        map_move_all_monsters( &Current_map, &u );
        moved--;
      }

      if( !No_shadows )  calc_visible( &Current_map, u.x, u.y );

      IO.refresh_status_bar( &u );
      IO.display_map_and_player( Current_map, u );

    } // if( moved > 0 )

    // Check Messages ////////////////////////////////////////////////////////

    if( !Messages.empty() )  IO.read_messages();

    // Refresh the Player ////////////////////////////////////////////////////

    if( u.hp > 0 )  IO.display_player( u );
    else  break; // end the mainloop if the player is dead

    // Refresh the Display ///////////////////////////////////////////////////

    IO.refresh_screen();

  } // while( u.hp > 0 )

// SECTION 3: ////////////////////////////////////////////////////////////////
// Closing the Program                                                      //
//////////////////////////////////////////////////////////////////////////////

  // Handle Player Death /////////////////////////////////////////////////////

playerdied:

  // Display a grayed-out player:
  IO.display( u.y + 1, u.x, symdata( SMILEY, Color( CLR_DARKGRAY, false ) ),
              true );

  // Say Goodbye /////////////////////////////////////////////////////////////

playerquit:

  message( "See you later..." );

  // view all the messages that you got just before you died
  IO.read_messages();

  // Wait for the user to press any key and then close the graphical mode and
  // quit the program.
  IO.get_key();

  // Final Cleanup ///////////////////////////////////////////////////////////

skip_main:
abrupt_quit:
  IO.cleanup();

  return 0;
}
