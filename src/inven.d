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

// defines the `inven' struct, used for inventories

/++
 + The inventory
 +
 + This struct defines an inventory.  It contains an array of 40 `item`s (14
 + for equipment slots followed by 26 more for a "bag"), a counter for the
 + number of items in the quiver (`quiver_count`), and the number of `coins`
 + in the inventory.
 +/
struct inven
{
  // all `items' carried in this inventory; 14 "inventory slots" for the
  // various body parts, plus 26 for the "bag" (to be implemented)
  item[40] items; 
  ubyte quiver_count;
  ubyte coins;
}

// Special array indeces in the `items' array which correspond to the
// specific inventory slots seen on the inventory screen
enum INVENT_WEAPON    =  0;
enum INVENT_OFFHAND   =  1;
enum INVENT_QUIVER    =  2;
enum INVENT_HELMET    =  3;
enum INVENT_CUIRASS   =  4;
enum INVENT_PAULDRONS =  5;
enum INVENT_BRACERS   =  6;
enum INVENT_RINGL     =  7;
enum INVENT_RINGR     =  8;
enum INVENT_NECKLACE  =  9;
enum INVENT_GREAVES   = 10;
enum INVENT_KILT      = 11;
enum INVENT_FEET      = 12;
enum INVENT_TAIL      = 13;

enum INVENT_LAST_SLOT = INVENT_TAIL;

/++
 + Checks a given item against a given inventory equipment slot
 +
 + This function checks the given item `i`'s equipment type against a given
 + equipment slot `s`.  The function returns `true` if the item can go in the
 + given inventory slot.
 +
 + The function will always return `true` if `s` represents one of the
 + character's hands (`INVENT_WEAPON` for the "weapon-hand" or
 + `INVENT_OFFHAND` for the "off-hand"), because any item can be carried in
 + one's hands.
 +
 + Params:
 +   i = an `item` to be checked
 +   s = the index of the equipment slot to be checked
 +
 + Returns:
 +   `true` if i can be equipped in equipment slot s, `false` otherwise
 +/
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

void get_inv_slot_name( string* nam, char* ch, ubyte slot );
