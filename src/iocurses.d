/*
 * Copyright (c) 2016-2018 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */

// Defines the interface for functions related to program output for the
// curses interface.

version( curses )
{

import global;

// This class contains functions for the curses display
// These functions should all be cross-compatible between pdcurses and ncurses
// since they don't do anything fancy or complicated.
class CursesIO : SpelunkIO
{

  ushort display_x = 80;
  ushort display_y = 24;

  //////////////////
  // Constructors //
  //////////////////

  this()
  {
    // Initializing curses
    initscr();
    // pass raw input directly to curses
    raw();
    // do not echo user input
    noecho();
    // enable the keypad and function keys
    keypad( stdscr, 1 );
  }
  this( uint screen_size_vertical, uint screen_size_horizontal )
  {
    display_x = screen_size_horizontal;
    display_y = screen_size_vertical;
    super();
  }

  /////////////////////
  // Setup & Cleanup //
  /////////////////////

  void cleanup()
  {
    getch();
    endwin();
  }

  ///////////
  // Input //
  ///////////

  int getcommand( bool alt_hjkl )
  {
    char c = cast(char)getch();
    switch( c )
    {
      case 'y':
      case '7':
      case KEY_HOME:
        return MOVE_NW;

      case 'k':
      case '8':
      case KEY_UP:
        return MOVE_NN;
      case 'u':
      case '9':
      case KEY_PPAGE: // pgup
        return MOVE_NE;
      case 'l':
      case '6':
      case KEY_RIGHT:
        return MOVE_EE;
      case 'n':
      case '3':
      case KEY_NPAGE: // pgdn
        return MOVE_SE;
      case 'j':
      case '2':
      case KEY_DOWN: // numpad "down"
        return MOVE_SS;
      case 'b':
      case '1':
      case KEY_END:
        return MOVE_SW;
      case 'h':
      case '4':
      case KEY_LEFT:
        return MOVE_WW;
      case MV_WT:
      case NP_WT:
        return MOVE_WAIT;

version( Windows )
{
    // numpad controls (Windows-specific)
      case KEY_A1:
        return MOVE_NW;
      case KEY_A2:
        return MOVE_NN;
      case KEY_A3:
        return MOVE_NE;
      case KEY_B1:
        return MOVE_WW;
      case KEY_B2:
        return MOVE_WAIT;
      case KEY_B3:
        return MOVE_EE;
      case KEY_C1:
        return MOVE_SW;
      case KEY_C2:
        return MOVE_SS;
      case KEY_C3:
        return MOVE_SE;
} /* version( Windows ) */

      case 'i':
        return MOVE_INVENTORY;

      case KY_GET:
        return MOVE_GET;

      case KY_MESS:
        return MOVE_MESS_DISPLAY;
      case KY_CLEAR:
        return MOVE_MESS_CLEAR;

      case KY_QUIT:
        return MOVE_QUIT;

      case 'v':
      case KY_VERSION:
        return MOVE_GETVERSION;

      default:
      case KY_HELP:
        return MOVE_HELP;
    }
  } /* int getcommand */

  void read_messages()
  {
    while( Buffered_messages > 0 )
    {
      clear_message_line(); // from display.h
      mvprintw( 0, 0, "%s%s", toStringz(pop_message()),
                toStringz(Buffered_messages > 1 ? "  (More)" : "") );
      refresh();
      if( Buffered_messages > 0 )
      { getch();
      }
    }
  }

  void read_message_history()
  {
    import std.string: toStringz;

    clear();
    ubyte n = 0;
    foreach( m; 0 .. Messages.length )
    {
      mvprintw( n, 0, toStringz(Messages[m]) );
      if( m % MAX_MESSAGE_BUFFER == 20 )
      {
        refresh();
        getch();
        clear();
        n = 0;
      }
      else
      { n++;
      }
    }
    refresh();
    getch();
    clear_message_line();
  }

  ////////////
  // Output //
  ////////////

  void refresh_screen()
  { refresh();
  }

  void display( uint y, uint x, symbol s, bool center = false )
  {
    mvaddch( y, x, s.ch );

static if( TEXT_EFFECTS )
{
    mvchgat( y, x, 1, s.color, cast(short)0, cast(void*)null );
}

    if( !center )
    { move( y, x + 1 );
    }
  }

  void clear_message_line()
  {
    foreach( y; 0 .. MESSAGE_BUFFER_LINES )
    {
      foreach( x; 0 .. MAP_X )
      { display( y, x, symdata( ' ', A_NORMAL ) );
      }
    }
  }

  void refresh_status_bar( player* u )
  {
    int hp = u.hp;
    int dice = u.attack_roll.dice + u.inventory.items[INVENT_WEAPON].addd;
    int mod = u.attack_roll.modifier + u.inventory.items[INVENT_WEAPON].addm;

    foreach( x; 0 .. MAP_X )
    { mvaddch( 1 + MAP_Y, x, ' ', 0 );
    }
    mvprintw( 1 + MAP_Y, 0, "HP: %d    Attack: %ud %c %u",
              hp, dice, mod >= 0 ? '+' : '-', mod * ((-1) * mod < 0) );
  }

  ///////////////////////////////////////////////////////////////////////
  // The Inventory Screen                                              //
  // (this function goes at the bottom because it's easily the worst ) //
  ///////////////////////////////////////////////////////////////////////

  uint control_inventory( player* u )
  {
    import std.string: toStringz;
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
        clear();
  
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
          } /* switch( count ) */

          if( schr == '\0' )
          { break;
          }

          mvprintw( 1 + count, 1, "%c) %s: %s", schr, toStringz(snam),
                    toStringz(u.inventory.items[count].sym.ch == '\0'
                      ? "EMPTY" : u.inventory.items[count].name
                  ));
        } /* foreach( count; 0 .. INVENT_LAST_SLOT ) */

        mvprintw( 16, 1, "i) Bag [NOT IMPLEMENTED]" );

        // this line is here to clear error messages
        foreach( count; 1 .. 79 )
        { mvaddch( 21, count, ' ' );
        }

        mvprintw( 18, 1,
          "Press a letter to \"grab\" that item (or \'i\' to open your bag)" );
        mvprintw( 19, 1, "Press \'Q\' or SPACE to exit this screen" );
  
        refresh();

      } /* if( refnow ) */

      // grab an item
      grab = cast(char)getch();
      if( grab == 'Q' || grab == ' ' )
      { break;
      }
      grab = toLower( grab );
      switch( grab )
      {
        case 't':
          mvprintw( 21, 1, "You do not have a tail." );
          refresh();
          line = 255;
          break;
        case 'i':
          mvprintw( 21, 1, "The bag has not yet been implemented." );
          refresh();
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
      } /* switch( grab ) */

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
          { mvprintw( 21, 1, "There is no item there." );
          }
          else
          {
            // ...grab the item...
            grabbed = u.inventory.items[line];
            // ...mark that line...
            mvchgat( 1 + line, 1, 78, A_REVERSE, cast(short)0, cast(void*)null );
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
                mvprintw( 21, 1,
                  "You stab yourself in the head with a %s and die instantly.",
                  toStringz(grabbed.name) );
seppuku:
                  getch();
                  u.hp = 0;
                  return 0;
              }
            goto case INVENT_CUIRASS;
            // fall through to next case
            case INVENT_CUIRASS:
              if( grabbed.type & ITEM_WEAPON )
              {
                mvprintw( 21, 1,
                  "You slice into your gut with a %s and commit seppuku.",
                  toStringz(grabbed.name) );
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
            mvprintw( 21, 1, "You can not equip a %s there.",
                      toStringz( grabbed.name ) );
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
              mvprintw( 21, 1, "You can not swap the %s and the %s.",
                        toStringz( u.inventory.items[line].name ),
                        toStringz( grabbed.name ) );
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
  } /* uint control_inventory */

} /* class CursesDisplay */

} /* version( curses ) */
