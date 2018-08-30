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

// you.d:  Defines functions related to the player struct

import global;

/++
 + The player struct
 +
 + This struct represents the player character by storing the following
 + values:
 +
 + `sym`: A `symbol` that represents the player's appearance in the display
 +
 + `x` and `y`: `ubyte`s that represent the player's current coordinates
 +
 + `inventory`: An `inven` representing the player's current inventory
 +
 + `attack_roll`: A `dicebag` that represents the player's attack roll
 +/
struct player
{
  symbol sym;
  ubyte x, y;
  int hp;
  inven inventory;
  dicebag attack_roll;
}

/++
 + Initializes the `player`
 +
 + This function does initial setup for the player character and places him or
 + her at the coordinates (x, y).
 +
 + The player's hit dice are defined and rolled here, and the inventory is set
 + (to a bunch of empty items).  The player's symbol is also defined in this
 + function, as are his or her attack dice.
 +
 + The coordinates input into this function are checked against `MAP_X` and
 + `MAP_Y`, and if the function attempts to initialize the player outside this
 + boundary it is fixed.
 +
 + Params:
 +   y = The player's initial y coordinate
 +   x = The player's initial x coordinate
 +
 + Returns:
 +   The `player`
 +/
player init_player( ubyte y, ubyte x )
{
  player u;
  if( x < 80 )
  { u.x = x;
  }
  else
  { u.x = 1;
  }
  if( y < 24 )
  { u.y = y;
  }
  else
  { u.y = 1;
  }
  u.sym = symdata( SMILEY, Color( CLR_WHITE, false ) );
  u.hp = roll( 3, 2 );

  foreach( count; 0 .. 40 )
  { u.inventory.items[count] = No_item;
  }
  u.inventory.quiver_count = 0;
  u.inventory.coins = 0;
  u.attack_roll = Dice( 2, 0, 0, 1000 );
  return u;
}
