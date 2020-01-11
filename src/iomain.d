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

/++
 + This interface is the skeleton for all of the different display modes.
 +
 + The various input/output modules for SwashRL are stored in classes which
 + inherit from this interface.  The interface itself defines certain
 + functions which are universal to all of the other modules.
 +
 + See_Also:
 +   <a href="iocurses.html">CursesIO</a>,
 +   <a href="ioterm.html">SDLTerminalIO</a>
 +/
interface SwashIO
{

  /////////////////////
  // Setup & Cleanup //
  /////////////////////

  /++
   + Performs final cleanup functions for the input/output module, to close
   + the display before exiting the program.
   +/
  void cleanup();

  /++
   + Used to determine if the "close window" button has been pressed.
   +
   + This is only useful for the SDL interfaces, because the curses interface
   + works in the terminal.
   +
   + The function is used to instruct the mainloop to close the program in the
   + event that the player is trapped in an input loop.
   +/
  bool window_closed();

  ///////////
  // Input //
  ///////////

  /// Gets a character input from the user and returns it
  char get_key();

  /++
   + Outputs a question to the user and returns a `char` result.
   +
   + This function is designed to function similarly to the old computer
   + terminal prompts which would ask a yes/no question and then take in a y
   + or an n for input.
   +
   + If assume_lower is `true`, the function will convert the input into a
   + lowercase letter.  This should be used sparingly.
   +
   + Params:
   +   question     = The question to be output to the user
   +   options      = Possible answers for the user to give
   +   assume_lower = Whether or not to convert user input to lowercase
   +
   + Returns:
   +   A `char` from options which the user has selected
   +/
  char ask( string question, char[] options = ['y', 'n'],
            bool assume_lower = false );

  ////////////
  // Output //
  ////////////

  /// Clears the screen
  void clear_screen();

  /// Refreshes the screen to reflect the changes made by the below `display`
  /// functions
  void refresh_screen();

  /++
   + Outputs a text character at the given coordinates with a certain color
   +
   + This is the basic "put charater here" function typical of a Roguelike
   + game.  The default color value `CLR_NONE` will cause the function to use
   + the "default color," usually gray.
   +
   + See_Also:
   +   <a href="#SwashIO.put_line">put_line</a>,
   +   <a href="#SwashIO.display">display</a>
   +
   + Params:
   +   y     = The y coordinate to output c at
   +   x     = The x coordinate to output c at
   +   c     = The character to be output at (x, y)
   +   color = The color to use when outputting c
   +/
  void put_char( uint y, uint x, char c,
                 Color color = Color( CLR_NONE, false ) );

  /++
   + The central display function
   +
   + This function displays a given `symbol` at the given coordinates.
   +
   + Because the `symbol` struct contains more information than a char, this
   + function is more flexible than `put_char` and can even be used for full
   + sprite graphics versions of SwashRL.
   +
   + If `center` is true, the program will make it a point to reposition the
   + cursor at (x, y) after drawing.  This is only useful for the curses
   + interfaces.
   +
   + See_Also:
   +   <a href="#SwashIO.put_char">put_char</a>
   +
   + Params:
   +   y      = The y coordinate to output s at
   +   x      = The x coordinate to output s at
   +   s      = The `symbol` to be drawn at (x, y)
   +   center = Whether or not to explicitly recenter the cursor on top of the
   +            drawn cursor
   +/
  void display( uint y, uint x, Symbol s, bool center = true );

  /// Clears the current message off the message line
  void clear_message_line();

  /// Reads the player all of their messages one at a time
  void read_messages();

  /// Gives the player a menu containing their message history.
  void read_message_history();

  /++
   + Refreshes the status bar
   +
   + This function is used to update the status bar after every turn, to
   + reflect changes to the player's stats.
   +
   + Params:
   +   u = The `Player` whose stats are to be drawn to the status bar
   +/
  void refresh_status_bar( Player* u );

  /////////////////////
  // Final Functions //
  /////////////////////

