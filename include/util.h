/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */

// some utility functions

// returns whether floor <= n <= ceil, automatic FALSE if floor > ceil
bool within_minmax( int n, int floor, int ceil );

// if floor > ceil, return n
// if n < floor, return floor
// if n > ceil, return ceil
// otherwise return n
int minmax( int n, int floor, int ceil );
