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