  /++
   + Takes in a `char` input from the player and returns a movement flag
   + appropriate to the input
   +
   + This function uses `get_key` to take in an input from the player and then
   + checks to see if it is a valid input command.  If it is, it returns a
   + `uint` representing a movement flag as defined in moves.d.
   +
   + If the command is not contained in `Current_keymap` and is not one of the
   + reserved standard commands, `MOVE_UNKNOWN` is returned to tell the
   + mainloop to display a quick help message.
   +
   + See_Also:
   +   <a href="#SwashIO.get_key">get_key</a>
   +
   + Returns:
   +   A `uint` movement flag, defined in moves.d
   +/
  final uint get_command()
  {
    char c = get_key();

    // First check if `c' is contained in the player's keymap (see `keymap.d')
    uint* cmd = (c in Keymaps[Current_keymap]);

    // If so, return the appropriate command:
    if( cmd !is null )
    { return Keymaps[Current_keymap].get( c, MOVE_UNKNOWN );
    }

    // If not, check the standard prompts:
    switch( c )
    {

      // Number pad keys:
      case '7':
        return MOVE_NW;
      case '8':
        return MOVE_NN;
      case '9':
        return MOVE_NE;
      case '6':
        return MOVE_EE;
      case '3':
        return MOVE_SE;
      case '2':
        return MOVE_SS;
      case '1':
        return MOVE_SW;
      case '4':
        return MOVE_WW;
      case '5':
        return MOVE_WAIT;

      // If it's not in any of the standard controls or the number pad
      // controls, check the "admin keys":
      case 'Q':
        return MOVE_QUIT;
      case 'v':
        return MOVE_GETVERSION;
      case '@':
        return MOVE_ALTKEYS;
      case '?':
        return MOVE_HELP;

      default:
        // Handle the default case outside this switch statement
        break;

    } // switch( c )

    // If none of the above command prompts match, default to the "command
    // not recognized" response.
    return MOVE_UNKNOWN;

  } // int get_command

  /++
   + Display the inventory screen and allow the user to remove items from
   + their bag.
   +
   + This function will use `display_inventory` to draw the inventory screen
   + and then take in user inputs to remove items from the bag and place them
   + into an open hand on the equipment screen.
   +
   + Because this function needs to be able to draw the equipment screen in
   + order to output error messages, it is given the ability to inform the
   + `control_inventory` function not to re-draw the equipment screen.  It
   + will return `true` if the equipment screen should be re-drawn after the
   + player is finished managing their inventory.
   +
   + See_Also:  SwashIO.control_inventory
   +
   + Params:
   +   u  A pointer to the `Player` whose inventory is being managed.
   +
   + Returns:
   +   `true` if the calling function should redraw the equipment screen;
   +   `false` otherwise.
   +/
  final bool manage_inventory( Player* u )
  {
    import std.ascii: toLower;

    // Whether to communicate to the calling function to refresh the screen
    // after managing the inventory.  Depending on what goes down in here, it
    // may be beneficial to let this function draw the screen itself so it can
    // display its own error messages.
    bool refnow = true;

    // `grab` and `line` here perform much the same functions they do in
    // `control_inventory`
    char grab = '\0';
    int line = -1;

    do
    {

      // Clear the screen and display a new menu with the items in the
      // bag
      display_inventory( u );

      // `last_i_sym` is the character that comes _after_ the last
      // item in the inventory.  This variable is used to determine
      // which characters not to accept when the player requests
      // an item.
      char last_i_sym = 'a';
      foreach( size_t slot_temp; INVENT_BAG .. u.inventory.items.length )
      {
        last_i_sym++;
        if( !Item_here( u.inventory.items[slot_temp] ) )
        {
          // If the _first_ inventory slot is empty, just exit the inventory
          // screen and go back to the equipment screen; there's nothing left
          // to be done here.
          if( slot_temp == INVENT_BAG )
          {
            display_equipment_screen( u, -1, "Your bag is empty." );
            return false;
          }

          break;
        }
      }

      // In the meantime, `grab` will tell us which item has been
      // selected.
      grab = get_key();

      if( grab == 'Q' || grab == ' ' )  return true;

      // Check the player's grasp; if they do not have an open hand, they can
      // not take any more items out of their inventory.
      if( !check_grasp( u.inventory ) )
      {
        display_equipment_screen( u, -1, "You do not have a free grasp." );
        return false;
      }

      if( toLower( grab ) >= last_i_sym || grab < 'a' )
      {
        display_equipment_screen( u, -1,
          "You do not have that item." );
        return false;
      }
      else
      {
        line = (grab - 'a') + INVENT_BAG;
        int hand = 0;
        // Decide which hand to place the item in.  As with picking up
        // items off the floor, weapons will prefer to go into the
        // weapon-hand, but other objects will favor the off-hand,
        // except when the favored hand is already taken.
        if( !Item_here( u.inventory.items[INVENT_WEAPON] ) &&
              (u.inventory.items[line].type & ITEM_WEAPON
            || Item_here( u.inventory.items[INVENT_OFFHAND] ))
          )
        { hand = INVENT_WEAPON;
        }
        else
        { hand = INVENT_OFFHAND;
        }

        // Transfer the item to the hand...
        u.inventory.items[hand] = u.inventory.items[line];
        u.inventory.items[line] = No_item;
        // Now we shuffle all the items in the inventory up one to
        // overwrite the item we've just removed from the bag.
        int I;
        for( I = (line + 1); I <= (24 + INVENT_LAST_SLOT); I++ )
        {
          if( !Item_here( u.inventory.items[I] ) )  break;
          else
          {
            u.inventory.items[I - 1] = u.inventory.items[I];
            u.inventory.items[I] = No_item;
          }
        }

        // Don't break this do loop just because we were successful in
        // extracting an item; the player might want to take out more than one
        // item.
        // Besides, in future implementations, we might want to allow the
        // player to remove a certain _number_ of a stacking item, and
        // breaking here makes it more of a hassle to correct a mistake if
        // they decide they want more stuff.
        //break;
      } /* else from if( toLower( grab ) >= I_sym || grab < 'a' ) */

    } while( grab != 'Q' && grab != ' ' );

    return refnow;

  } // final bool manage_inventory( Player* )

