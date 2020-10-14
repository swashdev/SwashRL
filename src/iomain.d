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

// iomain.d:  Defines functions related to program output (graphics, &c)

import global;

// This interface is the skeleton for all of the different display modes.
//
// The various input/output modules for SwashRL are stored in classes which
// inherit from this interface.  The interface itself defines certain
// functions which are universal to all of the other modules.
interface Swash_IO
{

// SECTION 1: ////////////////////////////////////////////////////////////////
// Setup & Cleanup                                                          //
//////////////////////////////////////////////////////////////////////////////

    // Performs final cleanup functions for the input/output module, to close
    // the display before exiting the program.
    void cleanup();

    // Used to determine if the "close window" button has been pressed.
    //
    // This is only useful for the SDL interfaces, because the curses
    // interface works in the terminal.
    //
    // The function is used to instruct the mainloop to close the program in
    // the event that the player is trapped in an input loop.
    bool window_closed();

// SECTION 2: ////////////////////////////////////////////////////////////////
// Input                                                                    //
//////////////////////////////////////////////////////////////////////////////

    // Gets a character input from the user and returns it.
    char get_key();

    // Outputs a question to the user and returns a `char` result based on
    // their answer.
    char ask( string question, char[] options = ['y', 'n'],
              bool assume_lower = false );

// SECTION 3: ////////////////////////////////////////////////////////////////
// Output                                                                   //
//////////////////////////////////////////////////////////////////////////////

    // General Output ////////////////////////////////////////////////////////

    // Clears the screen.
    void clear_screen();

    // Refreshes the screen to reflect the changes made by the below `display`
    // functions.
    void refresh_screen();

    // Outputs a text character at the given coordinates.
    void put_char( uint y, uint x, char letter,
                   Colors color = Colors.Default );

    // The central display function: displays a given symbol at the given
    // coordinates.  Equivalent to `mvputch` in curses.
    void display( uint y, uint x, Symbol sym, bool center = true );

    // The Message Line //////////////////////////////////////////////////////

    // Clears the current message off the message line.
    void clear_message_line();

    // Outputs all of the messages in the message queue.
    void read_messages();

    // Gives the player a menu containing their message history.
    void read_message_history();

    // The Status Bar ////////////////////////////////////////////////////////

    // Refreshes the status bar.
    void refresh_status_bar( Player* plyr );

// SECTION 4: ////////////////////////////////////////////////////////////////
// Global Input Functions                                                   //
//////////////////////////////////////////////////////////////////////////////

    // Player Movement / Commands ////////////////////////////////////////////

    // Takes in a `char` input from the player and returns a movement flag
    // appropriate to the input.
    final Move get_command()
    {
        char key = get_key();

        // First check if `key` is contained in the player's keymap (see
        // keymap.d)
        Move* cmd = (key in Keymaps[Current_keymap]);

        // If so, return the appropriate command:
        if( cmd !is null )
        {
            return Keymaps[Current_keymap].get( key, Move.invalid );
        }

        // If not, check the standard prompts:
        switch( key )
        {
            // Number pad keys:
            case '7':
                return Move.northwest;

            case '8':
                return Move.north;

            case '9':
                return Move.northeast;

            case '6':
                return Move.east;

            case '3':
                return Move.southeast;

            case '2':
                return Move.south;

            case '1':
                return Move.southwest;

            case '4':
                return Move.west;

            case '5':
                return Move.wait;

            // If it's not in any of the standard controls or the number pad
            // controls, check the "admin keys":
            case 'Q':
                return Move.quit;

            case 'v':
                return Move.get_version;
        
            case '@':
                return Move.change_keymap;
            
            case '?':
                return Move.help;

            default:
                // Handle the default case outside this switch statement
                break;

        } // switch( key )

        // If none of the above command prompts match, default to the "command
        // not recognized" response.
        return Move.invalid;

    } // final Move get_command()

    // Inventory / Equipment Screen //////////////////////////////////////////

