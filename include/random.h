/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */

// This file stores the functions used for the random number generator and
// dice-rolling.


import global;

import std.random;

// rng maintenance //

static RandomGen Lucky;

// force a seed for the random number generator
void set_seed( int s );
// seed the random number generator
void seed();

// boolean dice //

// flip a coin
bool flip();

// the standard six-sided die //

// roll a d6
int d();

// "special case" dice--the d10, d100, and d2 //

// roll a traditional d10 numbered from 0 to 9
int td10();

// roll a non-traditional d10 numbered from 1 to 10
int d10();

// roll a d100
int d100();

// yes, two-sided dice exist
int d2();

// other dice //

// roll one s-sided die (generic die-roller)
int dn( ushort s );

// the complete roll function, with modifiers and min and max values //

// roll `num' d6 with modifier `mod'
int roll( ushort num, ushort mod );

// roll `num' d6 with modifier `mod' and minimum & maximum values `floor'
// and `ceiling'
int roll_x( ushort num, ushort mod, int floor, int ceiling );

// check if the roll of `num' dice passes a check, with `mod' modifier
// XXX: If you want to check if a roll is OVER a certain number, you'll want
// to use `!rollcheck' -- note also that these functions do not check for
// crits or botches
bool quickcheck( ushort num, ushort mod, int difficulty );
bool quickcheck( ushort num, ushort mod, int difficulty,
                 int floor, int ceiling );

int rollbag( dicebag dice );
