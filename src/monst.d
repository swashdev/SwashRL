/*
 * Copyright 2016-2018 Philip Pavlick
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License, excepting that
 * Derivative Works are not required to carry prominent notices in changed
 * files.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
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
struct monst
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
