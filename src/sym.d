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

import global;

// the `symbol' struct, used to store information about symbols in the
// game.

/++
 + A struct used to store symbols
 +
 + This is the base symbol struct, used to store information governing
 + symbols.  As it currently exists, it only works for the curses and SDL
 + terminal interfaces, but in the future it can be expanded to also use
 + images for a full graphical version of the game.
 +
 + This struct contains a `char`, `ch`, which represents what character is
 + used to represent the symbol in text-based displays; and a `Color` called
 + `color` which is used to determine the color that `ch` is drawn in.
 +/
struct Symbol
{
  char ch;

  Color color;

  // further members of this struct will be used when SDL is implemented for
  // images (possibly including sprites in the future)
}

/++
 + Generates a new `Symbol`
 +
 + This function is a simple constructor for a `Symbol`.
 +
 + Deprecated:
 +   This function has exactly the same function and parameters as D's
 +   generic struct constructor, so use that instead.
 +
 + Params:
 +   character = The `char` used to represent the `Symbol` in text-based
 +               displays
 +   color     = A `Color` used to determine what color character will be
 +               drawn in
 +
 + Returns:
 +   A `Symbol` containing character and color
 +/
Symbol symdata( char character, Color color )
{

  Symbol ret;
  ret.ch = character;
  ret.color = color;

  return ret;
}