    // Display the inventory screen and allow the user to move items from
    // their bag into an equipment slot.
    final bool manage_inventory( Player* plyr )
    {
        import std.ascii: toLower;

        // Whether to communicate to the calling function to refresh the 
        // screen after managing the inventory.  Depending on what goes down
        // in here, it may be beneficial to let this function draw the screen
        // itself so it can display its own error messages.
        bool refresh_now = true;

        // `grab` and `line` here perform much the same functions they do in
        // `control_inventory`
        char grab = '\0';
        int line = -1;

        do
        {
            // Clear the screen and display a new menu with the items in the
            // bag
            display_inventory( plyr );

            // `last_i_sym` is the character that comes _after_ the last
            // item in the inventory.  This variable is used to determine
            // which characters not to accept when the player requests
            // an item.
            char last_i_sym = 'a';
      
            foreach( size_t slot_temp; INVENT_BAG .. plyr.inventory.items.length )
            {
                last_i_sym++;
                if( !Item_here( plyr.inventory.items[slot_temp] ) )
                {
                    // If the _first_ inventory slot is empty, just exit the
                    // inventory screen and go back to the equipment screen;
                    // there's nothing left to be done here.
                    if( slot_temp == INVENT_BAG )
                    {
                        display_equipment_screen( plyr, -1,
                                "Your bag is empty." );
                        return false;
                    }

                    break;
                }
            }

            // In the meantime, `grab` will tell us which item has been
            // selected.
            grab = get_key();

            if( grab == 'Q' || grab == ' ' )
            {
                return true;
            }

            // Check the player's grasp; if they do not have an open hand,
            // they can not take any more items out of their inventory.
            if( !check_grasp( plyr.inventory ) )
            {
                display_equipment_screen( plyr, -1,
                        "You do not have a free grasp." );
                return false;
            }

            if( toLower( grab ) >= last_i_sym || grab < 'a' )
            {
                display_equipment_screen( plyr, -1,
                        "You do not have that item." );
                return false;
            }
            else
            {
                line = (grab - 'a') + INVENT_BAG;

                // Decide which hand to place the item in.  As with picking up
                // items off the floor, weapons will prefer to go into the
                // weapon-hand, but other objects will favor the off-hand,
                // except when the favored hand is already taken.
                int hand = 0;

                if( !Item_here( plyr.inventory.items[INVENT_WEAPON] )
                    && (plyr.inventory.items[line].type == Type.weapon
                        || Item_here( plyr.inventory.items[INVENT_OFFHAND] ))
                  )
                {
                    hand = INVENT_WEAPON;
                }
                else
                {
                    hand = INVENT_OFFHAND;
                }

                // Transfer the item to the hand...
                plyr.inventory.items[hand] = plyr.inventory.items[line];
                plyr.inventory.items[line] = No_item;

                // Now we shuffle all the items in the inventory up one to
                // overwrite the item we've just removed from the bag.
                int index;
                for( index = line + 1; index <= 24 + INVENT_LAST_SLOT;
                     index++ )
                {
                    if( !Item_here( plyr.inventory.items[index] ) )
                    {
                        break;
                    }
                    else
                    {
                        plyr.inventory.items[index - 1] = plyr.inventory.items[index];
                        plyr.inventory.items[index] = No_item;
                    }
                }

                // Don't break this do loop just because we were successful in
                // extracting an item; the player might want to take out more
                // than one item.
                // Besides, in future implementations, we might want to allow
                // the player to remove a certain _number_ of a stacking item,
                // and breaking here makes it more of a hassle to correct a
                // mistake if they decide they want more stuff.
            } // else from if( toLower( grab ) >= last_i_sym || grab < 'a' )
        } while( grab != 'Q' && grab != ' ' );

        return refresh_now;
    } // final bool manage_inventory( Player* )

