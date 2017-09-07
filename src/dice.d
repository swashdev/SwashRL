/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
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
{ return (d2() == 1);
}

// the standard six-sided die //

// roll a d6
int d()
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
  return cast(int)result;
}

// a non-traditional d10 numbered from 1 to 10
