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

// This file defines items and functions related to them

import global;

/++
 + The item struct
 +
 + This struct defines an item.
 +
 + It contains the item's `symbol`, which also defines colors; a string
 + representing the item's `name`, and unsigned shorts defining the item
 + `type` and what, if any, `equip` slot it goes into.
 +
 + It also defines two bytes `addd` and `addm`, which respectively add dice
 + and a modifier to rolls which impact the item in question.  For example,
 + an attack roll by the player while they are equipping an item of type
 + `ITEM_WEAPON` will add `addd` to the dice rolls and `addm` to the modifier
 + for damage output.
 +
 + Flags for `type` and `equip` are defined in iflags.d
 +/
struct item
{
  symbol sym;
  string name;
  ushort type, equip;
  /* modifiers to the player's dice rolls */
  byte addd, addm;
}

/// A generic item used to signal an empty equipment slot or a floor tile
/// which does not have an item on it
item No_item = { sym:symbol('\0'), name:"NO ITEM", addd:0, addm:0 };
