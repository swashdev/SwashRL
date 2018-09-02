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

// Defines structs and functions related to monsters and monster generation
// data

import global;
import std.string : format;

/++
 + A struct for `mon`ster generation data
 +
 + This struct is used for storing data used to generate new monsters.
 + The data stored in the struct is parsed by functions used for declaring a
 + new `monst`.
 +
 + This struct can be thought of as describing a specific <em>kind</em> of
 + monster rather than an individual monster.
 +
 + The struct contains the monster's `symbol`, `sym`; a `string` representing
 + its `name`.
 +
 + It also contains a `ubyte` called `fly` which stores flags related to
 + whether or not the monster can fly and a `ubyte` called `swim` which stores
 + flags related to whether or not the monster can swim.
 +
 + It also contains two `dicebag`s, one (`hit_dice`) used to generate the
 + monster's hit points; and one (`attack_roll`) representing the monster's
 + attack roll.
 +
 + See_Also:
 +   <a href="#monst">monst</a>,
 +   <a href="#monster">monster</a>,
 +   <a href="#monster_at">monster_at</a>
 +/
struct mon
{
  symbol sym;
  string name;
  ubyte fly;
  ubyte swim;
  dicebag hit_dice;
  dicebag attack_roll;
}

/++
 + Generates a new `mon`
 +
 + This function defines a `mon` struct based on the input parameters.
 +
 + Deprecated:
 +   This function is longwinded and unnecessary.  Use D's generic struct
 +   constructor instead.
 +
 + See_Also:
 +   <a href="#mon">mon</a>
 +
 + Params:
 +   isym         = The monster's on-screen character;  Note that color
 +                  information is not defined
 +   iname        = The monster's name
 +   ifly         = Flags related to the monster's ability to fly
 +   iswim        = Flags related to the monster's ability to swim
 +   hit_dice     = The number of dice used to determine the monster's
 +                  starting hit points
 +   hit_modifier = The modifier used to determine the monster's starting hit
 +                  points
 +   hit_min      = The monster's minimum hit points
 +   hit_max      = The monster's maximum hit points
 +   at_dice      = The number of dice used to determine the monster's
 +                  attack roll
 +   at_modifier  = The modifier to be added to the monster's attack roll
 +   at_min       = The monster's minimum attack rating
 +   at_max       = The monster's maximum attack rating
 +
 + Returns:
 +   A `mon`
 +/
mon mondat( char isym, string iname, ubyte ifly, ubyte iswim,
            ubyte hit_dice, short hit_modifier, int hit_min, int hit_max,
            ubyte at_dice, short at_modifier, int at_min, int at_max )
{
  mon mn = { sym:symdata( isym, CLR_DEFAULT ), name:iname, fly:ifly,
             swim:iswim,
             hit_dice:Dice( hit_dice, hit_modifier, hit_min, hit_max ),
             attack_roll:Dice( at_dice, at_modifier, at_min, at_max )
           };
  return mn;
}

/++
 + The `monst`er struct
 +
 + This struct defines a specific monster, as opposed to `mon` which defines
 + a <em>type</em> of monster.
 +
 + This struct contains the monster's `symbol`, `sym`; a `string` representing
 + its `name`; an `int`, `hp`, representing the monster's hit points; and two
 + `ubyte`s representing its `x` and `y` coordinates.
 +
 + This struct also contains a `ubyte` called `fly` which contains flags
 + related to the monster's ability to fly; and a `ubyte` called `swim` which
 + contains flags related to the monster's ability to swim.
 +
 + This struct also contains a `dicebag` called `attack_roll` which determines
 + the monster's attack rolls.
 +
 + See_Also:
 +   <a href="#mon">mon</a>,
 +   <a href="#monster">monster</a>,
 +   <a href="#monster_at">monster_at</a>
 +/
struct monst
{
  symbol sym;
  string name;
  int hp;
  ubyte fly;
  ubyte swim;
  dicebag attack_roll;
  ubyte x, y;
  inven inventory;
}

/++
 + Generates a `monst`er from the given `mon`ster generation data at the given
 + coordinates
 +
 + This function takes a `mon` and uses it to build a `monst` at the given
 + coordinates (x, y).  It's essentially a method used to turn the monster
 + generation data defined in a `mon` struct into an actual monster defined
 + by a `monst` struct.
 +
 + See_Also:
 +   <a href="#mon">mon</a>,
 +   <a href="#monst">monst</a>,
 +   <a href="#monster">monster</a>
 +
 + Params:
 +   mn = A `mon` representing the monster generation data being used to
 +        generate a new `monst` struct
 +   x  = The x coordinate at which the monster should start
 +   y  = The y coordinate at which the monster should start
 +
 + Returns:
 +   A `monst` generated by the monster generation data in mn with x and y set
 +   by the x and y parameters of this function
 +/
monst monster_at( mon mn, ubyte x, ubyte y )
{
  monst mon = { sym:mn.sym, name:mn.name, fly:mn.fly, swim:mn.swim,
                hp:roll( mn.hit_dice.dice, mn.hit_dice.modifier ),
                attack_roll:mn.attack_roll,
                x:x, y:y
              };

  foreach( count; 0 .. 40 )
  { mon.inventory.items[count] = No_item;
  }

  return mon;
}

