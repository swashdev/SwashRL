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

// item.d: structures and functions related to items

import global;

/++
 + The Item struct
 +
 + This struct defines an Item.
 +
 + It contains the Item's `symbol`, which also defines colors; a string
 + representing the Item's `name`, and unsigned shorts defining the Item
 + `type` and what, if any, `equip` slot it goes into.
 +
 + It also defines two bytes `addd` and `addm`, which respectively add dice
 + and a modifier to rolls which impact the Item in question.  For example,
 + an attack roll by the player while they are equipping an Item of type
 + `ITEM_WEAPON` will add `addd` to the dice rolls and `addm` to the modifier
 + for damage output.
 +
 + Flags for `type` and `equip` are defined in iflags.d
 +/
struct Item
{
  Symbol sym;
  string name;
  uint type, equip;
  /* modifiers to the player's dice rolls */
  int addd, addm;
}

/// A generic Item used to signal an empty equipment slot or a floor tile
/// which does not have an Item on it
Item No_item = { sym:Symbol('\0', CLR_DEFAULT), name:"NO ITEM", addd:0, addm:0 };

/**
 * A function used to quickly check if there is an item on a floor tile or
 * inventory slot
 *
 * This function takes in an `Item`, ideally taken from a `Tile` or from the
 * player's `Inven`tory, and checks to see if the `Item` represents an actual
 * item or if it's simply a placeholder representing `No_item`.
 *
 * SwashRL generally uses the `Item`'s character to determine if there is an
 * item on the `Tile` or in the inventory slot, specifically by checking if
 * `i.sym.ch` is equal to `'\0'`.  The reason this behavior is that it's
 * easier to check if a single variable is "null" than it is to check if the
 * entire `Item` struct is equal to `No_item`.
 *
 * This function is used to make the entire `if` check even less cumbersome.
 *
 * Params:
 *   i  The `Item` to check
 *
 * Returns:
 *   `true` if there is an `Item_here`.  `false` otherwise.
 */
bool Item_here( Item i )
{ return i.sym.ch != '\0';
}
