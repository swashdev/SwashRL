/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */

import global;

bool upickup( player* u, item i )
{
  if( i.sym.ch == '\0' )
  {
    message( "There is nothing here to pick up." );
    return false;
  }

  // TODO: These three `if' statements can be condensed down to two.  Figure
  // out how and git 'r' done.
  if( i.type & ITEM_WEAPON
      && u.inventory.items[INVENT_WEAPON].sym.ch == '\0' )
  {
    message( "You pick up a %s in your weapon-hand.",
             i.name );
    u.inventory.items[INVENT_WEAPON] = i;
    return true;
  }

  if( u.inventory.items[INVENT_OFFHAND].sym.ch == '\0' )
  {
    message( "You pick up a %s in your off-hand.",
             i.name );
    u.inventory.items[INVENT_OFFHAND] = i;
    return true;
  }
  else if( u.inventory.items[INVENT_WEAPON].sym.ch == '\0' )
  {
    message( "You pick up a %s in your weapon-hand.",
             i.name );
    u.inventory.items[INVENT_WEAPON] = i;
    return true;
  }
  else
  { message( "You do not have a free grasp." );
  }

  return false;
}

bool check_equip( item i, ubyte s )
{
  // an empty item can go in any slot (obviously)
  if( i.sym.ch == '\0' )
  { return true;
  }
  // the player can hold any item in their hands
  if( s == INVENT_WEAPON || s == INVENT_OFFHAND )
  { return true;
  }

  // everything else goes into the switch statement
  switch( s )
  {
    case INVENT_QUIVER:
      return i.type & ITEM_WEAPON_MISSILE;

    case INVENT_HELMET:
      return i.equip & EQUIP_HELMET;
    case INVENT_CUIRASS:
      // the "cuirass" item slot can accept either cuirasses or shields (the
      // player straps a shield to their back)
      return (i.equip & EQUIP_CUIRASS) || (i.equip & EQUIP_SHIELD);
    case INVENT_PAULDRONS:
      return i.equip & EQUIP_PAULDRONS;
    case INVENT_BRACERS:
      return i.equip & EQUIP_BRACERS;
    case INVENT_RINGL:
      // rings are obviously ambidexterous
    case INVENT_RINGR:
      return i.equip & EQUIP_JEWELERY_RING;
    case INVENT_NECKLACE:
      return i.equip & EQUIP_JEWELERY_NECK;
    case INVENT_GREAVES:
      return i.equip & EQUIP_GREAVES;
    case INVENT_KILT:
      return i.equip & EQUIP_KILT;
    case INVENT_FEET:
      return i.equip & EQUIP_FEET;
    case INVENT_TAIL:
      return i.equip & EQUIP_TAIL;
  }
  return false;
}

uint uinventory( player* u )
{
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
    ubyte count;
    string  snam; // "slot name"
    char schr; // "slot character"
    if( refnow )
    {
      refnow = 0;

      /* clear the screen */
      clear();

      for( count = 0; count <= INVENT_LAST_SLOT - 1; count++ )
      {
        // This switch statement of doom sets up the name and selection button
        // for each inventory slot
        switch( count )
        {
          default: snam = "bag"; schr = '\0'; break;

          case INVENT_WEAPON:    snam = "Weapon-hand";    schr = 'w'; break;
          case INVENT_OFFHAND:   snam = "Off-hand"; /* */ schr = 'o'; break;
          case INVENT_QUIVER:    snam = "Quiver"; /* * */ schr = 'q'; break;
          case INVENT_HELMET:    snam = "Helmet"; /* * */ schr = 'h'; break;
          case INVENT_CUIRASS:   snam = "Cuirass";        schr = 'c'; break;
          case INVENT_PAULDRONS: snam = "Pauldrons";      schr = 'p'; break;
          case INVENT_BRACERS:   snam = "Bracers/gloves"; schr = 'b'; break;
          case INVENT_RINGL:     snam = "Left ring";      schr = 'l'; break;
          case INVENT_RINGR:     snam = "Right ring";     schr = 'r'; break;
          case INVENT_NECKLACE:  snam = "Necklace";       schr = 'n'; break;
          case INVENT_GREAVES:   snam = "Greaves";        schr = 'g'; break;
          case INVENT_KILT:      snam = "Kilt/skirt";     schr = 'k'; break;
          case INVENT_FEET:      snam = "Feet"; /* * * */ schr = 'f'; break;
          case INVENT_TAIL:      snam = "Tailsheath";     schr = 't'; break;
        } /* switch( count ) */

        if( schr == '\0' )
        { break;
        }

        mvprintw( 1 + count, 1, "%c) %s: %s", schr, snam,
                  u.inventory.items[count].sym.ch == '\0'
                    ? "EMPTY" : u.inventory.items[count].name
                );
      } /* for( count ) */

      mvprintw( 16, 1, "i) Bag [NOT IMPLEMENTED]" );

      // this line is here to clear error messages
      for( count = 1; count < 79; count++ )
      { mvaddch( 21, count, ' ' );
      }

      mvprintw( 18, 1,
        "Press a letter to \"grab\" that item (or \'i\' to open your bag)" );
      mvprintw( 19, 1, "Press \'Q\' or SPACE to exit this screen" );

      refresh();

    } /* if( refnow ) */

    // grab an item
    grab = getch();
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
          mvchgat( 1 + line, 1, 78, A_REVERSE, 0, 0 );
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
                grabbed.name );
seppuku:
                getch();
                u.hp = 0;
                return 0;
            }
            // fall through to next case
          case INVENT_CUIRASS:
            if( grabbed.type & ITEM_WEAPON )
            {
              mvprintw( 21, 1,
                "You slice into your gut with a %s and commit seppuku.",
                grabbed.name );
                goto seppuku;
            }
            // fall through to next case
          default:
            // confirm the player can swap this item to this slot
            confirm_swap = check_equip( grabbed, line );
            break;
        } /* switch( line ) */

        if( !confirm_swap )
        {
          // if we can't equip that item here, discard the swap
          mvprintw( 21, 1, "You can not equip a %s there.", grabbed.name );
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
                      u.inventory.items[line].name, grabbed.name );
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
}
