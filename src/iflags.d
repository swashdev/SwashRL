/*
 * Copyright 2016-2019 Philip Pavlick
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License.  You may obtain a copy
 * of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * SwashRL is distributed with a special exception to the normal Apache
 * License 2.0.  See LICENSE for details.
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
