/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */
/* defines a struct ``dicebag'' which stores information about a die roll */

#ifndef DICE_H
# define DICE_H

# include "global.h"

typedef struct
{
  /* `dice' is the number of d6es, `modifier' gets added to the result of the
   * roll automatically if you use ndm or nroll */
  uint8 dice; int16 modifier;
  /* `floor' and `ceiling' represent an absolute maximum and absolute minimum.
   * these are enforced after the modifier is added.  If `floor' < `ceiling',
   * use the global limits.  Note that there is absolutely nothing stopping
   * you from making `ceiling' negative as long as `floor' is lesser or equal.
   */
  int32 floor, ceiling;
} dicebag;

dicebag Dice( uint8 d, int16 m, int32 f, int32 c );

#endif /* !DICE_H */
