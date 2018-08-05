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

// inventory slots have unique names related to the letter they are associated
// with.
// The `tail' inventory slot is only available for characters who have tails
// and should be treated as a special case.
// Note that the `weapon' and `off' hands are also used for carrying things.
// TODO: Implement a "bag" for the user's miscellaneous items carried in a bag
// (perhaps the bag should be an inventory item as well?)

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

void get_inv_slot_name( string* nam, char* ch, ubyte slot );

// see ``invent.d'' for functions related to inventory management (these
// needed to be moved there since these won't compile in the current load
// order until ``you.d'' has been included--possibly something to fix later
// [TODO])