  /++
   + Controls the equipment screen
   +
   + This function outputs the equipment screen and allows the player to
   + manipulate their equipment and inventory through it.
   +
   + The specific details of how this function works are actually somewhat
   + complicated and boring, but the jist of it is that each equipment slot
   + is associated with an array index, which is given a line and a letter
   + on the equipment screen.  When the player enters a key that matches that
   + letter, that array index is "grabbed," and a second keypress will place
   + that item on a new equipment slot, swapping it with a second item if
   + necessary.
   +
   + This function will also perform checks using the `check_equip` function
   + to ensure that the player does not place an inventory item on an
   + inappropriate slot; for example, wearing a cuirass as a helmet.
   +
   + <strong>This function can kill the player if they commit seppukku on the
   + equipment screen.</strong>
   +
   + Each time the player moves an inventory item from one equipment slot to
   + another, a turn passes in the game.  Swapping two inventory items is
   + counted as two turns.  The more items the player moves around, the more
   + turns they will skip after the equipment screen is closed.
   +
   + See_Also:  SwashIO.manage_inventory
   +
   + Params:
   +   u = The `Player` whose inventory is being controlled
   +
   + Returns:
   +   A number of turns, as a `uint`, to be passed to the mainloop which the
   +   player will skip after this function finishes.
   +/
  final uint manage_equipment( Player* u )
  {
    import std.ascii: toLower;
    import std.format : format;

    // the inventory slot letter the player has selected
    char grab = 0;
    // `line': the line corresponding to the `grab' slot letter
    // `grabbed_line': the line corresponding to an item that has been grabbed
    int line = -1, grabbed_line = -1;
    // `grabbed': an item that has been grabbed
    Item grabbed = No_item;
  
    // whether to refresh the inventory screen
    bool refnow = 1;

    // the number of turns that have passed...
    uint turns = 0;

    // clear the screen:
    clear_screen();

    do
    {
      if( refnow )
      {
        refnow = 0;
        display_equipment_screen( u, grabbed_line );
      } /* if( refnow ) */

      // grab an item
      grab = get_key();
      if( grab == 'Q' || grab == ' ' )
      { break;
      }

      // this line is here to clear error messages
      foreach( count; 1 .. 79 )
      { put_char( 21, count, ' ' );
      }

      grab = toLower( grab );
      switch( grab )
      {
        case 't':
          display_equipment_screen( u, -1, "You do not have a tail." );
          refresh_screen();
          line = -1;
          break;
        case 'i':
          // The player has chosen to access an item in their bag
          // If the player already has an item selected, attempt to place that
          // item in the bag.
          if( grabbed_line > -1 )
          {
            // First we need to check if the bag is full.
            bool bag_full = true;
            size_t I = 0;
            for( I = 0; I < 24; I++ )
            {
              if( !Item_here( u.inventory.items[INVENT_BAG + I] ) )
              {
                bag_full = false;
                break;
              }
            }
            // If the bag is full, complain to the user and discard the swap
            if( bag_full )
            {
              grabbed_line = -1;
              line = -1;
              display_equipment_screen( u, -1,
                "Your bag can not contain any more items." );
              refnow = false;
              // Go back to the start of the loop
              continue;
            }
            // If the bag is NOT full, append the item to the end of their bag
            // and remove it from the equipment slot it came from
            else
            {
              grabbed = u.inventory.items[grabbed_line];
              u.inventory.items[grabbed_line] = No_item;
              u.inventory.items[INVENT_BAG + I] = grabbed;

              // Make a note to refresh the screen, discard all swaps, and go
              // back to the start of the loop:
              refnow = true;
              grabbed_line = line = -1;
              grabbed = No_item;
              continue;
            }
          } /* if( grabbed_line != -1 ) */
          // If the player does NOT have an item already selected, they are
          // trying to REMOVE an item from their bag...
          else
          {
            // If the player does not have a free grasp, let them know.
            if( !check_grasp( u.inventory ) )
            {
              display_equipment_screen( u, grabbed_line,
                     "You do not have a free grasp to reach into your bag." );
              refnow = false;
              // Discard all swaps and go back to the start of the loop...
              grabbed_line = line = -1;
              continue;
            }
            else
            {
              // Pass control over to the inventory management function.
              // Note that we're letting `manage_inventory` decide whether or
              // not to refresh the equipment screen now.  This is because in
              // some circumstances the function will redraw the equipment
              // screen for us.
              refnow = manage_inventory( u );

              // Also reset the `line` and `grabbed_line` variables _after_
              // managing the inventory so that we don't end up anomalously
              // grabbing a new item right out the gate
              grabbed_line = line = -1;

              // Reset `grab` so that a press of 'Q' or SPACE doesn't kick
              // the user out of the equipment screen as well as the inventory
              // screen.
              grab = '\0';

              // Go back to the start of the loop
              continue;

            } /* else from if( !check_grasp( u.inventory ) ) */

          } /* else from if( grabbed_line != -1 ) */

        /* end of case 'i'; there's no `break` statement here because all of
         * the above `if` statements have `continue` statements that would
         * render it unreachable and frankly the warnings get on my nerves
         */

        case 'w': line =  0; break;
        case 'o': line =  1; break;
        case 'q': line =  2; break;
        case 'h': line =  3; break;
        case 'c': line =  4; break;
        case 'p': line =  5; break;
        case 'b': line =  6; break;
        case 'l': line =  7; break;
        case 'r': line =  8; break;
        case 'n': line =  9; break;
        case 'g': line = 10; break;
        case 'k': line = 11; break;
        case 'f': line = 12; break;
        default: break;
      } // switch( grab )

      if( line == -1 )
      { continue;
      }
      else
      {
        // if we haven't grabbed an item yet...
        if( grabbed.sym.ch == '\0' )
        {
          // ...confirm the slot is not empty...
          if( u.inventory.items[line].sym.ch == '\0' )
          {
            display_equipment_screen( u, -1, "There is no item there." );
            line = -1;
          }
          else
          {
            // ...grab the item...
            grabbed = u.inventory.items[line];
            display_equipment_screen( u, line );

            // ...and save that line so we can swap the items later.
            grabbed_line = line;
          }
        } /* if( grabbed.sym.ch == '\0' ) */
        // if we have already grabbed an item...
        else
        {
          bool confirm_swap = false;
          // ...check to see if the player can equip the item in this slot
          switch( line )
          {
            case INVENT_HELMET:
              if( grabbed.type & ITEM_WEAPON )
              {
                // Don't use `display_equipment_screen` here because we need
                // to be able to format this message and we're going to end up
                // quitting the equipment screen immediately anyway.
                put_line( 21, 1,
                  "You stab yourself in the head with a %s and die instantly.",
                  grabbed.name );
seppuku:
                  refresh_screen();
                  get_key();
                  u.hp = 0;
                  return 0;
              }
            goto case INVENT_CUIRASS;
            // fall through to next case
            case INVENT_CUIRASS:
              if( grabbed.type & ITEM_WEAPON )
              {
                // See above comment at `case INVENT_HELMET` for why we're not
                // using `display_equipment_screen`
                put_line( 21, 1,
                  "You slice into your gut with a %s and commit seppuku.",
                  grabbed.name );
                  goto seppuku;
              }
              goto default;
              // fall through to next case
            default:
              // confirm the player can swap this item to this slot
              confirm_swap = check_equip( grabbed, line );
              break;
          } /* switch( line ) */
  
          if( !confirm_swap )
          {
            // if we can't equip that item here, discard the swap
            display_equipment_screen( u, -1,
                      format( "You can not equip a %s there.", grabbed.name )
                    );
discard_swap:
            grabbed_line = -1;
            grabbed.sym.ch = '\0';
            //get_key();
            //refnow = true;
            continue;
          }
          else
          {
            // check again in the opposite direction
            if( !check_equip( u.inventory.items[line], grabbed_line ) )
            {
              display_equipment_screen( u, -1,
                format( "You can not swap the %s and the %s.",
                        u.inventory.items[line].name,
                        grabbed.name )
              );
              goto discard_swap;
            }
          }
          // ...swap the inventory items...
          u.inventory.items[grabbed_line] = u.inventory.items[line];
          // if the new slot is not empty, the player expends a turn moving
          // that item
          if( u.inventory.items[line].sym.ch != '\0' )
          { turns += 1;
          }
          u.inventory.items[line] = grabbed;
          // ...remove the grabbed item...
          grabbed.sym.ch = '\0';
          grabbed_line = line = -1;
          // ...clear the screen...
          clear_screen();
          // ...and make a note to refresh the inventory screen.
          refnow = true;
  
          // the player expends a turn moving an inventory item
          turns += 1;
        } /* if( grabbed.sym.ch != '\0' ) */
      } /* if( line != -1 ) */
    } while( grab != 'Q' && grab != ' ' );
  
    return turns;
  } // uint manage_equipment( Player* )