    // Controls the equipment screen and returns the number of turns spent
    // based on how many items are swapped around.
    final uint manage_equipment( Player* plyr, Map* map )
    {
        import std.ascii: toLower;
        import std.format : format;

        // the inventory slot letter the player has selected
        char grab = 0;
        // the line corresponding to the `grab` slot letter
        int line = -1;
        // the line corresponding to an item that has been grabbed
        int grabbed_line = -1;
        // an item that has been grabbed
        Item grabbed = No_item;
  
        // whether to refresh the inventory screen
        bool refresh_now = 1;

        // the number of turns that have passed...
        uint turns = 0;

        // clear the screen:
        clear_screen();

        do
        {
            if( refresh_now )
            {
                refresh_now = false;
                display_equipment_screen( plyr, grabbed_line );
            }

            // grab an item
            grab = get_key();
            if( grab == 'Q' || grab == ' ' )
            {
                break;
            }

            // this line is here to clear error messages
            foreach( count; 1 .. 79 )
            {
                put_char( 21, count, ' ' );
            }

            grab = toLower( grab );
            switch( grab )
            {
                case 't':
                    display_equipment_screen( plyr, -1,
                            "You do not have a tail." );
                    refresh_screen();
                    line = -1;
                    break;

                case 'd':
                    if( grabbed_line <= -1 )
                    {
                        display_equipment_screen( plyr, -1,
                                "You don't have anything to drop." );
                        refresh_screen();
                        line = -1;
                    }
                    else
                    {
                        grabbed = plyr.inventory.items[grabbed_line];
                        plyr.inventory.items[grabbed_line] = No_item;
                        drop_item( map, grabbed, plyr.x, plyr.y, true );
                        grabbed_line = line = -1;
                        refresh_now = true;
                    }
                    break;

                case 'i':
                    // The player has chosen to access an item in their bag
                    // If the player already has an item selected, attempt to
                    // place that item in the bag.
                    if( grabbed_line > -1 )
                    {
                        // First we need to check if the bag is full.
                        bool bag_full = true;
                        size_t index = 0;
                        for( index = 0; index < 24; index++ )
                        {
                            if( !Item_here(
                                  plyr.inventory.items[INVENT_BAG + index] ) )
                            {
                                bag_full = false;
                                break;
                            }
                        }

                        // If the bag is full, complain to the user and
                        // discard the swap
                        if( bag_full )
                        {
                            grabbed_line = -1;
                            line = -1;
                            display_equipment_screen( plyr, -1,
                                    "Your bag can not contain any more items."
                                    );
                            refresh_now = false;

                            // Go back to the start of the loop
                            continue;
                        }

                        // If the bag is NOT full, append the item to the end
                        // of their bag and remove it from the equipment slot
                        // it came from
                        else
                        {
                            grabbed = plyr.inventory.items[grabbed_line];
                            plyr.inventory.items[grabbed_line] = No_item;
                            plyr.inventory.items[INVENT_BAG + index]
                                = grabbed;

                            // Make a note to refresh the screen, discard all
                            // swaps, and go back to the start of the loop:
                            refresh_now = true;
                            grabbed_line = line = -1;
                            grabbed = No_item;
                            continue;
                        }
                    } // if( grabbed_line != -1 )
          
                    // If the player does NOT have an item already selected,
                    // they are trying to REMOVE an item from their bag...
                    else
                    {
                        // If the player does not have a free grasp, let them
                        // know.
                        if( !check_grasp( plyr.inventory ) )
                        {
                            display_equipment_screen( plyr, grabbed_line,
                                    "You do not have a free grasp to reach into your bag." );
                            refresh_now = false;
              
                            // Discard all swaps and go back to the start of
                            // the loop...
                            grabbed_line = line = -1;
                            continue;
                        }
                        else
                        {
                            // Pass control over to the inventory management
                            // function.
                            // Note that we're letting `manage_inventory`
                            // decide whether or not to refresh the equipment
                            // screen now.  This is because in some
                            // circumstances the function will redraw the
                            // equipment screen for us.
                            refresh_now = manage_inventory( plyr );

                            // Also reset the `line` and `grabbed_line`
                            // variables _after_ managing the inventory so
                            // that we don't end up anomalously grabbing a new
                            // item right out the gate
                            grabbed_line = line = -1;

                            // Reset `grab` so that a press of 'Q' or SPACE
                            // doesn't kick the user out of the equipment
                            // screen as well as the inventory screen.
                            grab = '\0';

                            // Go back to the start of the loop
                            continue;
                        } // else from if( !check_grasp( plyr.inventory ) )
                    } // else from if( grabbed_line != -1 )

                    // end of case 'i'; there's no `break` statement here
                    // because all of the above `if` statements have
                    // `continue` statements that would render it unreachable
                    // and frankly the warnings get on my nerves

                case 'w':
                    line =  0;
                    break;

                case 'o':
                    line =  1;
                    break;

                case 'q':
                    line =  2;
                    break;

                case 'h':
                    line =  3;
                    break;

                case 'c':
                    line =  4;
                    break;

                case 'p':
                    line =  5;
                    break;

                case 'b':
                    line =  6;
                    break;

                case 'l':
                    line =  7;
                    break;

                case 'r':
                    line =  8;
                    break;

                case 'n':
                    line =  9;
                    break;

                case 'g':
                    line = 10;
                    break;

                case 'k':
                    line = 11;
                    break;

                case 'f':
                    line = 12;
                    break;

                default:
                    break;
            } // switch( grab )

            if( line == -1 )
            {
                continue;
            }
            else
            {
                // if we haven't grabbed an item yet...
                if( !Item_here( grabbed ) )
                {
                    // ...confirm the slot is not empty...
                    if( !Item_here( plyr.inventory.items[line] ) )
                    {
                        display_equipment_screen( plyr, -1,
                                "There is no item there." );
                        line = -1;
                    }
                    else
                    {
                        // ...grab the item...
                        grabbed = plyr.inventory.items[line];
                        display_equipment_screen( plyr, line );

                        // ...and save that line so we can swap the items
                        // later.
                        grabbed_line = line;
                    }
                } // if( !Item_here( grabbed ) )
        
                // if we have already grabbed an item...
                else
                {
                    bool confirm_swap = false;

                    // ...check to see if the player can equip the item in
                    // this slot
                    switch( line )
                    {
                        case INVENT_HELMET:
                            if( grabbed.type == Type.weapon )
                            {
                                // Don't use `display_equipment_screen` here
                                // because we need to be able to format this
                                // message and we're going to end up quitting
                                // the equipment screen immediately anyway.
                                put_line( 21, 1,
                                        "You stab yourself in the head with a %s and die instantly.",
                                        grabbed.name );
seppuku:
                                refresh_screen();
                                get_key();
                                plyr.hit_points = 0;
                                return 0;
                            }

                            goto case INVENT_CUIRASS;
                            // fall through to next case
                        case INVENT_CUIRASS:
                            if( grabbed.type == Type.weapon )
                            {
                                // See above comment at `case INVENT_HELMET`
                                // for why we're not using
                                // `display_equipment_screen`
                                put_line( 21, 1,
                                        "You slice into your gut with a %s and commit seppuku.",
                                        grabbed.name );
                                goto seppuku;
                            }

                            goto default;
                            // fall through to next case
                        default:
                            // confirm the player can swap this item to this
                            // slot
                            confirm_swap = check_equip( grabbed, line );
                            break;
                    } // switch( line )
  
                    if( !confirm_swap )
                    {
                        // if we can't equip that item here, discard the swap
                        display_equipment_screen( plyr, -1,
                                format( "You can not equip a %s there.",
                                    grabbed.name ) );

discard_swap:
                        grabbed_line = -1;
                        grabbed.count = 0;
                        //get_key();
                        //refnow = true;
                        continue;
                    }
                    else
                    {
                        // check again in the opposite direction
                        if( !check_equip( plyr.inventory.items[line],
                                    grabbed_line ) )
                        {
                            display_equipment_screen( plyr, -1,
                                    format( "You can not swap the %s and the %s.",
                                        plyr.inventory.items[line].name,
                                    grabbed.name ) );
                            goto discard_swap;
                        }
                    }

                    // ...swap the inventory items...
                    plyr.inventory.items[grabbed_line]
                        = plyr.inventory.items[line];

                    // if the new slot is not empty, the player expends a turn
                    // moving that item
                    if( Item_here( plyr.inventory.items[line] ) )
                    {
                        turns += 1;
                    }

                    plyr.inventory.items[line] = grabbed;

                    // ...remove the grabbed item...
                    grabbed.count = 0;
                    grabbed_line = line = -1;

                    // ...clear the screen...
                    clear_screen();

                    // ...and make a note to refresh the inventory screen.
                    refresh_now = true;

                    // the player expends a turn moving an inventory item
                    turns += 1;
                } // else from if( !Item_here( grabbed ) )
            } // else from if( line != -1 )
        } while( grab != 'Q' && grab != ' ' );
  
        return turns;
    } // uint manage_equipment( Player*, Map* )

// SECTION 5: ////////////////////////////////////////////////////////////////
// Global Output Functions                                                  //
//////////////////////////////////////////////////////////////////////////////

