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

import core.stdc.time;

/++
 + Stores data for dice rolls
 +
 + The Dicebag struct's job is to store the information needed to calculate a
 + dice roll in a single function parameter.
 +
 + Every Dicebag stores a number of six-sided `dice` and a `modifier`.  The
 + number of `dice` has to be a positive or zero, but the `modifier` may be
 + negative.
 +
 + Each Dicebag also stores a `floor` and `ceiling`, representing minimum and
 + maximum possible values for the result of the roll.
 +/
struct Dicebag
{
  // `dice' is the number of d6es, `modifier' gets added to the result of the
  // roll
  ubyte dice;
  short modifier;
  // `floor' and `ceiling' represent an absolute maximum and absolute minimum.
  // these are enforced after the modifier is added.  If `floor' < `ceiling',
  // use the global limits.  Note that there is absolutely nothing stopping
  // you from making `ceiling' negative as long as `floor' is lesser or equal.
  int floor, ceiling;
}

/++
 + Defines a `Dicebag`
 +
 + Deprecated:
 +   This function is a holdover from the C days.  Use D's generic struct
 +   constructor instead.
 +/
Dicebag Dice( ubyte d, short m, int f, int c )
{ 
  Dicebag r = { dice:d, modifier:m, floor:f, ceiling:c };
  return r;
}

import std.random, std.datetime;

/// Hi, my name is Lucky, and I'll be your random number generator today.
static Random Lucky;

// rng maintenance //

/++
 + Gives the random number generator a specific seed `s`.
 +
 + Params:
 +   s = The seed to be given to the random number generator
 +/
void set_seed( int s )
{ Lucky = Random( s );
}

/++
 + Generates a seed for the random number generator from the system time.
 +/
void seed()
{ Lucky = Random( cast(int)core.stdc.time.time(null) );
}

// boolean dice

/++
 + Gets a random boolean value from a coin-toss.
 +
 + This function simulates a coin-toss by randomly generating either a 1 or a
 + 0 and returning that number as a `bool`.
 +
 + Returns:
 +   Either `true` or `false`.  The chances of either should be roughly 50/50.
 +/
bool flip()
{ return cast(bool)uniform( 0, 2, Lucky );
}

// the standard six-sided die //

/++
 + Roll a d6
 +
 + The standard die in SwashRL is the d6, which is generated here as a
 + uniform distribution between 1 and 6 and returned as a `uint`.
 +
 + See_Also:
 +   <a href="#dm">dm</a>
 +
 + Returns:
 +   A random value between 1 and 6 as a `uint`.
 +/
uint d()
{ return uniform( 1, 7, Lucky );
}

/++
 + Roll a d6 with a modifier.
 +
 + This function uses `d` to roll a d6 and then adds the given `mod`ifier.
 + The modifier may be negative or zero.
 +
 + See_Also:
 +   <a href="#d">d</a>
 +
 + Returns:
 +   A random number between 1 + `mod` and 6 + `mod`
 +/
int dm( byte mod )
{ return (d() + mod);
}

/++
 + Roll a "traditional" d10 numbered from 0 to 9
 +
 + This function generates a random number from 0 to 9, much like the more
 + traditional d10 that you get in a standard dice set.  The distribution of
 + the numbers should be uniform.
 +
 + See_Also:
 +   <a href="#d10">d10</a>
 +
 + Returns:
 +   A random number from 0 to 9
 +/
int td10()
{
  auto result = uniform( 1, 21, Lucky );
  if( result > 9 )
  { result -= 10;
  }
  return result;
}

/++
 + Roll a "non-traditional" d10 numbered from 1 to 10
 +
 + This function uses `td10` to roll a ten-sided die and then converts the
 + result into a value between 1 and 10, which is what most programmers might
 + expect a ten-sided die to do in context.
 +
 + The reason why this function uses `td10` instead of just rolling its own
 + die is to allow both to be changed simultaneously with minimal effort.
 +
 + See_Also:
 +   <a href="#td10">td10</a>
 +
 + Returns:
 +   A random number from 1 to 10
 +/
