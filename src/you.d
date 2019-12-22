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

  import std.datetime.systime;
  import std.datetime.date;
  // if it is December, the player character starts with a "festive hat"
  if( Clock.currTime().month == Month.dec )
  {
    Item hat = { sym:Symbol(']', Color( CLR_RED, false ) ),
                 type:ITEM_ARMOR, equip:EQUIP_HELMET,
                 addd:0, addm:0,
                 name:"festive hat" };
    u.inventory.items[INVENT_HELMET] = hat;
  }
  
  return u;
}
