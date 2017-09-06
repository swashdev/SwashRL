/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */

import global;

// Checks if the player is able to pick up an item.  If so, it sets the item
// in one of their "hand" inventory slots to `i'.  The player character will
// generally prefer to pick up non-weapon items in their off-hand.  Returns
// TRUE if the player successfully picked up an item.  Returns FALSE otherwise.
// Note that this function will check if `i' is a valid item for us.
bool upickup( player* u, item i );

// Allows the player to check their inventory.  Returns the number of items
// moved while on the inventory screen.
uint uinventory( player* u );

// Checks if the player can equip `i' in item slot `s'
bool check_equip( item i, ubyte s );

// Checks if the player has a free grasp
// returns 1 for weapon-hand, 2 for off-hand, and 0 for no free grasp
ubyte check_grasp( player* u );
