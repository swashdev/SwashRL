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

// inven.d: structures, functions, and constants related to inventory
// management

import global;

// SECTION 1: ////////////////////////////////////////////////////////////////
// The Inventory Structure                                                  //
//////////////////////////////////////////////////////////////////////////////

// A simple struct which defines an `Inven`tory.
struct Inven
{
  // all `Items' carried in this inventory; 14 "inventory slots" for the
  // various body parts, plus 26 for the "bag" (to be implemented)
  Item[40] items; 
  uint quiver_count;
  uint coins;
}

// Indexes of Equipment Slots ////////////////////////////////////////////////

// Special array indeces in the `items' array which correspond to the
// equipment slots seen on the equipment screen
// TODO: Mark these appropriately as equipment slots rather than inventory
// slots (maybe we should separate the equipment screen code from the
// inventory screen code?)
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

// Marks the last equipment slot:
enum INVENT_LAST_SLOT = INVENT_TAIL;

// Marks the first slot of the "bag":
enum INVENT_BAG = INVENT_LAST_SLOT + 1;

// SECTION 2: ////////////////////////////////////////////////////////////////
// Inventory Management Functions                                           //
//////////////////////////////////////////////////////////////////////////////

// Checks if the player or other monster has a free grasp.
// Note that this function doesn't require a monster, just its inventory.
bool check_grasp( Inven tory )
{
  return !Item_here( tory.items[INVENT_WEAPON] )
      || !Item_here( tory.items[INVENT_OFFHAND] );
}

// Checks if a given item fits into the given equipment slot (see iflags.d)
// TODO: See if you can move this to a more appropriate file like item.d
bool check_equip( Item i, uint s )
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
      return cast(bool)(i.type & ITEM_WEAPON_MISSILE);

    case INVENT_HELMET:
      return cast(bool)(i.equip & EQUIP_HELMET);

    case INVENT_CUIRASS:
      // the "cuirass" item slot can accept either cuirasses or shields (the
      // player straps a shield to their back)
      return cast(bool)(i.equip & EQUIP_CUIRASS) || cast(bool)(i.equip & EQUIP_SHIELD);

    case INVENT_PAULDRONS:
      return cast(bool)(i.equip & EQUIP_PAULDRONS);

    case INVENT_BRACERS:
      return cast(bool)(i.equip & EQUIP_BRACERS);

    case INVENT_RINGL:
      // rings are obviously ambidexterous
    case INVENT_RINGR:
      return cast(bool)(i.equip & EQUIP_JEWELERY_RING);

    case INVENT_NECKLACE:
      return cast(bool)(i.equip & EQUIP_JEWELERY_NECK);

    case INVENT_GREAVES:
      return cast(bool)(i.equip & EQUIP_GREAVES);

    case INVENT_KILT:
      return cast(bool)(i.equip & EQUIP_KILT);

    case INVENT_FEET:
      return cast(bool)(i.equip & EQUIP_FEET);

    case INVENT_TAIL:
      return cast(bool)(i.equip & EQUIP_TAIL);

    default:
      return false;
  }
}

void get_inv_slot_name( string* nam, char* ch, ubyte slot );
