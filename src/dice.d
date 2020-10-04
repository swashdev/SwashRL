/*
 * Copyright (c) 2017-2020 Philip Pavlick.  See '3rdparty.txt' for other
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
    // `dice` is the number of d6es, `modifier` gets added to the result of
    // the roll
    uint dice;
    int modifier;

    // `floor` and `ceiling` represent an absolute maximum and absolute
    // minimum.  These are enforced after the modifier is added.
    // Note that there is absolutely nothing stopping you from making
    // `ceiling` negative as long as `floor` is lesser or equal.
    int floor, ceiling;
}

// SECTION 2: ////////////////////////////////////////////////////////////////
// Random Number Generators                                                 //
//////////////////////////////////////////////////////////////////////////////

import std.random, std.datetime;

// Hi, my name is Lucky, and I'll be your random number generator today.
static Random Lucky;

// Random Number Generator Settings & Maintenance ////////////////////////////

// Sets the seed for the random number generator `Lucky`.
void set_seed( int fixed_seed )
{
    Lucky = Random( fixed_seed );
}

// Generates a seed for the random number generator `Lucky` from system time.
void seed()
{
    Lucky = Random( cast(int)core.stdc.time.time(null) );
}

// SECTION 3: ////////////////////////////////////////////////////////////////
// Functions to Represent Dicerolls                                         //
//////////////////////////////////////////////////////////////////////////////

// Generic Die-Rolling Functions /////////////////////////////////////////////

// Roll a die.  This function will return a uniform distribution between 1 and
// `sides` (or 0 if `sides` is 0).  The default case is a six-sided die, the
// standard in SwashRL.
int d( uint sides = 6 )
{
    int result = sides;

    if( sides > 1 )
    {
        result = uniform( 1, sides + 1, Lucky );
    }

    return result;
}

// Roll a given `num`ber of dice with the given `sides` and add the given
// `mod`ifier.  The default is 1d6 + 0.  As a general rule, it's best practice
// to add modifiers outside of this function, but `mod` is included for the
// sake of completeness.
int roll( uint num = 1, uint sides = 6, int mod = 0 )
{
    if( num == 0 )
    {
        return mod;
    }

    return d( sides ) + roll( num - 1, sides, mod );
}

// Same as `roll` but with explicit minimum and maximum possible results.
// Note that the number is minmaxed _after_ the modifier is added.
int roll_within( int min, int max, uint num = 1, uint sides = 6,
                 int mod = 0 )
{
    return minmax!int( roll( num, sides, mod ), min, max );
}

// Same as roll_within, but using a `Dicebag` to fill in the relevant data.
int roll_bag( Dicebag dice )
{

    return roll_within( dice.floor, dice.ceiling, dice.dice, 6,
                        dice.modifier );
}

// Non-Standard Die-Rolling Functions ////////////////////////////////////////

// Simulate the roll of a "traditional" ten-sided die, that is a twenty-sided
// die numbered from 0 to 10 twice.  If `num` is greater than 1, simulate the
// rolling of multiple such dice.  `mod` is included for the sake of
// completeness, but as a general rule it's best practice to add the modifier
// in an external function.
int d10( uint num = 1, int mod = 0 )
{
    if( num == 0 )
    {
        return mod;
    }

    auto result = uniform( 0, 20, Lucky );

    if( result > 9 )
    {
        result -= 10;
    }

    return result + d10( num - 1, mod );
}

// Roll a percentile die using the traditional method of rolling two d10s.
// As above, `num` will determine how many percentile dice are rolled and
// `mod` will add a modifier to the result.
int d100( uint num = 1, int mod = 0 )
{
    if( num == 0 )
    {
        return mod;
    }

    int ten = d10(), unit = d10();
    int result = (ten * 10) + unit;

    if( result == 0 )
    {
        result = 100;
    }

    return result + d100( num - 1, mod );
}

// Boolean Dice //////////////////////////////////////////////////////////////

// Gets a random boolean from a simulated coin toss.
bool flip()
{
    return d( 2 ) == 2;
}

// Impossible Dice ///////////////////////////////////////////////////////////

// Return a number between `min` and `max` inclusive without simulating a dice
// roll.  Useful for random number generation, but breaks the theme of using
// dice for everything.
int not_dice( int min, int max )
{
    return uniform( min, max + 1, Lucky );
}

// SECTION 4: ////////////////////////////////////////////////////////////////
// Difficulty Checks                                                        //
//////////////////////////////////////////////////////////////////////////////

// Quickly do a difficulty check.
bool quick_check( uint num, int mod, uint difficulty )
{
    return roll( num, 6, mod ) <= difficulty;
}

// As above, but without modifier.
bool quick_check( uint num, uint difficulty )
{
    return quick_check( num, 0, difficulty );
}

// Quickly do an "extended" difficulty check with minimum and maximum dice
// rolls (using roll_within instead of roll)
bool quick_check_x( uint num, int mod, uint difficulty,
                    int floor, int ceiling )
{
    return roll_within( floor, ceiling, num, 6, mod ) <= difficulty;
}

// As above, but without modifier
bool quick_check_x( uint num, uint difficulty,
                    int floor, int ceiling )
{
    return quick_check_x( num, 0, difficulty, floor, ceiling );
}
