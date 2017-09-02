/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */
/* defines structs for storing information about monsters */
#ifndef MONSTER_STRUCT
# define MONSTER_STRUCT

# include "global.h"

/* `mon' for monster generation data */
typedef struct
{
  symbol sym;
  str name;
  uint8 fly;
  uint8 swim;
  dicebag hit_dice;
  dicebag attack_roll;
} mon;

mon mondat( char isym, str iname, uint8 ifly, uint8 iswim,
            uint8 hit_dice, int16 hit_modifier, int32 hit_min, int32 hit_max,
            uint8 at_dice, int16 at_modifier, int32 at_min, int32 at_max );

/* `monst' for a specific monster */
typedef struct
{
  symbol sym;
  str name;
  int32 hp;
  uint16 fly;
  uint16 swim;
  dicebag attack_roll;
  uint8 x, y;
} monst;

monst monster( mon mn );
monst monster_at( mon mn, uint8 x, uint8 y );
monst new_monst( char isym, str iname, uint8 ifly, uint8 iswim,
                 uint8 hit_dice, int16 hit_mod, int32 hit_min, int32 hit_max,
                 uint8 at_dice, int16 at_mod, int32 at_min, int32 at_max );
monst new_monst_at( char isym, str iname, uint8 ifly, uint8 iswim,
                    uint8 hit_dice, int16 hit_mod, int32 hit_min,
                    int32 hit_max,
                    uint8 at_dice, int16 at_mod, int32 at_min, int32 at_max,
                    uint8 x, uint8 y );

#endif /* !MONSTER_STRUCT */