    // General Output ////////////////////////////////////////////////////////

    // Prints a string at the given coordinates.  Equivalent to `mvprint` in
    // curses.  If `color` is given, the output line will be in the given
    // color.
    final void put_colored_line( T... )( uint y, uint x, Colors color, T args )
    {
        import std.string: format;
        string output = format( args );

        foreach( letter; 0 .. cast(uint)output.length )
        {
            put_char( y, x + letter, output[letter], color );
        }
    }

    final void put_line( T... )( uint y, uint x, T args )
    {
        put_colored_line( y, x, Colors.Default, args );
    }

    // The Help Screen ///////////////////////////////////////////////////////

    // Displays the "help" screen and waits for the player to clear it.
    final void help_screen()
    {
        clear_screen();

        put_line(  1, 1, "To move:   on numpad:   on Dvorak:"    );
        put_line(  2, 1, "   y k u        7 8 9        f t g"    );
        put_line(  3, 1, "    \\|/          \\|/          \\|/"  );
        put_line(  4, 1, "   h-*-l        4-*-6        d-*-l"    );
        put_line(  5, 1, "    /|\\          /|\\          /|\\"  );
        put_line(  6, 1, "   b j n        1 2 3        x h b"    );
    
        put_line(  8, 1, ". to wait"                     );
        put_line( 10, 1, "e to manage equipment"         );
        put_line( 11, 1, "i for inventory"               );
        put_line( 12, 1, ", to pick up an item"          );
        put_line( 13, 1, "d to drop an item (or p to put down an item, on Dvorak)" );
        put_line( 14, 1, "P to read message history"     );
        put_line( 15, 1, "SPACE clears the message line" );
    
        put_line( 17, 1, "? this help screen"         );
        put_line( 18, 1, "Q Quit"                     );
        put_line( 19, 1, "v check the version number" );
        put_line( 20, 1, "@ change keyboard layout"   );

        put_line( 22, 1, "Press any key to continue..." );

        refresh_screen();

        // wait for the player to clear the screen
        get_key();
    } // void help_screen()

