/*
 * Copyright 2016-2019 Philip Pavlick
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License.  You may obtain a copy
 * of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * SwashRL is distributed with a special exception to the normal Apache
 * License 2.0.  See LICENSE for details.
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
