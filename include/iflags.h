/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */
#ifndef IFLAGS_H
# define IFLAGS_H

/* flags related to items */

# define NO_ITEM 0x0

/* equip areas (for armor) */

# define EQUIP_NO_ARMOR       0x000
# define EQUIP_SHIELD         0x001
# define EQUIP_HELMET         0x002
# define EQUIP_CUIRASS        0x004
# define EQUIP_PAULDRONS      0x008
# define EQUIP_GLOVES         0x010
# define EQUIP_BRACERS        0x020
# define EQUIP_GREAVES        0x040
# define EQUIP_KILT           0X080
# define EQUIP_FEET           0x100
# define EQUIP_TAIL           0x200
# define EQUIP_JEWELERY_RING  0x400
# define EQUIP_JEWELERY_NECK  0x800

/* item type */

# define ITEM_WEAPON          0x0001
# define ITEM_WEAPON_LARGE    0x0003
# define ITEM_WEAPON_LAUNCHER 0x0007
# define ITEM_WEAPON_MISSILE  0x0009
# define ITEM_TOOL            0x0010
# define ITEM_FOOD            0x0020
# define ITEM_DRINK           0x0040
# define ITEM_SCROLL          0x0080
# define ITEM_BOOK            0x0100
# define ITEM_ARMOR           0x0200
# define ITEM_JEWELERY        0x0400
# define ITEM_COIN            0x0800
# define ITEM_REAGENT         0x1000

#endif /* !def IFLAGS_H */