    // Map Output ////////////////////////////////////////////////////////////

    // Uses `display` to draw the player.
    final void display_player( Player plyr )
    {
        // if the player is wearing a "festive hat," display them in a special
        // color
        if( plyr.inventory.items[INVENT_HELMET].name == "festive hat" )
        {
            display( plyr.y + 1, plyr.x,
                     Symbol( plyr.sym.ascii, Colors.Festive_Player ), true );
        }
        else
        {
            display( plyr.y + 1, plyr.x, plyr.sym, true );
        }
    }

    // Uses `display` to draw the given monster.
    final void display_mon( Monst mon )
    {
        display( mon.y + 1, mon.x, mon.sym );
    }

    // Uses `display_mon` to display all monsters on the given map.
    final void display_map_mons( Map to_display )
    {
        size_t num_mons = to_display.mons.length;
        Monst mon;
        foreach( index; 0 .. num_mons )
        {
            mon = to_display.mons[index];

            if( No_shadows || to_display.visible[mon.y][mon.x] )
            {
                display_mon( mon );
            }
        } // foreach( index; 0 .. num_mons )
    }

    // Uses `display` to draw all of the map tiles and items on the given map.
    final void display_map( Map to_display )
    {
        foreach( y; 0 .. MAP_Y )
        {
            foreach( x; 0 .. MAP_X )
            {
                Symbol output = to_display.tils[y][x].sym;
            	Color_Pair initial_color = Clr[output.color];

                static if( COLOR )
                {
                    static if( FOLIAGE )
                    {
                        // If there is mold growing on this tile, change the
                        // tile's color to green (unless there's also water)
                        if( to_display.tils[y][x].hazard & SPECIAL_MOLD )
                        {
                            if( !(to_display.tils[y][x].hazard & HAZARD_WATER ) )
                            {
                                if( initial_color.get_inverted() )
                                {
                                    output.color = Colors.Inverted_Green;
                                }
                                else
                                {
                                    output.color = Colors.Green;
                                }
                            }
                        }
                    }

                    static if( BLOOD )
                    {
                        // If there is blood spattered on this tile, change
                        // the tile's color to red (unless there's also
                        // water?)
                        if( to_display.tils[y][x].hazard & SPECIAL_BLOOD )
                        {
                            if( !(to_display.tils[y][x].hazard & HAZARD_WATER) )
                            {
                                if( initial_color.get_inverted() )
                                {
                                    output.color = Colors.Inverted_Red;
                                }
                                else
                                {
                                    output.color = Colors.Red;
                                }
                            }
                        }
                    }
                } // static if( COLOR )

                if( Item_here( to_display.itms[y][x] ) )
                {
                    output = to_display.itms[y][x].sym;
                }

                if( !No_shadows && !to_display.visible[y][x] )
                {
                    static if( !COLOR )
                    {
                        output = SYM_SHADOW;
                    }
                    else
                    {
                        if( to_display.tils[y][x].seen )
                        {
                            if( initial_color.get_inverted() )
                            {
                                output.color = Colors.Inverted_Dark_Gray;
                            }
                            else
                            {
                                output.color = Colors.Dark_Gray;
                            }
                        }
                        else
                        {
                            output = SYM_SHADOW;
                        }
                    }
                } // if( !No_shadows && !to_display.visible[y][x] )

                display( y + 1, x, output );
            } // foreach( x; 0 .. MAP_X )
        } // foreach( y; 0 .. MAP_Y )
    } // final void display_map( Map )

