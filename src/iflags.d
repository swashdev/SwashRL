/*
 * Copyright (c) 2016-2018 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */

// flags related to items

enum NO_ITEM = 0x0;

// equip areas (for armor)

enum EQUIP_NO_ARMOR       = 0x000;
enum EQUIP_SHIELD         = 0x001;
enum EQUIP_HELMET         = 0x002;
enum EQUIP_CUIRASS        = 0x004;
enum EQUIP_PAULDRONS      = 0x008;
enum EQUIP_GLOVES         = 0x010;
enum EQUIP_BRACERS        = 0x020;
enum EQUIP_GREAVES        = 0x040;
enum EQUIP_KILT           = 0X080;
enum EQUIP_FEET           = 0x100;
enum EQUIP_TAIL           = 0x200;
enum EQUIP_JEWELERY_RING  = 0x400;
enum EQUIP_JEWELERY_NECK  = 0x800;

// item type

enum ITEM_WEAPON          = 0x0001;
enum ITEM_WEAPON_LARGE    = 0x0003;
enum ITEM_WEAPON_LAUNCHER = 0x0007;
enum ITEM_WEAPON_MISSILE  = 0x0009;
enum ITEM_TOOL            = 0x0010;
enum ITEM_FOOD            = 0x0020;
enum ITEM_DRINK           = 0x0040;
enum ITEM_SCROLL          = 0x0080;
enum ITEM_BOOK            = 0x0100;
enum ITEM_ARMOR           = 0x0200;
enum ITEM_JEWELERY        = 0x0400;
enum ITEM_COIN            = 0x0800;
enum ITEM_REAGENT         = 0x1000;
