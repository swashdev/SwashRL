/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */
#include "global.h"

mon mondat( char isym, str iname, uint8 ifly, uint8 iswim,
            uint8 hit_dice, int16 hit_modifier, int32 hit_min, int32 hit_max,
            uint8 at_dice, int16 at_modifier, int32 at_min, int32 at_max )
{
  return (mon) { symdata( isym, A_NORMAL ), iname, ifly, iswim,
                 Dice( hit_dice, hit_modifier, hit_min, hit_max ),
                 Dice( at_dice, at_modifier, at_min, at_max ),
               };
}

monst monster_at( mon mn, uint8 x, uint8 y )
{
  return (monst) { .sym = mn.sym, .name = mn.name, .fly = mn.fly,
                   .swim = mn.swim, .hp = roll( mn.hit_dice.dice, mn.hit_dice.modifier ),
                   .attack_roll = mn.attack_roll,
                   .x = x, .y = y
                 };
}

monst monster( mon mn )
{ return monster_at( mn, 0, 0 );
}

monst new_monst_at( char isym, str iname, uint8 ifly, uint8 iswim,
                    uint8 hit_dice, int16 hit_mod, int32 hit_min,
                    int32 hit_max,
                    uint8 at_dice, int16 at_mod, int32 at_min, int32 at_max,
                    uint8 x, uint8 y )
{
  return (monst) { .sym = symdata( isym, A_NORMAL ), .name = iname,
                   .fly = ifly, .swim = iswim, .hp = roll( hit_dice, hit_mod ),
                   .attack_roll = Dice( at_dice, at_mod, at_min, at_max ), 
                   .x = x, .y = y
                 };
}

monst new_monst( char isym, str iname, uint8 ifly, uint8 iswim,
                 uint8 hit_dice, int16 hit_mod, int32 hit_min, int32 hit_max,
                 uint8 at_dice, int16 at_mod, int32 at_min, int32 at_max )
{ return new_monst_at( isym, iname, ifly, iswim, hit_dice, hit_mod, hit_min,
                       hit_max, at_dice, at_mod, at_min, at_max,
                       0, 0
                     );
}
