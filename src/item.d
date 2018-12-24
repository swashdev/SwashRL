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
