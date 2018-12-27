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
  { display( u.y + 1, u.x, u.sym, true );
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

  ///////////////////////////////////////////////////////////////////////
  // The Inventory Screen                                              //
  // (this function goes at the bottom because it's easily the worst ) //
  ///////////////////////////////////////////////////////////////////////

  /++
   + Controls the inventory screen
   +
   + This function outputs the inventory screen and allows the player to
   + manipulate their inventory through it.
   +
   + The specific details of how this function works are actually somewhat
   + complicated and boring, but the jist of it is that each equipment slot
   + is associated with an array index, which is given a line and a letter
   + on the inventory screen.  When the player enters a key that matches that
   + letter, that array index is "grabbed," and a second keypress will place
   + that item on a new inventory slot, swapping it with a second item if
   + necessary.
   +
   + This function will also perform checks using the `check_equip` function
   + to ensure that the player does not place an inventory item on an
   + inappropriate slot; for example, wearing a cuirass as a helmet.
   +
   + <b>Note</b>:  This function displays an instruction for placing items in
   + the "bag," but the bag has not yet been implemented.
   +
   + <strong>This function can kill the player if they commit seppukku on the
   + inventory screen.</strong>
   +
   + Each time the player moves an inventory item from one equipment slot to
   + another, a turn passes in the game.  Swapping two inventory items is
   + counted as two turns.  The more items the player moves around, the more
   + turns they will skip after the inventory screen is closed.
   +
   + Params:
   +   u = The `Player` whose inventory is being controlled
   +
   + Returns:
   +   A number of turns, as a `uint`, to be passed to the mainloop which the
   +   player will skip after this function finishes.
   +/
  final uint control_inventory( Player* u )
  {
    import std.ascii: toLower;

    // the inventory slot letter the player has selected
    char grab = 0;
    // `line': the line corresponding to the `grab' slot letter
    // `grabbed_line': the line corresponding to an item that has been grabbed
    int line = 255, grabbed_line = 255;
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
      string  snam; // "slot name"
      char schr; // "slot character"
      if( refnow )
      {
        refnow = 0;
  
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

      // this line is here to clear error messages
      foreach( count; 1 .. 79 )
      { put_char( 21, count, ' ' );
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
          // The player has chosen to access an item in their bag
          // If the player already has an item selected, attempt to place that
          // item in the bag.
          if( grabbed_line != 255 )
          {
            // First we need to check if the bag is full.
            bool bag_full = true;
            size_t I = 0;
            for( I = 0; I < 24; I++ )
            {
              if( !Item_here( u.inventory.items[I + INVENT_LAST_SLOT + 1] ) )
              {
                bag_full = false;
                break;
              }
            }
            if( bag_full )
            {
              grabbed_line = 255;
              line = 255;
              put_line( 21, 1, "Your bag can not contain any more items." );
              break;
            }
            else
            {
              grabbed = u.inventory.items[grabbed_line];
              u.inventory.items[grabbed_line] = No_item;
              u.inventory.items[I + INVENT_LAST_SLOT + 1] = grabbed;
              grabbed = No_item;
              line = 255;
              grabbed_line = 255;
            }
          } /* if( grabbed_line != 255 ) */
          else
          {
            // If the player does not have a free grasp, let them know.
            if( !check_grasp( u.inventory ) )
            {
              put_line( 21, 1,
                     "You do not have a free grasp to reach into your bag." );
            }
            else
            {
              // Always refresh the screen after displaying the bag menu, since
              // we'll need to go back to the inventory slots screen afterwards
              refnow = true;
              // Clear the screen and display a new menu with the items in the
              // bag
              clear_screen();
              // `I_sym` will represent the character associated with the item
              // in the menu, i.e. the key that the player should press to
              // access that item.
              char I_sym = 'a';
              do
              {
                foreach( I; 0 .. 24 )
                {
                  // Inform the player of each item, up to 24 (one per line)
                  if( Item_here( u.inventory.items[INVENT_LAST_SLOT + 1 + I] ) )
                  {
                    put_line( I, 0, "%c) %s", I_sym,
                        u.inventory.items[INVENT_LAST_SLOT + 1 + I].name );
                    I_sym++;
                  }
                }
                refresh_screen();

                // From here on out `I_sym` doubles as a little cheat letting
                // us know which character came last so we know which not to
                // accept.
                // In the meantime, `grab` will tell us which item has been
                // selected.
                grab = get_key();

                if( toLower( grab ) >= I_sym || grab < 'a' )
                { put_line( 0, 0, "You do not have that item..." );
                }
                else
                {
                  line = (grab - 'a') + INVENT_LAST_SLOT + 1;
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
                    if( !Item_here( u.inventory.items[I] ) )
                    { break;
                    }
                    else
                    {
                      u.inventory.items[I - 1] = u.inventory.items[I];
                      u.inventory.items[I] = No_item;
                    }
                  }
  
                  break;
                } /* else from if( toLower( grab ) >= I_sym || grab < 'a' ) */
              } while( grab != 'Q' && grab != ' ' );
            } /* else from if( !check_grasp( u.inventory ) ) */
          } /* else from if( grabbed_line != 255 ) */
          refnow = true;
          refresh_screen();
          line = 255;
          break; /* case 'i' */

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
          {
            put_line( 21, 1, "There is no item there." );
            refresh_screen();
          }
          else
          {
            // ...grab the item...
            grabbed = u.inventory.items[line];
            put_line( 1 + line, 1, "GRABBED:" );
// TODO: Figure out a way to genericize highlighting this line
version( none )
{
            // ...mark that line...
            mvchgat( 1 + line, 1, 78, A_REVERSE, cast(short)0, cast(void*)null );
}

            refresh_screen();

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
            grabbed_line = 255;
            grabbed.sym.ch = '\0';
            //get_key();
            refnow = true;
            continue;
          }
          else
          {
            // check again in the opposite direction
            if( !check_equip( u.inventory.items[line], grabbed_line ) )
            {
              put_line( 21, 1, "You can not swap the %s and the %s.",
                        u.inventory.items[line].name,
                        grabbed.name );
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
          grabbed_line = line = 255;
          // ...clear the screen...
          clear_screen();
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
