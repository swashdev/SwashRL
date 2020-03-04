/*
 * Copyright (c) 2015-2020 Philip Pavlick.  See '3rdparty.txt' for other
 * licenses.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *  * Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *  * Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *  * Neither the name of the SwashRL project nor the names of its
 *    contributors may be used to endorse or promote products derived from
 *    this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

// monst.d: defines structs and functions related to monsters and monster
// generation

import global;
import std.string : format;

// A struct containing data used to generate monsters from a template.
struct Mon
{
  Symbol sym;
  string name;
  uint fly;
  uint swim;
  Dicebag hit_dice;
  Dicebag attack_roll;
}

// Generates a new monster template.
// DEPRECATED: Use D's built-in struct constructors instead.
Mon mondat( char isym, string iname, uint ifly, uint iswim,
            uint hit_dice, int hit_modifier, int hit_min, int hit_max,
            uint at_dice, int at_modifier, int at_min, int at_max )
{
  Mon mn = { sym:symdata( isym, CLR_DEFAULT ), name:iname, fly:ifly,
             swim:iswim,
             hit_dice:Dice( hit_dice, hit_modifier, hit_min, hit_max ),
             attack_roll:Dice( at_dice, at_modifier, at_min, at_max )
           };
  return mn;
}

// A struct used to store `Monst`er data.  Note that, unlike with items,
// monsters store their own map coordinates.
struct Monst
{
  Symbol sym;
  string name;
  int hp;
  uint fly;
  uint swim;
  Dicebag attack_roll;
  ubyte x, y;
  Inven inventory;
}

// Generates a monster at the given coordinates, using the given `Mon`
// template
Monst monster_at( Mon mn, ubyte x, ubyte y )
{
  Monst mon = { sym:mn.sym, name:mn.name, fly:mn.fly, swim:mn.swim,
                hp:roll( mn.hit_dice.dice, mn.hit_dice.modifier ),
                attack_roll:mn.attack_roll,
                x:x, y:y
              };

  foreach( count; 0 .. 40 )
  { mon.inventory.items[count] = No_item;
  }

  return mon;
}

// Generates a monster using the given `Mon` template.  Note that this
// function will place the monster at coordinates (0,0), which is an invalid
// location in the current SwashRL maps.
Monst monster( Mon mn )
{ return monster_at( mn, 0, 0 );
}

// Generates a new `Monst` at the given coordinates.
// DEPRECATED: Use D's built-in struct constructors instead.
Monst new_monst_at( char isym, string iname, uint ifly, uint iswim,
                    uint hit_dice, int hit_mod, int hit_min, int hit_max,
                    uint at_dice, int at_mod, int at_min, int at_max,
                    ubyte x, ubyte y )
{
  Monst mon = { sym:symdata( isym, CLR_DEFAULT ), name:iname,
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

// Generates a new `Monst` at coordinates (0,0).
// DEPRECATED: Use D's built-in struct constructors instead.
Monst new_monst( char isym, string iname, uint ifly, uint iswim,
                 uint hit_dice, int hit_mod, int hit_min, int hit_max,
                 uint at_dice, int at_mod, int at_min, int at_max )
{ return new_monst_at( isym, iname, ifly, iswim, hit_dice, hit_mod, hit_min,
                       hit_max, at_dice, at_mod, at_min, at_max,
                       0, 0
                     );
}

// Returns the monster's name.  If the monster is identified as the player,
// returns "you".  This function is used for formatting messages.
string monst_name( Monst mn )
{
  if( mn.name == "spelunker" )  return "you";

  return mn.name;
}

// Returns the string "the %s," where %s is the name of the given monster,
// unless the monster is identified as the player, in which case "you" is
// returned instead.  Much like `monst_name`, this function is used for
// formatting messages.
string the_monst( Monst mn )
{
  if( mn.name == "spelunker" )  return "you";

  return format( "the %s", mn.name );
}

// The same as `the_monst`, but with a capital first letter, used at the start
// of sentences.
string The_monst( Monst mn )
{
  if( mn.name == "spelunker" )  return "You";

  return format( "The %s", mn.name );
}
