/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */
#include "global.h"

bool within_minmax( int n, int floor, int ceil )
{
  if( floor <= n && n <= ceil && floor <= ceil )
  { return TRUE;
  }
  return FALSE;
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

char lowercase( char in )
{
  if( in >= 'A' && in <= 'Z' )
  { in += ('a' - 'A');
  }
  return in;
}

char uppercase( char in )
{
  if( in >= 'a' && in <= 'z' )
  { in -= ('a' - 'A');
  }
  return in;
}
