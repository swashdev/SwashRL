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

// monst.d: defines structs and functions related to monsters and monster
// generation

import global;
import std.string : format;

// SECTION 1: ////////////////////////////////////////////////////////////////
// Monster Generation Templates                                             //
//////////////////////////////////////////////////////////////////////////////

// A struct containing data used to generate monsters from a template.
struct Mon
{
    Symbol sym;
    string name;
    Locomotion swim;
    Dicebag hit_dice;
    Dicebag attack_roll;
}

// SECTION 2: ////////////////////////////////////////////////////////////////
// Monster Data                                                             //
//////////////////////////////////////////////////////////////////////////////

// A struct used to store `Monst`er data.  Note that, unlike with items,
// monsters store their own map coordinates.
struct Monst
{
    Symbol sym;
    string name;
    int hit_points;

    // The monster's physical stats.
    int str; // strength
    int end; // endurance

    Locomotion walk;
    Dicebag attack_roll;
    ubyte x, y;

    // The monster's open inventory.  By default all monsters get 24 stacks of
    // items, but in future versions this may vary.
    Item[] inventory;

    // The monster's wallet.  This is used to hold coins in various
    // denominations.
    Item[5] wallet;

    // The monster's equipped items.  This is a dynamic associative array
    // that uses the `Slot` enum to label items that the monster has equipped.
    // In future versions of the software, what slots are available to a
    // monster will depend on what body parts they have.
    Item[Slot] equipment;
}

// SECTION 3: ////////////////////////////////////////////////////////////////
// Accessing Monster Data                                                   //
//////////////////////////////////////////////////////////////////////////////

// Returns the monster's name.  If the monster is identified as the player,
// returns "you".  This function is used for formatting messages.
string monst_name( Monst mon )
{
    if( mon.name == "spelunker" )
    {
        return "you";
    }

    return mon.name;
}

// Returns the string "the %s," where %s is the name of the given monster,
// unless the monster is identified as the player, in which case "you" is
// returned instead.  Much like `monst_name`, this function is used for
// formatting messages.
string the_monst( Monst mon )
{
    if( mon.name == "spelunker" )
    {
        return "you";
    }

    return format( "the %s", mon.name );
}

// The same as `the_monst`, but with a capital first letter, used at the start
// of sentences.
string The_monst( Monst mon )
{
    if( mon.name == "spelunker" )
    {
        return "You";
    }

    return format( "The %s", mon.name );
}