  deprecated("control_inventory has been superceded by manage_equipment to prevent ambiguity.  Please use this function instead.")
  final uint control_inventory( Player* u )
  {
    return manage_equipment( u );
  }

  /++
   + Prints a `string` at the given coordinates
   +
   + This function has essentially the same function as `put_char`, except
   + that it works to print a string.  It also doesn't take in a color value,
   + as this is not the intended use of the function.
   +
   + Params:
   +   y    = The y coordinate to print the message at
   +   x    = The x coordinate to print the message at
   +   args = Format arguments from which the message is generated
   +/
  final void put_line( T... )( uint y, uint x, T args )
  {
    import std.string: format;
    string output = format( args );

    foreach( c; 0 .. cast(uint)output.length )
    { put_char( y, x + c, output[c] );
    }
  }

  /// Displays the "help" screen and waits for the player to clear it
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

  /++
   + Uses `display` to draw the player
   +
   + This function doesn't require coordinate inputs, because the `Player`
   + struct contains its own coordinates.
   +
   + See_Also:
   +   <a href="#SwashIO.display">display</a>
   +
   + Params:
   +   u = The `Player` to be displayed
   +/
  final void display_player( Player u )
  {
    // if the player is wearing a "festive hat," display them in a special
    // color
    if( u.inventory.items[INVENT_HELMET].name == "festive hat" )
    {
      // get the foreground color of the hat...
      uint hat_fg = u.inventory.items[INVENT_HELMET].sym.color.fg;
      // make an inverted version of the hat's color...
      Color hat_color = Color( hat_fg, true );
      // same as the original display function, but with the new hat color
      display( u.y + 1, u.x, symdata( u.sym.ch, hat_color ), true );
    }
    else  display( u.y + 1, u.x, u.sym, true );
  }

