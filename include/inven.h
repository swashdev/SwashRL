/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */
#ifndef INVEN_H
# define INVEN_H

# include "global.h"

/* defines the `inven' struct, used for inventories */

/* inventory slots have unique names related to the letter they are associated
 * with.
 * `weapon' means the user's weapon-hand, `off' means their off-hand,
 * `ready' means a readied but not wielded weapon, and `second' is a readied
 * secondary weapon.  The `tail' inventory slot is only available for
 * characters who have tails and should be treated as a special case.
 * Note that the `weapon' and `off' hands are also used for carrying things.
 * TODO: Implement a "bag" for the user's miscellaneous items carried in a bag
 * (perhaps the bag should be an inventory item as well?)
 */

typedef struct
{
  /* all `items' carried in this inventory; 14 "inventory slots" for the
   * various body parts, plus 26 for the "bag" (to be implemented) */
  item items[40]; 
  uint8 quiver_count;
  uint8 coins;
} inven;

# define INVENT_WEAPON     0
# define INVENT_OFFHAND    1
# define INVENT_QUIVER     2
# define INVENT_HELMET     3
# define INVENT_CUIRASS    4
# define INVENT_PAULDRONS  5
# define INVENT_BRACERS    6
# define INVENT_RINGL      7
# define INVENT_RINGR      8
# define INVENT_NECKLACE   9
# define INVENT_GREAVES   10
# define INVENT_KILT      11
# define INVENT_FEET      12
# define INVENT_TAIL      13

# define INVENT_LAST_SLOT INVENT_TAIL

void get_inv_slot_name( str* nam, char* ch, uint8 slot );

/* see ``invent.h'' for functions related to inventory management (these
 * needed to be moved there since these won't compile in the current load
 * order until you.h has been included--possibly something to fix later
 * [TODO]) */

#endif /* !def INVEN_H */
