/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */
/* This file stores the functions used for the random number generator and
 * dice-rolling. */

#ifndef RANDOM_H
# define RANDOM_H

# include "global.h"

/* for srand & rand */
# include <stdlib.h>
/* for time */
# include <time.h>

typedef int16 dieroll_t;
static const dieroll_t DIEROLL_T_MAX = MAX_INT16;

/* rng maintenance */

/* force a seed for the random number generator */
void set_seed( int s );
/* seed the random number generator */
void seed();

/* boolean dice */

/* flip a coin */
bool flip();

/* the standard six-sided die */

/* roll a d6 */
dieroll_t d();

/* "special case" dice--the d10, d100, and d2 */

/* roll a traditional d10 numbered from 0 to 9 */
dieroll_t td10();

/* roll a non-traditional d10 numbered from 1 to 10 */
dieroll_t d10();

/* roll a d100 */
dieroll_t d100();

/* first of all, yes, two-sided dice exist, and secondly this is a special case
 * because some random number generators can produce skewed results if we
 * simply use rand() % 2 */
dieroll_t d2();

/* other dice */

/* roll one s-sided die (generic die-roller) */
dieroll_t dn( int8 s );

/* the complete roll function, with modifiers and min and max values */

/* roll `num' d6 with modifier `mod' */
dieroll_t roll( uint8 num, int8 mod );

/* roll `num' d6 with modifier `mod' and minimum & maximum values `floor'
 * and `ceiling' */
dieroll_t roll_x( uint8 num, int8 mod, dieroll_t floor, dieroll_t ceiling );

/* check if the roll of `num' dice passes a check, with `mod' modifier */
/* XXX: If you want to check if a roll is OVER a certain number, you'll want
 * to use `!rollcheck' -- note also that these functions do not check for
 * crits or botches */
bool quickcheck( uint8 num, int8 mod, dieroll_t difficulty );
bool quickcheck_x( uint8 num, int8 mod, dieroll_t difficulty,
                   dieroll_t floor, dieroll_t ceiling );

dieroll_t rollbag( dicebag dice );

#endif /* !def RANDOM_H */
