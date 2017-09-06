/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */

import global;

bool within_minmax( int n, int floor, int ceil )
{
  if( floor <= n && n <= ceil && floor <= ceil )
  { return true;
  }
  return false;
}

int minmax( int n, int floor, int ceil )
{
  if( floor == ceil )
  { return floor;
  }
  if( floor > ceil )
  { return n;
  }
  return floor > n ? floor : ceil < n ? ceil : n;
}
