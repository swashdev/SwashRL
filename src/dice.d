/*
 * Copyright (c) 2016-2018 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */

import global;

import core.stdc.time;

struct dicebag
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

dicebag Dice( ubyte d, short m, int f, int c )
{ 
  dicebag r = { dice:d, modifier:m, floor:f, ceiling:c };
  return r;
}

import std.random, std.datetime;

// Hi, my name is Lucky, and I'll be your random number generator today.
static Random Lucky;

// rng maintenance //

void set_seed( int s )
{ Lucky = Random( s );
}

void seed()
{ Lucky = Random( cast(int)core.stdc.time.time(null) );
}

// boolean dice

// flip a coin
bool flip()
{ return cast(bool)uniform( 0, 2, Lucky );
}

// the standard six-sided die //

// roll a d6
uint d()
{ return uniform( 1, 7, Lucky );
}

// roll a d6 with modifier
int dm( byte mod )
{ return (d() + mod);
}

// "special case" dice--the d10, d100, and d2 //

// for true old-school, we're using the old-fashioned d10 fashioned out of a
// d20 that has been numbered from 0 to 9 twice
int td10()
{
  auto result = uniform( 1, 21, Lucky );
  if( result > 9 )
  { result -= 10;
  }
  return result;
}

/* a non-traditional d10 numbered from 1 to 10 */
uint d10()
{
  uint result = td10();
  return result == 0 ? 10 : result;
} 

/* again, going by tradition, use 2 d10s to determine the result of a d100
 * roll.  Zocchi, I love you, but the 100-sided die is a little ridiculous */
uint d100()
{
  uint t = td10(), u = td10();
  if( t == 0 && u == 0 )
  { return 100;
  } 
  return (t * 10) + u;
} 

/* roll one 2-sided die */
uint d2()
{ return uniform( 1, 3 );
} 

/* roll one s-sided die */
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

/* the complete roll function */
uint roll( uint num, int mod )
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

/* the complete roll function with floor and ceiling */
uint roll_x( uint num, int mod, uint floor, uint ceiling )
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

/* roll a set of dice determined by a `dicebag' struct */
uint rollbag( dicebag dice )
{ return roll_x( dice.dice, dice.modifier, dice.floor, dice.ceiling );
}

/* the `quickcheck' functions quickly check a difficulty check.  returns
 * `true' if the roll is LESS THAN OR EQUAL TO the difficultry rating.
 */
bool quickcheck( uint num, int mod, uint difficulty )
{ return roll( num, mod ) <= difficulty;
}

/* `quickcheck' with floor and ceiling */
bool quickcheck_x( uint num, int mod, uint difficulty,
                   uint floor, uint ceiling )
{ return roll_x( num, mod, floor, ceiling ) <= difficulty;
}
