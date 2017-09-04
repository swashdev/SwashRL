/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */

// defines a struct ``dicebag'' which stores information about a die roll

import global;

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

dicebag Dice( ubyte d, short m, int f, int c );
