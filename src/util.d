/*
 * Copyright 2015-2019 Philip Pavlick
 *
 * This software is provided 'as-is', without any express or implied
 * warranty.  In no event will the authors be held liable for any damages
 * arising from the use of this software.
 * 
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 * 
 * 1. The origin of this software must not be misrepresented; you must not
 *    claim that you wrote the original software. If you use this software
 *    in a product, an acknowledgment in the product documentation would be
 *    appreciated but is not required.
 * 2. Altered source versions must be plainly marked as such, and must not be
 *    misrepresented as being the original software.
 * 3. This notice may not be removed or altered from any source distribution.
 */

// util.d:  Defines miscellaneous utility functions

import global;
import std.stdio : File;

/++
 + Quickly checks if a number is within a certain range
 +
 + This function is used to quickly check if a certain value is within a
 + given range.  It returns `true` if floor &lt;= n &lt;= ceil.
 +
 + Params:
 +   n     = The `n`umber to be checked
 +   floor = The lowest acceptable value for n
 +   ceil  = The highest acceptable value for n
 +
 + Returns:
 +   `true` if `floor <= n <= ceil`, `false` otherwise
 +/
bool within_minmax( int n, int floor, int ceil )
{
  if( floor <= n && n <= ceil && floor <= ceil )
  { return true;
  }
  return false;
}

/++
 + Changes a number to be within a certain range
 +
 + This number is used to convert a given number n to a certain range.  It
 + does this by checking n against the floor and `ceil`ing of that range, and
 + alters n if necessary to be within that range.
 +
 + Params:
 +   n     = The `n`umber to be checked
 +   floor = The lowest acceptable value for n
 +   ceil  = The highest acceptable value for n
 +
 + Returns:
 +   n, if `floor < n < ceil`; $(LF)
 +   floor, if `n <= floor`; $(LF)
 +   ceil, if `n >= ceil`; $(LF)
 +   Return value is an `int`
 +/
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

/++
 + Reads a line from a file and strips the newline off the end
 +
 + Params:
 +     fil = The file to be read
 +
 + Returns:
 +     A `string` representing the line read from fil, not including the
 +     newline
 +/
string strip_line( File fil )
{
  char[] line = fil.readln().dup;
  line.length--;
  return cast(string)line;
}