/++
 + Generates a `monst`er from the given `mon`ster generation data
 +
 + This function takes a `mon` and uses it to build a `monst`.
 +
 + This function is essentially an alias for `monster_at( mn, 0, 0 )`.
 +
 + See_Also:
 +   <a href="#mon">mon</a>,
 +   <a href="#monst">monst</a>,
 +   <a href="#monster_at">monster_at</a>
 +
 + Params:
 +   mn = A `mon` representing the monster generation data being used to
 +        generate a new `monst` struct
 +
 + Returns:
 +   A `monst` generated by the monster generation data in mn
 +/
monst monster( mon mn )
{ return monster_at( mn, 0, 0 );
}

/++
 + Generates a new `monst` at the coordinates (x, y)
 +
 + This function generates a new `monst`er at the given coordinates (x, y)
 + using the function parameters.
 +
 + Deprecated:
 +   This function is longwinded and unnecessary.  Use D's generic struct
 +   constructor instead, or use `monster_at` to generate a `monst` from a
 +   predefined `mon` struct.
 +
 + See_Also:
 +   <a href="#monst">monst</a>,
 +   <a href="#monster_at">monster_at</a>,
 +   <a href="#new_monst">new_monst
 +
 + Params:
 +   isym     = The character used to represent the monster in the display;
 +              Note that color information is not defined
 +   iname    = The name of the generated monster
 +   ifly     = Flags related to the monster's ability to fly
 +   iswim    = Flags related to the monster's ability to swim
 +   hit_dice = The number of dice used to determine the monster's starting
 +              hit points
 +   hit_mod  = The modifier added to the monster's starting hit points
 +   hit_min  = The minimum possible starting hit points
 +   hit_max  = The maximum possible starting hit points
 +   at_dice  = The number of dice used to determine the monster`s
 +              `attack_roll`
 +   at_mod   = The modifier to the monster's `attack_roll`
 +   at_min   = The minimum possible result of the monster's `attack_roll`
 +   at_mod   = The maximum possible result of the monster's `attack_roll`
 +   x        = The monster's starting x coordinate
 +   y        = The monster's starting y coordinate
 +
 + Returns:
 +   A `monst` generated from the function parameters at coordinates (x, y)
 +/
monst new_monst_at( char isym, string iname, ubyte ifly, ubyte iswim,
                    ubyte hit_dice, short hit_mod, int hit_min, int hit_max,
                    ubyte at_dice, short at_mod, int at_min, int at_max,
                    ubyte x, ubyte y )
{
  monst mon = { sym:symdata( isym, CLR_DEFAULT ), name:iname,
                fly:ifly, swim:iswim,
                hp:roll( hit_dice, hit_mod ),
                attack_roll:Dice( at_dice, at_mod, at_min, at_max ),
                x:x, y:y
              };

  foreach( count; 0 .. 40 )
  { mon.inventory.items[count] = No_item;
  }

  return mon;
}

/++
 + Generates a new `monst`
 +
 + This function generates a new `monst`er using the function parameters.
 +
 + This function is essentially an alias for `new_monst_at( isym, ... 0, 0 )`.
 +
 + Deprecated:
 +   This function is longwinded and unnecessary.  Use D's generic struct
 +   constructor instead, or use `monster` to generate a `monst` from a
 +   predefined `mon` struct.
 +
 + See_Also:
 +   <a href="#monst">monst</a>,
 +   <a href="#monster">monster</a>,
 +   <a href="#new_monst_at">new_monst_at</a>
 +
 + Params:
 +   isym     = The character used to represent the monster in the display;
 +              Note that color information is not defined
 +   iname    = The name of the generated monster
 +   ifly     = Flags related to the monster's ability to fly
 +   iswim    = Flags related to the monster's ability to swim
 +   hit_dice = The number of dice used to determine the monster's starting
 +              hit points
 +   hit_mod  = The modifier added to the monster's starting hit points
 +   hit_min  = The minimum possible starting hit points
 +   hit_max  = The maximum possible starting hit points
 +   at_dice  = The number of dice used to determine the monster`s
 +              `attack_roll`
 +   at_mod   = The modifier to the monster's `attack_roll`
 +   at_min   = The minimum possible result of the monster's `attack_roll`
 +   at_mod   = The maximum possible result of the monster's `attack_roll`
 +
 + Returns:
 +   A `monst` generated from the function parameters
 +/
monst new_monst( char isym, string iname, ubyte ifly, ubyte iswim,
                 ubyte hit_dice, short hit_mod, int hit_min, int hit_max,
                 ubyte at_dice, short at_mod, int at_min, int at_max )
{ return new_monst_at( isym, iname, ifly, iswim, hit_dice, hit_mod, hit_min,
                       hit_max, at_dice, at_mod, at_min, at_max,
                       0, 0
                     );
}

/++
 + Gives an appropriate name for the given monster
 +
 + This function is used for getting an appropriate title for the given
 + monster in messages.
 +
 + If the monster is the player, the string `"you"` is returned.  Otherwise,
 + it gives `mn.name`.
 +
 + Date:  2018-09-01
 +
 + Params:
 +   mn  = The monster to check
 +
 + Returns:
 +   A `string` representing an appropriate title for the monster
 +/
string monst_name( monst mn )
{
  if( mn.name == "spelunker" )  return "you";

  return mn.name;
}

string the_monst( monst mn )
{
  if( mn.name == "spelunker" )  return "you";

  return format( "the %s", mn.name );
}

string The_monst( monst mn )
{
  if( mn.name == "spelunker" )  return "You";

  return format( "The %s", mn.name );
}