    // Uses `display_map` and `display_map_mons` to display all map tiles,
    // items, and monsters.
    final void display_map_all( Map to_display )
    {
        display_map( to_display );
        display_map_mons( to_display );
    }

    // Uses `display_map_all` and `display_player` to draw the full play area
    // including the map, items, monsters, and player.
    final void display_map_and_player( Map to_display, Player plyr )
    {
        display_map_all( to_display );
        display_player( plyr );
    }

    // The Inventory / Equipment Screens /////////////////////////////////////

    // Displays the equipment screen.
    final void display_equipment_screen( Player* plyr, int grabbed = -1,
                                         string msg = "" )
    {
        clear_screen();

        string slot_nam; // the name of the slot
        char   slot_let; // the letter that represents the slot

        foreach( count; 0 .. INVENT_LAST_SLOT )
        {
            // This switch statement of doom sets up the name and selection
            // button for each inventory slot
            switch( count )
            {
                default:
                    slot_nam = "none";
                    slot_let = '\0';
                    break;
  
                case INVENT_WEAPON:
                    slot_nam = "Weapon-hand";
                    slot_let = 'w';
                    break;
        
                case INVENT_OFFHAND:
                    slot_nam = "Off-hand";
                    slot_let = 'o';
                    break;

                case INVENT_QUIVER:
                    slot_nam = "Quiver";
                    slot_let = 'q';
                    break;

                case INVENT_HELMET:
                    slot_nam = "Helmet";
                    slot_let = 'h';
                    break;

                case INVENT_CUIRASS:
                    slot_nam = "Cuirass";
                    slot_let = 'c';
                    break;

                case INVENT_PAULDRONS:
                    slot_nam = "Pauldrons";
                    slot_let = 'p';
                    break;
        
                case INVENT_BRACERS:
                    slot_nam = "Bracers/gloves";
                    slot_let = 'b';
                    break;

                case INVENT_RINGL:
                    slot_nam = "Left ring";
                    slot_let = 'l';
                    break;
        
                case INVENT_RINGR:
                    slot_nam = "Right ring";
                    slot_let = 'r';
                    break;
        
                case INVENT_NECKLACE:
                    slot_nam = "Necklace";
                    slot_let = 'n';
                    break;
        
                case INVENT_GREAVES:
                    slot_nam = "Greaves";
                    slot_let = 'g';
                    break;
        
                case INVENT_KILT:
                    slot_nam = "Kilt/skirt";
                    slot_let = 'k';
                    break;
        
                case INVENT_FEET:
                    slot_nam = "Feet";
                    slot_let = 'f';
                    break;
        
                case INVENT_TAIL:
                    slot_nam = "Tailsheath";
                    slot_let = 't';
                    break;
            } // switch( count )

            if( slot_let == '\0' )
            {
                break;
            }

            put_colored_line( 1 + count, 1,
                    count == grabbed ? Colors.Inverted_White : Colors.Gray,
                    "%c) %s:%s", slot_let, slot_nam,
                    count == grabbed ? "            " : "" );

            if( Item_here( plyr.inventory.items[count] ) )
            {
                put_colored_line( 1 + count, 20,
                        count == grabbed ? Colors.Inverted_White : Colors.Gray,
                        plyr.inventory.items[count].name );
            }
            else
            {
                put_colored_line( 1 + count, 20, Colors.Inverted_Dark_Gray,
                                  "EMPTY" );
            }

        } // foreach( count; 0 .. INVENT_LAST_SLOT )

        put_line( 16, 1, "i) Bag" );

        if( grabbed <= -1 )
        {
            put_line( 18, 1, "Press a letter to \"grab\" that item" );
            put_line( 19, 1, "or \'i\' to take an item out of your bag" );
        }
        else
        {
            put_line( 15, 1, "d) Drop" );
            put_line( 18, 1,
                "Press a letter to move the grabbed item into a new equipment slot" );
            put_line( 19, 1, "or \'i\' to put it in your bag" );
        }

        put_line( 20, 1, "Press \'Q\' or SPACE to exit this screen" );

        if( msg != "" )
        {
            put_line( 22, 1, msg );
        }
  
        refresh_screen();

    } // final void display_equipment_screen( Player*, int?, string? )

