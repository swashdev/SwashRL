/*
 * Copyright 2015-2019 Philip Pavlick
 *
 * This software is provided 'as-is', without any express or implied
 * warranty.  In no event will the authors be held liable for any damages
 * arising from the use of this software.
 * 
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 * 
 * 1. The origin of this software must not be misrepresented; you must not
 *    claim that you wrote the original software. If you use this software
 *    in a product, an acknowledgment in the product documentation would be
 *    appreciated but is not required.
 * 2. Altered source versions must be plainly marked as such, and must not be
 *    misrepresented as being the original software.
 * 3. This notice may not be removed or altered from any source distribution.
 */

// This file defines Items and functions related to them

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
