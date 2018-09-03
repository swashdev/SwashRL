/*
 * Copyright 2016-2018 Philip Pavlick
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License, excepting that
 * Derivative Works are not required to carry prominent notices in changed
 * files.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
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