    // Displays the inventory screen.
    final void display_inventory( Player* plyr )
    {

        clear_screen();

        // The symbol of the current item
        char slot_char = 'a';

        foreach( slot_index; 0 .. 24 )
        {
            // Inform the player of each item, up to 24 (one per line)
            if( Item_here( plyr.inventory.items[INVENT_BAG + slot_index] ) )
            {
                put_line( slot_index, 0, "%c) %s", slot_char,
                    plyr.inventory.items[INVENT_BAG + slot_index].name );
                slot_char++;
            }
            else
            {
                break;
            }
        }

        refresh_screen();

    } // final void display_inventory( Player* )

    debug
    {

        // Section 6: ////////////////////////////////////////////////////////
        // Debug Output                                                     //
        //////////////////////////////////////////////////////////////////////

        // Output a screen which will display various color pairs for test
        // purposes
        final void color_test_screen()
        {
            clear_screen();

            put_colored_line(  1,  1,
                      Colors.Default,             "Default"             );
            put_colored_line(  3,  1,
                      Colors.Black,               "Black"               );
            put_colored_line(  5,  1,
                      Colors.Red,                 "Red"                 );
            put_colored_line(  7,  1,
                      Colors.Green,               "Green"               );
            put_colored_line(  9,  1,
                      Colors.Dark_Blue,           "Dark_Blue"           );
            put_colored_line( 11,  1,
                      Colors.Brown,               "Brown"               );
            put_colored_line( 13,  1,
                      Colors.Magenta,             "Magenta"             );
            put_colored_line( 15,  1,
                      Colors.Cyan,                "Cyan"                );
            put_colored_line( 17,  1,
                      Colors.Gray,                "Gray"                );
            put_colored_line( 19,  1,
                      Colors.Dark_Gray,           "Dark_Gray"           );
            put_colored_line( 21,  1,
                      Colors.Lite_Red,            "Lite_Red"            );
            put_colored_line( 23,  1,
                      Colors.Lite_Green,          "Lite_Green"          );
            put_colored_line(  1, 21,
                      Colors.Blue,                "Blue"                );
            put_colored_line(  3, 21,
                      Colors.Yellow,              "Yellow"              );
            put_colored_line(  5, 21,
                      Colors.Pink,                "Pink"                );
            put_colored_line(  7, 21,
                      Colors.Lite_Cyan,           "Lite_Cyan"           );
            put_colored_line(  9, 21,
                      Colors.White,               "White"               );
            put_colored_line( 11, 21,
                      Colors.Inverted_Black,      "Inverted_Black"      );
            put_colored_line( 13, 21,
                      Colors.Inverted_Red,        "Inverted_Red"        );
            put_colored_line( 15, 21,
                      Colors.Inverted_Green,      "Inverted_Green"      );
            put_colored_line( 17, 21,
                      Colors.Inverted_Dark_Blue,  "Inverted_Dark_Blue"  );
            put_colored_line( 19, 21,
                      Colors.Inverted_Brown,      "Inverted_Brown"      );
            put_colored_line( 21, 21,
                      Colors.Inverted_Magenta,    "Inverted_Magenta"    );
            put_colored_line( 23, 21,
                      Colors.Inverted_Cyan,       "Inverted_Cyan"       );
            put_colored_line(  1, 41,
                      Colors.Inverted_Gray,       "Inverted_Gray"       );
            put_colored_line(  3, 41,
                      Colors.Inverted_Dark_Gray,  "Inverted_Dark_Gray"  );
            put_colored_line(  5, 41,
                      Colors.Inverted_Lite_Red,   "Inverted_Lite_Red"   );
            put_colored_line(  7, 41,
                      Colors.Inverted_Lite_Green, "Inverted_Lite_Green" );
            put_colored_line(  9, 41,
                      Colors.Inverted_Blue,       "Inverted_Blue"       );
            put_colored_line( 11, 41,
                      Colors.Inverted_Yellow,     "Inverted_Yellow"     );
            put_colored_line( 13, 41,
                      Colors.Inverted_Pink,       "Inverted_Pink"       );
            put_colored_line( 15, 41,
                      Colors.Inverted_Lite_Cyan,  "Inverted_Lite_Cyan"  );
            put_colored_line( 17, 41,
                      Colors.Inverted_White,      "Inverted_White"      );
            put_colored_line( 19, 41,
                      Colors.Error,               "Error"               );
            put_colored_line( 21, 41,
                      Colors.Player,              "Player"              );
            put_colored_line( 23, 41,
                      Colors.Festive_Player,      "Festive_Player"      );
            put_colored_line(  1, 61,
                      Colors.Water,               "Water"               );
            put_colored_line(  3, 61,
                      Colors.Lava,                "Lava"                );
            put_colored_line(  5, 61,
                      Colors.Acid,                "Acid"                );
            put_colored_line(  7, 61,
                      Colors.Copper,              "Copper"              );
            put_colored_line(  9, 61,
                      Colors.Silver,              "Silver"              );
            put_colored_line( 11, 61,
                      Colors.Gold,                "Gold"                );
            put_colored_line( 13, 61,
                      Colors.Roentgenium,         "Roentgenium"         );
            put_colored_line( 15, 61,
                      Colors.Money,               "Money"               );
            put_colored_line( 17, 61,
                      Colors.Royal,               "Royal"               );
            put_colored_line( 19, 61,
                      Colors.Holy,                "Holy"                );
            put_colored_line( 21, 61,
                      Colors.Snow,                "Snow"                );
            put_colored_line( 23, 61,
                      Colors.Snow_Tree,           "Snow_Tree"           );

            refresh_screen();

            get_key();
        } // color_test_screen()
    } // debug

} // interface SwashIO

// SECTION 7: ////////////////////////////////////////////////////////////////
// Importing Further IO Files                                               //
//////////////////////////////////////////////////////////////////////////////

// Import the classes which expand on this template depending on what display
// outputs have been compiled:

version( curses )
{
    import iocurses; // display interface for curses
}

version( sdl )
{
    import ioterm; // display interface for sdl terminal
}