  /++
   + Uses `display` to draw the given monster
   +
   + This function doesn't require coordinate inputs, because the `Monst`
   + struct contains its own coordinates.
   +
   + <b>Note</b>:  This function <em>can not</em> check field-of-vision.
   +
   + See_Also:
   +   <a href="#SwashIO.display">display</a>
   +
   + Params:
   +   m = The `Monst` to be displayed
   +/
  final void display_mon( Monst m )
  { display( m.y + 1, m.x, m.sym );
  }

  /++
   + Uses `display_mon` to display all monsters on the given map
   +
   + This function gets all of the monsters from the input `map` and draws
   + <em>all of them</em>.
   +
   + Monsters that are not within the field-of-vision are not displayed.
   +
   + See_Also:
   +   <a href="#SwashIO.display">display</a>,
   +   <a href="#SwashIO.display_mon">display_mon</a>
   +
   + Params:
   +   to_display = The map whose monsters we want to display
   +/
  final void display_map_mons( Map to_display )
  {
    size_t d = to_display.m.length;
    Monst mn;
    foreach( c; 0 .. d )
    {
      mn = to_display.m[c];

      if( No_shadows || to_display.v[mn.y][mn.x] )
      { display_mon( mn );
      }

    } /* foreach( c; 0 .. d ) */
  }

