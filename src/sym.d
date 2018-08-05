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

import global;

// the `symbol' struct, used to store information about symbols in the
// game.

struct symbol
{
  char ch;

static if( CURSES_ENABLED )
{
  // attr_t from curses--note that the attribute values also store color,
  // hence the name
  attr_t color;
}
else
{
  ulong color;
}

  // further members of this struct will be used when SDL is implemented for
  // images (possibly including sprites in the future)
}

symbol symdata( char character, ulong effects )
{

  symbol ret;
  ret.ch = character;

static if( CURSES_ENABLED )
{
  ret.color = cast(attr_t)effects;
}
else
{
  ret.color = effects;
}

  return ret;
}
