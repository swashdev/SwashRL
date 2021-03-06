/*
 * Copyright (c) 2015-2020 Philip Pavlick.  See '3rdparty.txt' for other
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

// keymaps.d: defines structures called "keymaps" used to store control
// schemes as well as functions used to define them

import global;

// SECTION 1: ////////////////////////////////////////////////////////////////
// Exceptions                                                               //
//////////////////////////////////////////////////////////////////////////////

// An exception used to catch when the programmer has accidentally
// overwritten one of the reserved key commands: Q, ?, v, and @
class Invalid_Keymap_Exception : Exception
{
    this( string msg, string file = __FILE__, size_t line = __LINE__ )
    {
        super( msg, file, line );
    }
}

// SECTION 2: ////////////////////////////////////////////////////////////////
// Keymap initializer function                                              //
//////////////////////////////////////////////////////////////////////////////

// keymaps are an associative array of `Move` values indexed with `char`
// variables.
alias keymap = Move[char];

// Initializes a keymap from a list of key inputs.
keymap new_keymap( string keylist = "" )
{
    // The standard keymap, which is being overwritten
    char[] keys = "ykuhlbjn.ie,dP S".dup;

    // Check to make sure that the keylist will not overwrite any reserved
    // commands
    if( keylist.length > 0 )
    {
        foreach( count; 0 .. keylist.length )
        {
            switch( keylist[count] )
            {
                default:
                    keys[count] = keylist[count];
                    break;

                case 'Q':
                    throw new Invalid_Keymap_Exception(
                            "Keymap attempted to overwrite reserved command "
                            ~ "\'Q\': reserved for \"quit\"" );

                case '?':
                    throw new Invalid_Keymap_Exception(
                            "Keymap attempted to overwrite reserved command "
                            ~ "\'?\': reserved for \"help\"" );

                case 'v':
                    throw new Invalid_Keymap_Exception(
                            "Keymap attempted to overwrite reserved command "
                            ~ "\'v\': reserved for \"version\"" );

                case '@':
                    throw new Invalid_Keymap_Exception(
                            "Keymap attempted to overwrite reserved command "
                            ~ "\'@\': reserved for \"switch control schemes\""
                            );
            } // switch( keylist[count] )
        } // foreach( count; 0 .. keylist.length )
    } // if( keylist.length > 0 )

    // Now we define the actual keymap:
    keymap ret;

    // Standard movement keys:
    ret[ keys[ 0] ] = Move.northwest;
    ret[ keys[ 1] ] = Move.north;
    ret[ keys[ 2] ] = Move.northeast;
    ret[ keys[ 3] ] = Move.west;
    ret[ keys[ 4] ] = Move.east;
    ret[ keys[ 5] ] = Move.southwest;
    ret[ keys[ 6] ] = Move.south;
    ret[ keys[ 7] ] = Move.southeast;
    ret[ keys[ 8] ] = Move.wait;

    // Inventory management
    ret[ keys[ 9] ] = Move.inventory;
    ret[ keys[10] ] = Move.equipment;
    ret[ keys[11] ] = Move.get;
    ret[ keys[12] ] = Move.drop;

    // Message management
    ret[ keys[13] ] = Move.check_messages;
    ret[ keys[14] ] = Move.clear_message;

    // Game management
    ret[ keys[15] ] = Move.save;

    // Finally, we check the length of the keymap.  If the keymap isn't the
    // same length as `keys`, one of the inputs has been defined twice and the
    // control scheme is broken.
    if( ret.length != keys.length )
    {
        throw new Invalid_Keymap_Exception( "Invalid keymap defined " ~
            cast(string)keys ~ "  Did you map the same key twice?" );
    }

    // Return the keymap
    return ret;
} // keymap new_keymap( string? )

// SECTION 3: ////////////////////////////////////////////////////////////////
// Static variables used to store keymaps                                   //
//////////////////////////////////////////////////////////////////////////////

// A list of labels used to describe keymaps when selecting them.
static string[] Keymap_labels;

// The global list of keymaps.
static keymap[] Keymaps;

// The index of the control scheme currently in use in `Keymaps`
static uint Current_keymap = 0;
