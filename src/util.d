/*
 * Copyright (c) 2015-2019 Philip Pavlick.  See '3rdparty.txt' for other
 * licenses.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *  * Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *  * Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *  * Neither the name of the SwashRL project nor the names of its
 *    contributors may be used to endorse or promote products derived from
 *    this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
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
