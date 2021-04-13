/*
 * Copyright (c) 2015-2021 Philip Pavlick.  See '3rdparty.txt' for other
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
import std.random;
import core.stdc.time;

// Global Values & Configuration /////////////////////////////////////////////

static Map Current_map;
static uint Current_level;
static Swash_IO IO;

// An enum representing valid values for `SDL_Mode`.
enum SDL_mode
{
    none, terminal, full
};

// Used to determine how the SDL interface will behave, or if it will be
// foregone in favor of the curses interface.
static SDL_mode SDL_Mode = SDL_ENABLED ? SDL_mode.terminal : SDL_mode.none;

// These functions all act as shortcuts for the phrase
// `SDL_Mode == SDL_mode.*`
bool SDL_none()
{
    return SDL_Mode == SDL_mode.none;
}
bool SDL_terminal()
{
    return SDL_Mode == SDL_mode.terminal;
}
bool SDL_full()
{
    return SDL_terminal();
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
    if( (month == Month.dec && date == 31)
        || (month == Month.jan && date == 1) )
    {
        return "Happy New Year!  ";
    }

    // Christmas (and Christmas Eve)
    if( month == Month.dec && (date == 24 || date == 25) )
    {
        return "Merry Christmas!  ";
    }

    // Halloween
    if( month == Month.oct && date == 31 )
    {
        return "Happy Halloween!  ";
    }

    // Hanami (Cherry Blossom Festival, in this case set as Hanamatsuri, the
    // date of Buddha's birthday)
    if( month == Month.apr && date == 8 )
    {
        return "Happy Hanami!  ";
    }

    // Test date greeting (I coded this feature on 2019-12-21, so on that date
    // give the player this test output to make sure it's working)
    debug
    {
        if( month == Month.dec && date == 21 )
        {
            return "Happy date that I coded this stupid feature!  ";
        }
    }

    // Default return:
    return "";
} // string greet_player()

int main( string[] args )
{

// SECTION 1: ////////////////////////////////////////////////////////////////
// Initialization                                                           //
//////////////////////////////////////////////////////////////////////////////

    bool disp_version = false;
    string saved_lev;

    bool gen_map = false;
    bool test_colors = false;

    uint moved = 0;
    Move mov = Move.wait;

    uint mapgen_seed = 0;

    // Command-Line Arguments ////////////////////////////////////////////////

    // Get the name of the executable:
    string Name = args[0];

    auto clarguments = getopt( args,
        // v, display the version number and then exit
        "v|version",    &disp_version,
        // s, the file name of a saved game
        "s|save",       &saved_lev,
        // the display mode, either an SDL "terminal" or "none" for curses
        // ("full" is the same as "terminal" until a full graphics version of
        // the game is finished)
        "m|sdl-mode",   &SDL_Mode,
        // For debugging purposes, this "test map" can be generated at runtime
        // to test new features or other changes to the game.
        "test-map",     &Use_test_map,
        // For debugging purposes, this "color test screen" can be used to
        // test SwashRL's colors.
        "test-colors|test-color", &test_colors,
        // the "mapgen" mode generates a sample map, displays it, and then
        // exits without starting a game
        "mapgen",       &gen_map,
        // this seed will be used for map generation
        "d|seed|dungeon", &mapgen_seed,
        // Cheat modes (keep these a secret):
        "dqd", &Degreelessness,
        "esm", &Infinite_weapon,
        "spispopd", &Noclip,
        "eoa", &No_shadows,
        "hbr", &Master_debug
    ); // auto clarguments = getopt( args, ...

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
    -d, --seed        Sets the seed for map generation algorithms.  If this is
                      set to 0 (the default), a random number will be used.
    --test-map        Debug builds only: Starts the game on a test map.  Will
                      have no effect if -s or --save was used.
    --test-colors     Debug builds only: Displays a color test screen and then
                      exits without starting a game.
    --test-color      Debug builds only: Same effect as --test-colors
  examples:
    %s -s save0
    %s -m terminal
You are running %s version %s", Name, Name, Name, NAME, sp_version() );
        return 1;
    } // if( clarguments.helpWanted )

    if( disp_version )
    {
        writefln( "%s, version %s", NAME, sp_version() );
        return 1;
    }

    // If all we're doing is testing colors, ignore everything until I/O
    // initialization.
    if( test_colors )
    {
        // the color test screen is only available on debug builds
        debug {}
        else
        {
            writeln( "The color test screen is only available on debug builds of the game.
Try compiling with dub build -b debug" );
            return 31;
        }
    }
    else
    {

        // Activate Cheat / Debug Modes //////////////////////////////////////

        // If all we're doing is a quick mapgen, turn on the Silent
        // Cartographer and ignore the rest.
        if( gen_map )
        {
            No_shadows = true;
        }
        else
        {
            // Announce cheat modes
            if( Degreelessness )
            {
                message( "Degreelessness mode is turned on." );
            }
            if( Infinite_weapon )
            {
                message( "Killer heels mode is turned on." );
            }
            if( Noclip )
            {
                message( "Xorn mode is turned on." );
                No_shadows = true;
            }
            if( No_shadows )
            {
                message( "Silent Cartographer is turned on." );
            }
            if( Master_debug )
            {
                message( "YOU HAVE THE POWERRRRRRRR!" );
                Degreelessness = Infinite_weapon = Noclip = No_shadows = true;
            }

        } // else from `if( gen_map )`

    } // else from `if( test_colors )`

    // Initialize Input / Output /////////////////////////////////////////////

    // Check to make sure the SDL_Mode does not conflict with the way SwashRL
    // was compiled:
    if( !CURSES_ENABLED && SDL_none() )
    {
        SDL_Mode = SDL_mode.terminal;
    }

    if( !SDL_ENABLED && !SDL_none() )
    {
        SDL_Mode = SDL_mode.none;
    }

    version( curses )
    {
        if( SDL_none() )
        {
            IO = new Curses_IO();
        }
    }

    version( sdl )
    {
        if( SDL_terminal() )
        {
            try
            {
                IO = new SDL_Terminal_IO();
            }
            catch( SDL_Exception error )
            {
                writeln( error.msg );
                return 21;
            }
        }
    }

    // Initialize Standard Colors ////////////////////////////////////////////

    init_colors();

    // If a color test has been requested, and this is a debug build, display
    // the test screen and then exit.
    debug
    {
        if( test_colors )
        {
            IO.color_test_screen();

            // skip the rest of main
            IO.cleanup();
            return 0;
        }
    }

    // Initialize Random Number Generator ////////////////////////////////////

    seed();

    // If the user did not define a mapgen seed, generate a random one.
    if( mapgen_seed == 0 )
    {
        mapgen_seed = cast(uint)core.stdc.time.time(null);
    }

    Mapgen = Random( mapgen_seed );

    // Initialize Standard Terrain Elements //////////////////////////////////

    init_tile_symbols();
    init_terrain();

    // Initialize the `No_item` placeholder //////////////////////////////////

    No_item = Item( Symbol( '?', Colors.Error ), "NO ITEM",
                    Type.none, Slot.none, 0, 0, 0, 0, false, 0 );

    // Map Generator /////////////////////////////////////////////////////////

    // If we're just doing a sample map generation, do that now.
    if( gen_map )
    {
        Current_map = generate_new_map();
    }
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
                {
                    Current_map = test_map();
                }
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
            }
        }

        Current_level = 0;
    } // else from `if( gen_map )`

    // Initialize Keymaps ////////////////////////////////////////////////////

    try
    {
        Keymaps = [ new_keymap(), new_keymap( "ftgdnxhb.ie,pP S" ) ];
        Keymap_labels = ["Standard", "Dvorak"];
    }
    catch( Invalid_Keymap_Exception error )
    {
        writeln( error.msg );
        return 11;
    }

    // Assign default keymap
    Current_keymap = 0;

    // Initialize the Player /////////////////////////////////////////////////

    Monst plyr = init_player( Current_map.player_start[0],
                              Current_map.player_start[1] );

    // Initialize Field-of-Vision ////////////////////////////////////////////

    if( !No_shadows )
    {
        calc_visible( &Current_map, plyr.x, plyr.y );
    }

    // If fog of war has been disabled, set all tiles to visible.
    else
    {
        foreach( vy; 0 .. MAP_Y )
        {
            foreach( vx; 0 .. MAP_X )
            {
                Current_map.visible[vy][vx] = true;
            }
        }
    }

    // Initial Display ///////////////////////////////////////////////////////

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
    IO.refresh_status_bar( &plyr );

    // Display the map and player
    IO.display_map_and_player( Current_map, plyr );

    // Fill in the message line
    IO.clear_message_line();

    // Greet the Player //////////////////////////////////////////////////////

    message( "%sWelcome back to SwashRL!", greet_player() );
    IO.read_messages();

// Section 2: ////////////////////////////////////////////////////////////////
// The Main Loop                                                            //
//////////////////////////////////////////////////////////////////////////////

    while( plyr.hit_points > 0 )
    {
        // Input /////////////////////////////////////////////////////////////

        if( IO.window_closed() )
        {
            goto abrupt_quit;
        }

        moved = 0;
        mov = IO.get_command();

        if( IO.window_closed() )
        {
            goto abrupt_quit;
        }

        // The Player's Turn(s) //////////////////////////////////////////////

        switch( mov )
        {
            case Move.invalid:
                message( "Command not recognized.  Press ? for help." );
                break;

            // display help
            case Move.help:
                IO.help_screen();
                message( "You are currently using the %s keyboard layout.",
                         Keymap_labels[ Current_keymap ] );

                IO.refresh_status_bar( &plyr );
                IO.display_map_and_player( Current_map, plyr );
                break;

            // save and quit
            case Move.save:
                if( 'y' == IO.ask( "Really save?", ['y', 'n'], true ) )
                {
                    save_level( Current_map, plyr, "save0" );
                    goto playerquit;
                }
                break;

            // quit
            case Move.quit:
                if( 'y' == IO.ask( "Really quit?", ['y', 'n'], true ) )
                {
                    goto playerquit;
                }
                break;

            // display version information
            case Move.get_version:
                message( "%s, version %s", NAME, sp_version() );
                break;

            case Move.change_keymap:
                if( Current_keymap >= Keymaps.length - 1 )
                {
                    Current_keymap = 0;
                }
                else
                {
                    Current_keymap++;
                }

                message( "Control scheme swapped to %s",
                         Keymap_labels[Current_keymap] );
                break;

            // print the message buffer
            case Move.check_messages:
                IO.read_message_history();
                IO.refresh_status_bar( &plyr );
                IO.display_map_all( Current_map );
                break;

            // clear the message line
            case Move.clear_message:
                IO.clear_message_line();
                break;

            // wait
            case Move.wait:
                message( "You bide your time." );
                moved = 1;
                break;

            // pick up an item
            case Move.get:
                if( pickup( &plyr, Current_map.itms[plyr.y][plyr.x] ) )
                {
                    Current_map.itms[plyr.y][plyr.x] = No_item;
                    moved = 1;
                }
	            break;

            // drop an item
            case Move.drop:
                bool weapon = item_in_slot( plyr, Slot.weapon_hand ),
                     off    = item_in_slot( plyr, Slot.off_hand );

                Item dropme = No_item;

                // If the player has only one item in their hands, drop that
                // one automatically.  Otherwise, prompt to pick a hand.
                if( !weapon && !off )
                {
                    message( "You are not holding anything right now." );
                }
                else if( weapon && !off )
                {
drop_weapon:
                    dropme = plyr.equipment[Slot.weapon_hand];
                    plyr.equipment[Slot.weapon_hand] = No_item;
                }
                else if( !weapon && off )
                {
drop_offhand:
                    dropme = plyr.equipment[Slot.off_hand];
                    plyr.equipment[Slot.off_hand] = No_item;
                }
                else
                {
                    char drop_which
                        = IO.ask( "Drop item in weapon-hand or off-hand? (c to cancel)",
                                  ['w','o','c'], true );
                    if( 'w' == drop_which )
                    {
                        goto drop_weapon;
                    }
                    if( 'o' == drop_which )
                    {
                        goto drop_offhand;
                    }
                }

                if( Item_here( dropme ) )
                {
                    drop_item( &Current_map, dropme, plyr.x, plyr.y, true );
                    moved = 1;
                }
                break; // case Move.drop

            // display the inventory screen
            case Move.inventory:
                // If the player's inventory is empty, don't waste their time.
                if( !Item_here( plyr.inventory[0] ) )
                {
                    message( "You don't have anything in your bag at the moment." );
                    break;
                }

                // If the inventory is NOT empty, display it:
                IO.manage_inventory( &plyr );

                // Have the inventory screen exit to the equipment screen:
                goto case Move.equipment;

            // inventory management
            case Move.equipment:
                moved = IO.manage_equipment( &plyr, &Current_map );

                // we must redraw the screen after the equipment screen is
                // cleared
                IO.refresh_status_bar( &plyr );
                IO.display_map_and_player( Current_map, plyr );
                break;

            // all other commands go to umove
            default:
                IO.clear_message_line();
                IO.display( plyr.y + 1, plyr.x,
                        Current_map.tils[plyr.y][plyr.x].sym );

                moved = umove( &plyr, &Current_map, get_direction( mov ) );

                if( plyr.hit_points <= 0 )
                {
                    goto playerdied;
                }
                break;
        } // switch( mov )

        // The Monsters' Turn(s) /////////////////////////////////////////////

        if( moved > 0 )
        {
            while( moved > 0 )
            {
                map_move_all_monsters( &Current_map, &plyr );
                moved--;
            }

            if( !No_shadows )
            {
                calc_visible( &Current_map, plyr.x, plyr.y );
            }

            IO.refresh_status_bar( &plyr );
            IO.display_map_and_player( Current_map, plyr );
        }

        // Check Messages ////////////////////////////////////////////////////

        if( !Messages.empty() )
        {
            IO.read_messages();
        }

        // Refresh the Player ////////////////////////////////////////////////

        if( plyr.hit_points > 0 )
        {
            IO.display_player( plyr );
        }
        else
        {
            break; // end the mainloop if the player is dead
        }

        // Refresh the Display ///////////////////////////////////////////////

        IO.refresh_screen();

    } // while( plyr.hit_points > 0 )

// SECTION 3: ////////////////////////////////////////////////////////////////
// Closing the Program                                                      //
//////////////////////////////////////////////////////////////////////////////

    // Handle Player Death ///////////////////////////////////////////////////

playerdied:

    // Display a grayed-out player:
    plyr.sym.color = Colors.Dark_Gray;
    IO.display_player( plyr );

    // Say Goodbye ///////////////////////////////////////////////////////////

playerquit:

    message( "See you later..." );

    // view all the messages that you got just before you died
    IO.read_messages();

    // Wait for the user to press any key and then close the graphical mode
    // and quit the program.
    IO.get_key();

    // Final Cleanup /////////////////////////////////////////////////////////

skip_main:
abrupt_quit:
    IO.cleanup();

    return 0;
} // int main( string[] )
