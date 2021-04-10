/*
 * Copyright (c) 2017-2021 Philip Pavlick.  See '3rdparty.txt' for other
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
// Inventory Management Functions                                           //
//////////////////////////////////////////////////////////////////////////////

// Initializes an empty inventory
Item[] init_inven( size_t size = 24 )
{
    Item[] items;
    items.length = size;
    foreach( count; 0 .. size )
    {
        items[count] = No_item;
    }

    return items;
}

// Initializes an empty wallet.
Item[5] init_wallet()
{
    Item[5] wallet;
    foreach( count; 0 .. wallet.length )
    {
        wallet[count] = No_item;
    }

    return wallet;
}

// Checks if the monster has an item in the given equipment slot.
bool item_in_slot( Monst mon, Slot slot )
{
    if( slot in mon.equipment )
    {
        return Item_here( mon.equipment[slot] );
    }

    return false;
}

// Returns an item from the given equipment slot in a monster's inventory.
Item get_equipment( Monst mon, Slot slot )
{
    if( item_in_slot( mon, slot ) )
    {
        return mon.equipment[slot];
    }

    return No_item;
}

// Checks if the player or other monster has a free grasp.
bool has_free_grasp( Monst mon )
{
    return !item_in_slot( mon, Slot.weapon_hand )
        || !item_in_slot( mon, Slot.off_hand );
}

// Checks if a given item fits into the given equipment slot (see iflags.d)
bool can_equip_in_slot( Item itm, Slot slot )
{
    // an empty item can go in any slot (obviously)
    if( !Item_here( itm ) )
    {
        return true;
    }

    // the player can hold any item in their hands
    if( Slot.hands & slot )
    {
        return true;
    }
    // the hands are also the only slot which can hold an item with no
    // equipment slot flag
    else if( itm.equip == Slot.none )
    {
        return false;
    }

    // As of version 0.035, the flags used to define item equipment slots are
    // analogous to the flags used to specify equipment slots in the
    // inventory, so we can verify the equip using this simple formula:
    return 0 != (itm.equip & slot);
} // bool check_equip( Item, Slot )

void get_inv_slot_name( string* nam, char* ch, ubyte slot );