  /++
   + Uses `display` to draw all of the map tiles and items on the given map
   +
   + Color values and coordinates are taken from the `Map` struct that is
   + passed into this function.
   +
   + Map tiles and items which are outside the field-of-view are not
   + displayed, but map tiles which have already been seen by the player will
   + be displayed with a shadow.
   +
   + See_Also:
   +   <a href="#SwashIO.display">display</a>
   +
   + Params:
   +   to_display = The map from which map `Tile`s and `Item`s are to be
   +                displayed
   +/
  final void display_map( Map to_display )
  {
    foreach( y; 0 .. MAP_Y )
    {
      foreach( x; 0 .. MAP_X )
      {
        Symbol output = to_display.t[y][x].sym;

static if( COLOR )
{
 static if( FOLIAGE )
 {
          // If there is mold growing on this tile, change the tile's color
          // to green (unless there's also water)
          if( to_display.t[y][x].hazard & SPECIAL_MOLD )
          {
            if( !(to_display.t[y][x].hazard & HAZARD_WATER ) )
            {
              output.color.fg = CLR_GREEN;
            }
          }
  }
 static if( BLOOD )
 {
          // If there is blood spattered on this tile, change the tile's
          // color to red (unless there's also water?)
          if( to_display.t[y][x].hazard & SPECIAL_BLOOD )
          {
            if( !(to_display.t[y][x].hazard & HAZARD_WATER) )
            {
              output.color.fg = CLR_RED;
            }
          }
 }
} // static if( COLOR )

        if( to_display.i[y][x].sym.ch != '\0' )
        { output = to_display.i[y][x].sym;
        }

        if( !No_shadows && !to_display.v[y][x] )
        {
static if( !COLOR )
          output = SYM_SHADOW;
else
{
          if( to_display.t[y][x].seen )
          {
            output.color.fg = CLR_DARKGRAY; 
          }
          else
          {
            output = SYM_SHADOW;
          }
}
        }

        display( y + 1, x, output );
      } /* foreach( x; 0 .. MAP_X ) */
    } /* foreach( y; 0 .. MAP_Y ) */
  }

  /++
   + Uses `display_map` and `display_map_mons` to display all map tiles,
   + items, and monsters.
   +
   + See_Also:
   +   <a href="#SwashIO.display_map">display_map</a>,
   +   <a href="#SwashIO.display_map_mons">display_map_mons</a>
   +
   + Params:
   +   to_display = The map from which the monsters, tiles, and items are
   +                taken to be displayed
   +/
  final void display_map_all( Map to_display )
  {
    display_map( to_display );
    display_map_mons( to_display );
  }

  /++
   + Uses `display_map_all` and `display_player` to draw the full display
   + including the map, items, monsters, and player
   +
   + See_Also:
   +   <a href="#SwashIO.display_map_all">display_map_all</a>,
   +   <a href="#SwashIO.display_player">display_player</a>
   +
   + Params:
   +   to_display = The map from which the monsters, tiles, and items are
   +                taken to be displayed
   +   u          = The `player` character to be displayed
   +/
  final void display_map_and_player( Map to_display, Player u )
  {
    display_map_all( to_display );
    display_player( u );
  }

