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

// Defines functions related to program output (graphics, &c)

import global;

// This interface is the skeleton for all of the different display modes.
interface SwashIO
{

  /////////////////////
  // Setup & Cleanup //
  /////////////////////

  // Final clearing of the display before the game is closed
  void cleanup();

  ///////////
  // Input //
  ///////////

  // Gets a character input from the user and returns it
  char get_key();

  ////////////
  // Output //
  ////////////

  // Clears the screen
  void clear_screen();

  // Refreshes the screen to reflect the changes made by the below `display'
  // functions
  void refresh_screen();

  // Outputs a text character at the given coordinates.  If `reversed', the
  // foreground and background colors will be swapped.
  void put_char( uint y, uint x, char c, bool reversed = false );

  // The central `display' function.  Displays a given `symbol' at given
  // coordinates.  If `center', the cursor will be centered over the symbol
  // after drawing, rather than passing to the right of it like in a text
  // editor.
  void display( uint y, uint x, symbol s, bool center = true );

  // clears the current message off the message line
  void clear_message_line();

  /////////////////////
  // Final Functions //
  /////////////////////

  // Calls the input command and returns an integer representing a movement by
  // the player.
  final uint getcommand()
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

  } // int getcommand

  // Reads the player all of their messages one at a time
  final void read_messages()
  {
    while( !Messages.empty() )
    {
      clear_message_line();
      put_line( 0, 0, "%s%s", pop_message(),
                Messages.empty() == false ? "  (More)" : "" );
      refresh_screen();

      if( !Messages.empty() )
      { get_key();
      }
    }
  }
  final void put_line( T... )( uint y, uint x, T args )
  {
    import std.string: format;
    string output = format( args );

    foreach( c; 0 .. cast(uint)output.length )
    { put_char( y, x + c, output[c] );
    }
  }


  // Gives the player a menu containing their message history.
  final void read_message_history()
  {
    clear_screen();

    uint actual_c = 0;
    foreach( c; 0 .. Message_history.length )
    {
      if( actual_c > 23 )
      {
        refresh_screen();
        get_key();
        clear_screen();
        actual_c = 0;
      }

      put_line( actual_c, 0, Message_history[c] );

      actual_c++;
    }

    refresh_screen();
    get_key();
    clear_message_line();
  }

  // Refreshes the status bar
  final void refresh_status_bar( player* u )
  {
    int hp = u.hp;
    int dice = u.attack_roll.dice + u.inventory.items[INVENT_WEAPON].addd;
    int mod = u.attack_roll.modifier + u.inventory.items[INVENT_WEAPON].addm;

    foreach( x; 0 .. MAP_X )
    { put_char( 1 + MAP_Y, x, ' ' );
    }
    put_line( 1 + MAP_Y, 0, "HP: %d    Attack: %ud %c %u",
              hp, dice, mod >= 0 ? '+' : '-', mod * ((-1) * mod < 0) );
  }

  // Displays the "help" screen and waits for the player to clear it
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
    put_line(  9, 1, "i for inventory"               );
    put_line( 10, 1, ", to pick up an item"          );
    put_line( 11, 1, "P to read message history"     );
    put_line( 12, 1, "SPACE clears the message line" );

    put_line( 14, 1, "? this help screen"         );
    put_line( 15, 1, "Q Quit"                     );
    put_line( 16, 1, "v check the version number" );
    put_line( 17, 1, "@ change keyboard layout"   );

    put_line( 20, 1, "Press any key to continue..." );

    refresh_screen();

    // wait for the player to clear the screen
    get_key();
  } // void help_screen()

  // uses `display' to draw the given `player'
  final void display_player( player u )
  { display( u.y + 1, u.x, u.sym, true );
  }

  // uses `display' to draw the given `monst'er
  final void display_mon( monst m )
  { display( m.y + 1, m.x, m.sym );
  }

  // uses `display_mon' to draw all the `monst'ers on the given `map'
  final void display_map_mons( map to_display )
  {
    size_t d = to_display.m.length;
    monst mn;
    foreach( c; 0 .. d )
    {
      mn = to_display.m[c];

static if( USE_FOV )
{
     if( to_display.v[mn.y][mn.x] )
     { display_mon( mn );
     }
}
else
{
     display_mon( mn );
}

    } /* foreach( c; 0 .. d ) */
  }

  // uses `display' to draw all of the map 'tile's on the given `map'
  final void display_map( map to_display )
  {
    foreach( y; 0 .. MAP_Y )
    {
      foreach( x; 0 .. MAP_X )
      {
        symbol output = to_display.t[y][x].sym;

        if( to_display.i[y][x].sym.ch != '\0' )
        { output = to_display.i[y][x].sym;
        }

static if( USE_FOV )
{
        if( !to_display.v[y][x] )
        { output = SYM_SHADOW;
        }
} /* static if( USE_FOV ) */

        display( y + 1, x, output );
      } /* foreach( x; 0 .. MAP_X ) */
    } /* foreach( y; 0 .. MAP_Y ) */
  }

  // uses `display_map_mons' and `display_map' to draw the full `map'
  // including `monst'ers and `tile's
  final void display_map_all( map to_display )
  {
    display_map( to_display );
    display_map_mons( to_display );
  }

  // uses `display_map_all' and 'display_player' to draw the full `map' 
  // including `monst'ers, `tile's, and the given `player'
  final void display_map_and_player( map to_display, player u )
  {
    display_map_all( to_display );
    display_player( u );
  }

  ///////////////////////////////////////////////////////////////////////
  // The Inventory Screen                                              //
  // (this function goes at the bottom because it's easily the worst ) //
  ///////////////////////////////////////////////////////////////////////

  // Displays the `player's inventory and enables them to control it.  Returns
  // the number of turns the player spent on the inventory screen.
  final uint control_inventory( player* u )
  {
    import std.ascii: toLower;

    // the inventory slot letter the player has selected
    char grab = 0;
    // `line': the line corresponding to the `grab' slot letter
    // `grabbedline': the line corresponding to an item that has been grabbed
    ubyte line = 255, grabbedline = 255;
    // `grabbed': an item that has been grabbed
    item grabbed = No_item;
  
    // whether to refresh the inventory screen
    bool refnow = 1;

    // the number of turns that have passed...
    uint turns = 0;

    do
    {
      string  snam; // "slot name"
      char schr; // "slot character"
      if( refnow )
      {
        refnow = 0;
  
        /* clear the screen */
        clear_screen();

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

          put_line( 1 + count, 1, "%c) %s: %s", schr, snam,
                    u.inventory.items[count].sym.ch == '\0'
                      ? "EMPTY" : u.inventory.items[count].name
                  );
        } /* foreach( count; 0 .. INVENT_LAST_SLOT ) */

        put_line( 16, 1, "i) Bag [NOT IMPLEMENTED]" );

        // this line is here to clear error messages
        foreach( count; 1 .. 79 )
        { put_char( 21, count, ' ' );
        }

        put_line( 18, 1,
          "Press a letter to \"grab\" that item (or \'i\' to open your bag)" );
        put_line( 19, 1, "Press \'Q\' or SPACE to exit this screen" );
  
        refresh_screen();

      } /* if( refnow ) */

      // grab an item
      grab = get_key();
      if( grab == 'Q' || grab == ' ' )
      { break;
      }
      grab = toLower( grab );
      switch( grab )
      {
        case 't':
          put_line( 21, 1, "You do not have a tail." );
          refresh_screen();
          line = 255;
          break;
        case 'i':
          put_line( 21, 1, "The bag has not yet been implemented." );
          refresh_screen();
          line = 255;
          break;

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

      if( line == 255 )
      { continue;
      }
      else
      {
        // if we haven't grabbed an item yet...
        if( grabbed.sym.ch == '\0' )
        {
          // ...confirm the slot is not empty...
          if( u.inventory.items[line].sym.ch == '\0' )
          { put_line( 21, 1, "There is no item there." );
          }
          else
          {
            // ...grab the item...
            grabbed = u.inventory.items[line];
// TODO: Figure out a way to genericize highlighting this line
version( none )
{
            // ...mark that line...
            mvchgat( 1 + line, 1, 78, A_REVERSE, cast(short)0, cast(void*)null );
}
            // ...and save that line so we can swap the items later.
            grabbedline = line;
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
                put_line( 21, 1,
                  "You stab yourself in the head with a %s and die instantly.",
                  grabbed.name );
seppuku:
                  get_key();
                  u.hp = 0;
                  return 0;
              }
            goto case INVENT_CUIRASS;
            // fall through to next case
            case INVENT_CUIRASS:
              if( grabbed.type & ITEM_WEAPON )
              {
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
            put_line( 21, 1, "You can not equip a %s there.",
                      grabbed.name );
discard_swap:
            grabbedline = line = 255;
            grabbed.sym.ch = '\0';
            refnow = true;
            continue;
          }
          else
          {
            // check again in the opposite direction
            if( !check_equip( u.inventory.items[line], grabbedline ) )
            {
              put_line( 21, 1, "You can not swap the %s and the %s.",
                        u.inventory.items[line].name,
                        grabbed.name );
              goto discard_swap;
            }
          }
          // ...swap the inventory items...
          u.inventory.items[grabbedline] = u.inventory.items[line];
          // if the new slot is not empty, the player expends a turn moving
          // that item
          if( u.inventory.items[line].sym.ch != '\0' )
          { turns += 1;
          }
          u.inventory.items[line] = grabbed;
          // ...remove the grabbed item...
          grabbed.sym.ch = '\0';
          grabbedline = line = 255;
          // ...and make a note to refresh the inventory screen.
          refnow = true;
  
          // the player expends a turn moving an inventory item
          turns += 1;
        } /* if( grabbed.sym.ch != '\0' ) */
      } /* if( line != 255 ) */
    } while( grab != 'Q' && grab != ' ' );
  
    return turns;
  } // uint control_inventory

} // interface SpelunkIO

// Import the classes which expand on this template depending on what display
// outputs have been compiled:

version( curses )
{ import iocurses; /* display interface for curses */
}

version( sdl )
{ import ioterm; /* display interface for sdl terminal */
}
