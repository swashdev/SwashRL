/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */

// defines structs for storing information about monsters

import global;

// `mon' for monster generation data
struct mon
{
  symbol sym;
  string name;
  ubyte fly;
  ubyte swim;
  dicebag hit_dice;
  dicebag attack_roll;
}

// I'm just not even going to try for this one at 4 o'clock in the morning
// and throw this one on the TODO list
//mon mondat( char isym, str iname, uint8 ifly, uint8 iswim,
//            uint8 hit_dice, int16 hit_modifier, int32 hit_min, int32 hit_max,
//            uint8 at_dice, int16 at_modifier, int32 at_min, int32 at_max );

// `monst' for a specific monster
struct monst;
{
  symbol sym;
  string name;
  int hp;
  ubyte fly;
  ubyte swim;
  dicebag attack_roll;
  ubyte x, y;
}

monst monster( mon mn );
monst monster_at( mon mn, uint8 x, uint8 y );

// TODO
//monst new_monst( char isym, str iname, uint8 ifly, uint8 iswim,
//                 uint8 hit_dice, int16 hit_mod, int32 hit_min, int32 hit_max,
//                 uint8 at_dice, int16 at_mod, int32 at_min, int32 at_max );
//monst new_monst_at( char isym, str iname, uint8 ifly, uint8 iswim,
//                    uint8 hit_dice, int16 hit_mod, int32 hit_min,
//                    int32 hit_max,
//                    uint8 at_dice, int16 at_mod, int32 at_min, int32 at_max,
//                    uint8 x, uint8 y );