uint d10()
{
  uint result = td10();
  return result == 0 ? 10 : result;
} 

/++
 + Rolls a ten-sided die, known in roleplaying circles as a percentile die
 +
 + This function generates a random value from 1 to 100.
 +
 + Going by tradition, the `td10` function is used to roll two ten-sided
 + dice and then the output from that is converted into the output of a d100
 + roll, as it would be in a typical tabletop or pen-and-paper RPG.
 +
 + There's no functional reason for this highly traditionalist method of
 + generating random numbers, but rather a reason of mad devotion to
 + authenticity.
 +
 + See_Also:
 +   <a href="#td10">td10</a>
 +
 + Returns:
 +   A random number between 1 and 100
 +/
uint d100()
{
  uint t = td10(), u = td10();
  if( t == 0 && u == 0 )
  { return 100;
  } 
  return (t * 10) + u;
} 

/++
 + Rolls a two-sided die
 +
 + This function generates either a 1 or a 2.  The chances of either value
 + should be roughly 50/50.
 +
 + Yes, two-sided dice really exist, usually in the form of a plastic coin
 + with a 1 and a 2 written on it.  In real life, however, most games will
 + just tell you to flip a coin.
 +
 + Returns:
 +   Either a 1 or a 2, randomly selected.
 +/
uint d2()
{ return uniform( 1, 3 );
} 

/++
 + Rolls an `s`-sided die
 +
 + This function is used to roll a die with an arbitrary number of sides `s`.
 + If s is negative, the result will always be the absolute value of s (e.g.,
 + if s is -4, the result is always 4).
 +
 + If s is 0 or 1, no random number generation is done.  Instead, the result
 + is always s.
 +
 + For any s greater than 1, a uniform distribution is used, as if the die
 + were fair regardless of how many sides it has.  If you know anything about
 + geometry, most dice you input into this function will not be fair in real
 + life, but for our purposes we assume that they always will be.
 +
 + Params:
 +   s = The number of `s`ides that the die should have
 +
 + Returns:
 +   `abs( s )`, if s &lt; 0; $(LF)
 +   0, if s == 0; $(LF)
 +   1, if s == 1; $(LF)
 +   A random number between 1 and s, if s &gt; 1
 +/
uint dn( int s )
{
  /* if sides == 1, just return 1.  if sides == 0, return 0.
   * if sides < 0, force that result (e.g. -4 always produces 4) */
  if( s < 2 )
  {
    if( s >= 0 )
    { return s;
    } 
    return -s;
  } 
  return uniform( 1, s + 1, Lucky );
} 

/++
 + Roll `num` d6es with the given `mod`ifier
 +
 + This is the "complete" roll function.  It rolls `num` six-sided dice using
 + `d` and adds `mod` as the modifier.  num must be positive or zero, but mod
 + may be negative.
 +
 + If num is zero, the function returns `mod` rather than doing any random
 + number generation.
 +
 + See_Also:
 +   <a href="#d">d</a>
 +   <a href="#roll_x">roll_x</a>,
 +   <a href="#roll_bag">roll_bag</a>
 +
 + Params:
 +   num = The `num`ber of six-sided dice to roll
 +   mod = The `mod`ifier to be added to the result of the roll
 +
 + Returns:
 +   mod, if num == 0; $(LF)
 +   a random number between (num + mod) and [(num * 6) + mod], if num &gt; 0
 +/
int roll( uint num, int mod )
{
  if( num == 0 )
  { return mod;
  } 

  uint result;

  foreach( dice; 0 .. num )
  { result += d();
  } 

  return result + mod;
} 

