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

// dice.d: defines functions, variables, and classes related to the random
// number generator for SwashRL and how it is used for dice rolls.

import global;

import core.stdc.time;

// SECTION 1: ////////////////////////////////////////////////////////////////
// Structures Used to Perform Dicerolls                                     //
//////////////////////////////////////////////////////////////////////////////

// Stores data for dice rolls.
struct Dicebag
{
  // `dice' is the number of d6es, `modifier' gets added to the result of the
  // roll
  uint dice;
  int modifier;
  // `floor' and `ceiling' represent an absolute maximum and absolute minimum.
  // these are enforced after the modifier is added.  If `floor' < `ceiling',
  // use the global limits.  Note that there is absolutely nothing stopping
  // you from making `ceiling' negative as long as `floor' is lesser or equal.
  int floor, ceiling;
}

/* Defines a `Dicebag`.
 *
 * Deprecated:
 *   This function is a holdover from the C days.  Use D's generic struct
 *   constructor instead.
 * XXX: Check and see if we can remove this function without breaking the code
 */
Dicebag Dice( uint d, int m, int f, int c )
{ 
  Dicebag r = { dice:d, modifier:m, floor:f, ceiling:c };
  return r;
}

// SECTION 2: ////////////////////////////////////////////////////////////////
// Random Number Generators                                                 //
//////////////////////////////////////////////////////////////////////////////

import std.random, std.datetime;

// Hi, my name is Lucky, and I'll be your random number generator today.
static Random Lucky;

// Random Number Generator Settings & Maintenance ////////////////////////////

// Sets the seed for the random number generator `Lucky`.
void set_seed( int s )
{ Lucky = Random( s );
}

// Generates a seed for the random number generator `Lucky` from system time.
void seed()
{ Lucky = Random( cast(int)core.stdc.time.time(null) );
}

// SECTION 3: ////////////////////////////////////////////////////////////////
// Functions to Represent Dicerolls                                         //
//////////////////////////////////////////////////////////////////////////////

// Boolean Dice //////////////////////////////////////////////////////////////

// Gets a random boolean from a simulated coin toss.
bool flip()
{ return cast(bool)uniform( 0, 2, Lucky );
}

// The Standard Six-Sided Die ////////////////////////////////////////////////

// The standard die in SwashRL is the d6, which is generated here as a
// uniform distribution between 1 and 6 and returned as a `uint`.
int d()
{ return uniform( 1, 7, Lucky );
}

// Roll a d6 and add the given modifier.
int dm( int mod )
{ return (d() + mod);
}

// Other Standard Role-Playing Dice //////////////////////////////////////////

// Roll a "traditional" d10 numbered from 0 to 9.
int td10()
{
  auto result = uniform( 1, 21, Lucky );
  if( result > 9 )
  { result -= 10;
  }
  return result;
}

// Roll a "non-traditional" d10 numbered from 1 to 10.
int d10()
{
  int result = td10();
  return result == 0 ? 10 : result;
} 

// Roll a percentile die using the traditional method of rolling two d10s.
int d100()
{
  int t = td10(), u = td10();
  if( t == 0 && u == 0 )
  { return 100;
  } 
  return (t * 10) + u;
} 

// Non-Standard Dice /////////////////////////////////////////////////////////

// Yes, two-sided dice exist in real life.
int d2()
{ return uniform( 1, 3 );
} 

// Roll a die with an arbitrary number of sides.
// If s == 1, just return 1.  If s == 0, return 0.
// If s < 0, force that result (e.g., -4 always produces 4)
int dn( int s )
{
  if( s < 2 )
  {
    if( s >= 0 )
    { return s;
    } 
    return -s;
  } 
  return uniform( 1, s + 1, Lucky );
} 

// SECTION 4: ////////////////////////////////////////////////////////////////
// Functions Representing Full or "Extended" Dicerolls                      //
//////////////////////////////////////////////////////////////////////////////

// Roll a given number of six-sided dice and add the given modifier.
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

// Perform an "extended roll" using the given number of six-sided dice and the
// given modifier, with maximum and minimum possible values.
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

  return minmax( result, floor, ceiling ) + mod;
}

// Same as roll_x, but using a `Dicebag` to fill in the relevant data.
int roll_bag( Dicebag dice )
{ return roll_x( dice.dice, dice.modifier, dice.floor, dice.ceiling );
}

// Functions Representing Simple Difficulty Checks ///////////////////////////

// Quickly do a difficulty check.
bool quick_check( uint num, int mod, uint difficulty )
{ return roll( num, mod ) <= difficulty;
}

// Quickly do an "extended" difficulty check with minimum and maximum dice
// rolls (using roll_x instead of roll)
bool quick_check_x( uint num, int mod, uint difficulty,
                    int floor, int ceiling )
{ return roll_x( num, mod, floor, ceiling ) <= difficulty;
}
