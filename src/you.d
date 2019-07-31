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

// you.d:  Defines functions related to the player struct

import global;

/++
 + The player struct
 +
 + Deprecated:
 +   The player character is now a `Monst` as of development version 0.028.
 +   This is done to allow monsters to behave more like the player, and to
 +   reduce the amount of special-casing that must be done when calculating
 +   how monsters react to the environment versus the player.
 +
 +   Use the `Monst` struct to generate the player, and simply keep that
 +   `Monst` separate from the monster containers in maps to separate the
 +   player from monsters.
 +
 + Date:  2018-09-01
 +/
alias Player = Monst;

/++
 + Returns `true` if the given monster is you
 +
 + This function checks if the given `Monst`'s `name` is `"spelunker"`, and
 + returns `true` if it is so.  This function is used to distinguish the
 + player character from other monsters.
 +
 + Date:  2018-09-01
 +
 + Params:
 +   u = The `Monst`er to be checked
 +
 + Returns:
 +   u.name == "spelunker"
 +/
bool is_you( Monst u )
{ return u.name == "spelunker";
}

/++
 + Initializes the `Player`
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
 + Date:  2018-09-01
 +
 + Params:
 +   y = The player's initial y coordinate
 +   x = The player's initial x coordinate
 +
 + Returns:
 +   The `Player`
 +/
Player init_player( ubyte y, ubyte x )
{
  Player u;

  // The "spelunker" name should ONLY be used for the player character, and
  // is a signal to monster movement functions that the monster is "you."
  u.name = "spelunker";

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

  u.fly  = 0;
  u.swim = 0;
  return u;
}