  /++
   + Displays the equipment screen
   +
   + This is the key function used to display the equipment screen.  It draws
   + The screen as a list of slots each marked with a letter indicating which
   + key the player should push in order to interact with that equipment slot.
   +
   + If `grabbed` is given as a non-negative integer, that line will be marked
   + as having been "grabbed" by the player, usually for the purposes of
   + moving it to a new inventory slot or swapping two items.
   +
   + If `msg` is given as a non-empty string, that message will be displayed
   + below the equipment screen.  This is normally done for error messages
   + such as "there is no item there" or "you can not equip a %s there."  Note
   + that this function will not format `msg` for you; if formatting must be
   + done, it must be done before the string is passed into this function.
   +
   + See_Also: SwashIO.display_inventory
   +
   + Params:
   +   u       A pointer to the `Player` whose inventory we are displaying.
   +   grabbed An integer indicating which equipment slot has been "grabbed"
   +           by the player prior to the screen being drawn.
   +   msg     A message to be displayed to the player after drawing the
   +           equipment screen.
   +/
  final void display_equipment_screen( Player* u, int grabbed = -1,
                                       string msg = "" )
  {

    clear_screen();

    string snam; // the name of the slot
    char   schr; // the character that represents the slot

    foreach( count; 0 .. INVENT_LAST_SLOT )
    {
      // This switch statement of doom sets up the name and selection
      // button for each inventory slot
      switch( count )
      {
        default: snam = "bag"; schr = '\0'; break;
  
        case INVENT_WEAPON:    snam = "Weapon-hand";    schr = 'w'; break;
        case INVENT_OFFHAND:   snam = "Off-hand";       schr = 'o'; break;
        case INVENT_QUIVER:    snam = "Quiver";         schr = 'q'; break;
        case INVENT_HELMET:    snam = "Helmet";         schr = 'h'; break;
        case INVENT_CUIRASS:   snam = "Cuirass";        schr = 'c'; break;
        case INVENT_PAULDRONS: snam = "Pauldrons";      schr = 'p'; break;
        case INVENT_BRACERS:   snam = "Bracers/gloves"; schr = 'b'; break;
        case INVENT_RINGL:     snam = "Left ring";      schr = 'l'; break;
        case INVENT_RINGR:     snam = "Right ring";     schr = 'r'; break;
        case INVENT_NECKLACE:  snam = "Necklace";       schr = 'n'; break;
        case INVENT_GREAVES:   snam = "Greaves";        schr = 'g'; break;
        case INVENT_KILT:      snam = "Kilt/skirt";     schr = 'k'; break;
        case INVENT_FEET:      snam = "Feet";           schr = 'f'; break;
        case INVENT_TAIL:      snam = "Tailsheath";     schr = 't'; break;
      } // switch( count )

      if( schr == '\0' )
      { break;
      }

      put_line( 1 + count, 1, "         %c) %s: %s", schr, snam,
                u.inventory.items[count].sym.ch == '\0'
                  ? "EMPTY" : u.inventory.items[count].name
              );
    } /* foreach( count; 0 .. INVENT_LAST_SLOT ) */

    put_line( 16, 1, "i) Bag" );

    if( grabbed <= -1 )
    {
      put_line( 18, 1, "Press a letter to \"grab\" that item" );
      put_line( 19, 1, "or \'i\' to take an item out of your bag" );
    }
    else
    {
      put_line( grabbed + 1, 1, "GRABBED:" );
      put_line( 18, 1,
        "Press a letter to move the grabbed item into a new equipment slot" );
      put_line( 19, 1, "or \'i\' to put it in your bag" );
    }

    put_line( 20, 1, "Press \'Q\' or SPACE to exit this screen" );

    if( msg != "" )  put_line( 22, 1, msg );
  
    refresh_screen();

  } // final void display_equipment_screen( Player*(, int, string) )

  /++
   + Displays the inventory screen
   +
   + This function displays the player's inventory screen by placing each
   + `Item` in the "bag slots" of its `Inventory` on a line with a character
   + next to it to indicate what key the user should press to interact with
   + that item.
   +
   + The inventory is not to be confused with the equipment screen.
   +
   + See_Also: SwashIO.display_equipment_screen
   +
   + Params:
   +  u  A pointer to the `Player` whose inventory is being displayed.
   +/
  final void display_inventory( Player* u )
  {

    clear_screen();

    // The symbol of the current item
    char slot_char = 'a';

    foreach( slot_index; 0 .. 24 )
    {
      // Inform the player of each item, up to 24 (one per line)
      if( Item_here( u.inventory.items[INVENT_BAG + slot_index] ) )
      {
        put_line( slot_index, 0, "%c) %s", slot_char,
            u.inventory.items[INVENT_BAG + slot_index].name );
        slot_char++;
      }
      else break;
    }

    refresh_screen();

  } // final void display_inventory( Player* )

} // interface SwashIO

// Import the classes which expand on this template depending on what display
// outputs have been compiled:

version( curses )
{ import iocurses; /* display interface for curses */
}

version( sdl )
{ import ioterm; /* display interface for sdl terminal */
}
