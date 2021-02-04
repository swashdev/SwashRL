/*
 * Copyright (c) 2015-2021 Philip Pavlick.  See '3rdparty.txt' for other
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

// As of version 0.028, the "Player" is just an alias for a regular monster
alias Player = Monst;

// Returns "true" if the given monster is you.
bool is_you( Monst mon )
{
    return mon.name == "spelunker";
}

// Initializes the player character and places it at the given coordinates.
Player init_player( ubyte y, ubyte x )
{
    Player player;

    // The "spelunker" name should ONLY be used for the player character, and
    // is a signal to monster movement functions that the monster is "you."
    player.name = "spelunker";

    if( x < 80 )
    {
        player.x = x;
    }
    else
    {
        player.x = 1;
    }
    if( y < 24 )
    {
        player.y = y;
    }
    else
    {
        player.y = 1;
    }

    player.sym = Symbol( SMILEY, Colors.Player );
    player.hit_points = roll( 3 ) + 2;

    player.inventory = init_inven();

    player.attack_roll = Dicebag( 2, 0, 0, 1000 );

    player.walk = Locomotion.terrestrial;

    player.str = roll( 3 );
    player.end = roll( 3 );

    import std.datetime.systime;
    import std.datetime.date;
    // if it is December, the player character starts with a "festive hat"
    if( Clock.currTime().month == Month.dec )
    {
        Item hat = Item( Symbol( ']', Colors.Red ), "festive hat",
                         Type.armor, Armor.helmet, 0, 0 );
        player.inventory.items[INVENT_HELMET] = hat;
    }
  
    return player;
} // player init_player( ubyte, ubyte )
