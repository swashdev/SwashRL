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
      return cast(bool)i.type & ITEM_WEAPON_MISSILE;

    case INVENT_HELMET:
      return cast(bool)i.equip & EQUIP_HELMET;

    case INVENT_CUIRASS:
      // the "cuirass" item slot can accept either cuirasses or shields (the
      // player straps a shield to their back)
      return (i.equip & EQUIP_CUIRASS) || (i.equip & EQUIP_SHIELD);

    case INVENT_PAULDRONS:
      return cast(bool)i.equip & EQUIP_PAULDRONS;

    case INVENT_BRACERS:
      return cast(bool)i.equip & EQUIP_BRACERS;

    case INVENT_RINGL:
      // rings are obviously ambidexterous
    case INVENT_RINGR:
      return cast(bool)i.equip & EQUIP_JEWELERY_RING;

    case INVENT_NECKLACE:
      return cast(bool)i.equip & EQUIP_JEWELERY_NECK;

    case INVENT_GREAVES:
      return cast(bool)i.equip & EQUIP_GREAVES;

    case INVENT_KILT:
      return cast(bool)i.equip & EQUIP_KILT;

    case INVENT_FEET:
      return cast(bool)i.equip & EQUIP_FEET;

    case INVENT_TAIL:
      return cast(bool)i.equip & EQUIP_TAIL;

    default:
      return false;
  }
}
