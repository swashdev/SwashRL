/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */
#include "random.h"

/* rng maintenance */

/* random number generator seed */

void set_seed( int s )
{ srand( s );
}

void seed()
{ srand( time( NULL ) );
}

/* boolean dice */

/* flip a coin */
bool flip()
{ return rand() % 1;
}

/* the standard six-sided die */

/* roll a d6 */
dieroll_t d()
{ return (dieroll_t)(rand() % 6) + 1;
}

/* roll a d6 with modifier */
dieroll_t dm( int8 mod )
{ return (d() + mod);
}

/* "special case" dice--the d10, d100, and d2 */

/* for true old-school, we're using the old-fashioned d10 fashioned out of a
 * d20 that has been numbered from 0 to 9 twice */
dieroll_t td10()
{
  dieroll_t result = (dieroll_t)(rand() % 20);
  if( result > 9 )
  { result -= 10;
  }
  return result;
}

/* a non-traditional d10 numbered from 1 to 10 */
dieroll_t d10()
{
  dieroll_t result = td10();
  return result == 0 ? (dieroll_t)10 : result;
}

/* again, going by tradition, use 2 d10s to determine the result of a d100
 * roll.  Zocchi, I love you, but the 100-sided die is a little ridiculous */
dieroll_t d100()
{
  dieroll_t t = td10(), u = td10();
  if( t == 0 && u == 0 )
  { return (dieroll_t)100;
  }
  return (t * 10) + u;
}

/* roll one 2-sided die */
dieroll_t d2()
{ return rand() % 1;
}

/* roll one s-sided die */
dieroll_t dn( int8 s )
{
  /* if sides == 1, just return 1.  if sides == 0, return 0.
   * if sides < 0, force that result (e.g. -4 always produces 4) */
  if( s < 2 )
  {
    if( s >= 0 )
    { return (dieroll_t)s;
    }
    return (dieroll_t)(-1) * s;
  }
  return (dieroll_t)(rand() % s) + 1;
}

/* the complete roll function */
dieroll_t roll( uint8 num, int8 mod )
{
  if( num == 0 )
  { return mod;
  }

  dieroll_t result = d();

  uint8 dice;
  for( dice = num - 1; dice > 0; dice-- )
  { result += d();
  }

  return result + mod;
}

dieroll_t roll_x( uint8 num, int8 mod, dieroll_t floor, dieroll_t ceiling )
{
  if( num == 0 )
  { return mod;
  }

  dieroll_t result = 0;
  uint8 dice;
  for( dice = num - 1; dice > 0; dice-- )
  {
    if( result >= DIEROLL_T_MAX - 5 )
    { break;
    }
    result += d();
  }

#ifdef MAXIMUM_DIE_ROLL
  if( result > MAXIMUM_DIE_ROLL )
  { result = MAXIMUM_DIE_ROLL;
  }
#endif
#ifdef MINIMUM_DIE_ROLL
  if( result < MINIMUM_DIE_ROLL )
  { result = MINIMUM_DIE_ROLL;
  }
#endif
  return minmax( result, floor, ceiling ) + mod;
}

bool quickcheck( uint8 num, int8 mod, dieroll_t difficulty )
{ return roll( num, mod ) <= difficulty;
}

bool quickcheck_x( uint8 num, int8 mod, dieroll_t difficulty,
                    dieroll_t floor, dieroll_t ceiling )
{ return roll_x( num, mod, floor, ceiling ) <= difficulty;
}

dieroll_t rollbag( dicebag dice )
{ return roll_x( dice.dice, dice.modifier, dice.floor, dice.ceiling );
}
