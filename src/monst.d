/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */

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
            ubyte hit_dice, short hit_modifier, int hit_min, int hit_max,
            ubyte at_dice, short at_modifier, int at_min, int at_max )
{
  mon mn = { sym:symdata( isym, A_NORMAL ), name:iname, fly:ifly, swim:iswim,
             hit_dice:Dice( hit_dice, hit_modifier, hit_min, hit_max ),
             attack_roll:Dice( at_dice, at_modifier, at_min, at_max )
           };
  return mn;
}

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

monst monster_at( mon mn, ubyte x, ubyte y )
{
  monst mon = { sym:mn.sym, name:mn.name, fly:mn.fly, swim:mn.swim,
                hp:roll( mn.hit_dice.dice, mn.hit_dice.modifier ),
                attack_roll:mn.attack_roll,
                x:x, y:y
              };
  return mon;
}

monst monster( mon mn )
{ return monster_at( mn, 0, 0 );
}

monst new_monst_at( char isym, string iname, ubyte ifly, ubyte iswim,
                    ubyte hit_dice, short hit_mod, int hit_min, int hit_max,
                    ubyte at_dice, short at_mod, int at_min, int at_max,
                    ubyte x, ubyte y )
{
  monst mon = { sym:symdata( isym, A_NORMAL ), name:iname,
                fly:ifly, swim:iswim,
                hp:roll( hit_dice, hit_mod ),
                attack_roll:Dice( at_dice, at_mod, at_min, at_max ),
                x:x, y:y
              };
  return mon;
}

monst new_monst( char isym, string iname, ubyte ifly, ubyte iswim,
                 ubyte hit_dice, short hit_mod, int hit_min, int hit_max,
                 ubyte at_dice, short at_mod, int at_min, int at_max )
{ return new_monst_at( isym, iname, ifly, iswim, hit_dice, hit_mod, hit_min,
                       hit_max, at_dice, at_mod, at_min, at_max,
                       0, 0
                     );
}
