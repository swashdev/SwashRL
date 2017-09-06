/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */

import global;

import std.random, std.datetime;

// Hi, my name is Lucky, and I'll be your random number generator today.
static RandomGen Lucky;

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
int d10()
{
  int result = td10();
  return result == 0 ? 10 : result;
}

// again, going by tradition, use 2 d10s to determine the result of a d100
// roll.  Zocchi, I love you, but the 100-sided die is a little ridiculous
int d100()
{
  int t = td10(), u = td10();
  if( t == 0 && u == 0 )
  { return 100;
  }
  return (t * 10) + u;
}

// roll one 2-sided die
int d2()
{ return uniform( 1, 3, Lucky );
}

// roll one s-sided die
int dn( int8 s )
{
  // if sides == 1, just return 1.  if sides == 0, return 0.
  if( s < 2 )
  { return s;
  }
  return uniform( 1, s + 1, Lucky );
}

// the complete roll function
int roll( ubyte num, byte mod )
{
  if( num == 0 )
  { return mod;
  }

  int result = d();

  ubyte dice;
  for( dice = num - 1; dice > 0; dice-- )
  { result += d();
  }

  return result + mod;
}

int roll_x( ubyte num, byte mod, int floor, int ceiling )
{
  if( num == 0 )
  { return mod;
  }

  dieroll_t result = 0;
  uint8 dice;
  for( dice = num - 1; dice > 0; dice-- )
  { result += d();
  }

  if( result > MAXIMUM_DIE_ROLL )
  { result = MAXIMUM_DIE_ROLL;
  }
  if( result < MINIMUM_DIE_ROLL )
  { result = MINIMUM_DIE_ROLL;
  }

  return minmax( result, floor, ceiling ) + mod;
}

bool quickcheck( ubyte num, byte mod, int difficulty )
{ return roll( num, mod ) <= difficulty;
}

bool quickcheck_x( ubyte num, byte mod, int difficulty,
                   int floor, int ceiling )
{ return roll_x( num, mod, floor, ceiling ) <= difficulty;
}

dieroll_t rollbag( dicebag dice )
{ return roll_x( dice.dice, dice.modifier, dice.floor, dice.ceiling );
}
