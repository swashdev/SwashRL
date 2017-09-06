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

mon mondat( char isym, string iname, ubyte ifly, ubyte iswim,
            ubyte hit_dice, short hot_modifier, int hit_min, int hit_max,
            ubyte at_dice, short at_modifier, int at_min, int at_max );

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

monst new_monst( char isym, string iname, ubyte ifly, ubyte iswim,
                 ubyte hit_dice, short hit_mod, int hit_min, int hit_max,
                 ubyte at_dice, short at_mod, int at_min, int at_max );
monst new_monst_at( char isym, string iname, ubyte ifly, ubyte iswim,
                    ubyte hit_dice, short hit_mod, int hit_min, int hit_max,
                    ubyte at_dice, short at_mod, int at_min, int at_max,
                    ubyte x, ubyte y );