/++
 + Roll `num` d6es with the given `mod`ifier, respecting a minimum and maximum
 + possible value.
 +
 + This is the "extended" version of `roll`, with a floor and a ceiling.  Its
 + behavior is mostly the same as `roll`, except that it also checks to see
 + if the result is below `floor` or above `ceiling` and adjusts the output
 + appropriately.
 +
 + `MAXIMIM_DICE_ROLL` and `MINIMUM_DICE_ROLL` are also checked, and take
 + precedence over the given `floor` and `ceiling` parameters.
 +
 + See_Also:
 +   <a href="#d">d</a>,
 +   <a href="#roll">roll</a>,
 +   <a href="#roll_bag">roll_bag</a>
 +
 + Params:
 +   num     = The `num`ber of six-sided dice to roll
 +   mod     = The `mod`ifier to be added to the result of the roll
 +   floor   = The minimum possible result of the roll
 +   ceiling = The maximum possible result of the roll
 +
 + Returns:
 +   mod, if num == 0; $(LF)
 +   A random number between (num + mod) and [(num * 6) + mod], if that number
 +   is between floor and ceiling; $(LF)
 +   floor or ceiling, if the result of the roll falls under or above those
 +   values
 +/
int roll_x( uint num, int mod, uint floor, uint ceiling )
{
  if( num == 0 )
  { return mod;
  } 

  uint result = 0;
  foreach( dice; 0 .. num-1 )
  {
    result += d();
  } 

  if( result > MAXIMUM_DIE_ROLL )
  { result = MAXIMUM_DIE_ROLL;
  } 

  if( result < MINIMUM_DIE_ROLL )
  { result = MINIMUM_DIE_ROLL;
  } 
  return minmax( result, floor, ceiling ) + mod;
}

/++
 + Roll a set of dice based on a given `Dicebag`
 +
 + This function is equivalent to `roll_x`, except that it uses a `Dicebag`
 + struct to get the roll information instead of taking in `num`, `mod`,
 + `floor`, and `ceiling` individually.
 +
 + The function is essentially an alias to `roll_x`, so any changes to
 + `roll_x` will automatically apply to `roll_bag`.
 +
 + See_Also:
 +   <a href="#roll">roll</a>,
 +   <a href="#roll_x">roll_x</a>
 +
 + Params:
 +   dice = a `Dicebag` that contains the parameters for the roll
 +
 + Returns:
 +   A random number generated by a call to `roll_x` based on the information
 +   contained in `dice`
 +/
int roll_bag( Dicebag dice )
{ return roll_x( dice.dice, dice.modifier, dice.floor, dice.ceiling );
}

/++
 + Quickly do a difficulty check
 +
 + This function is used to determine the result of a difficulty check by
 + rolling `num` six-sided dice, adding the given `mod`ifier, and checking if
 + the result is less than the given `difficulty`.
 +
 + num must be positive or zero, but mod may be negative.  difficulty must be
 + zero or greater.
 +
 + The function uses the `roll` function for the check.
 +
 + See_Also:
 +   <a href="#roll">roll</a>
 +
 + Params:
 +   num        = The `num`ber of six-sided dice to roll
 +   mod        = The `mod`ifier to be added to the result of the roll
 +   difficulty = The difficulty of the check
 +
 + Returns:
 +   `true`, if the result of the roll is less than or equal to difficulty,
 +   `false` otherwise.
 +/
bool quick_check( uint num, int mod, uint difficulty )
{ return roll( num, mod ) <= difficulty;
}

/++
 + Quickly do a difficulty check with a minimum and maximum value
 +
 + This function is the "extended" version of `quick_check`.  The "extension"
 + is the same as the "extension" to `roll` that `roll_x` does.
 +
 + The function uses the `roll_x` function for the check.
 +
 + See_Also:
 +   <a href="#roll_x">roll_x</a>
 +
 + Params:
 +   num        = The `num`ber of six-sided dice to roll
 +   mod        = The `mod`ifier to be added to the result of the roll
 +   difficulty = The difficulty of the check
 +   floor      = The minimum possible result of the roll
 +   ceiling    = The maximum possible result of the ceiling
 +
 + Returns:
 +   `true`, if the result of the roll is less than or equal to difficulty,
 +   `false` otherwise.
 +/
bool quick_check_x( uint num, int mod, uint difficulty,
                   uint floor, uint ceiling )
{ return roll_x( num, mod, floor, ceiling ) <= difficulty;
}
