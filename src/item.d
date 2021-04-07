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

// item.d: structures and functions related to items

import global;

import std.string : format;

// A struct which defines an item.
struct Item
{
    Symbol sym;
    string name;

    // what `type` of item this is and, if applicable, what `equip`ment slot
    // it goes into
    Type type;
    Armor equip;

    // Modifiers to relevant stats for the monster using the item.  See the
    // `str`, `end`, &c variables in the `Monst` struct for more info.
    int str = 0, end = 0;

    // `stacks` determines whether or not this item will stack (useful for
    // coins, arrows, &c) and `count` determines how many items are in the
    // stack.
    bool stacks = false;
    uint count = 1;
}

// A generic placeholder Item used to signal an empty equipment slot or a
// floor tile which does not have an Item on it.
static Item No_item;

// Quickly check if the given item is valid.
// Mostly used to check for empty equipment slots, inventory spaces, or floor
// tiles.
bool Item_here( Item itm )
{
    return itm.count > 0;
}

// Returns the name of the given item.  If the item is a stack, pluralize the
// name.  If `count` is true, return either "a %s" or "%d %ss", where %d is
// the number of items and %s is the item's name.
string item_name( Item itm, bool count = false )
{
    if( itm.count > 1 )
    {
        if( count )
        {
            return format( "%d %ss", itm.count, itm.name );
        }
        else
        {
            return format( "%ss", itm.name );
        }
    }
    else
    {
        if( count )
        {
            return format( "a %s", itm.name );
        }
        else
        {
            return itm.name;
        }
    }
}

string count_items( Item itm )
{
    return item_name( itm, true );
}
