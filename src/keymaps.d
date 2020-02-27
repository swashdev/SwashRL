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

// An exception used to catch when the programmer has accidentally
// overwritten one of the reserved key commands: Q, ?, v, and @
class InvalidKeymapException : Exception
{
  this( string msg, string file = __FILE__, size_t line = __LINE__ )
  { super( msg, file, line );
  }
}

/////////////////////////////////
// Keymap initializer function //
/////////////////////////////////

// Initializes a keymap from a list of key inputs.
uint[char] keymap( string keylist = "" )
{
  // The standard keymap, which is being overwritten
  char[] kl = "ykuhlbjn.ie,dP S".dup;

  // Check to make sure that the keylist will not overwrite any reserved
  // commands
  if( keylist.length > 0 )
  {
    foreach( c; 0 .. keylist.length )
    {
      switch( keylist[c] )
      {
        default:
          kl[c] = keylist[c];
          break;

        case 'Q':
          throw new InvalidKeymapException(
            "Keymap attempted to overwrite reserved command \'Q\': " ~
            "reserved for \"quit\""
          );

        case '?':
          throw new InvalidKeymapException(
            "Keymap attempted to overwrite reserved command \'?\': " ~
            "reserved for \"help\""
          );

        case 'v':
          throw new InvalidKeymapException(
            "Keymap attempted to overwrite reserved command \'v\': " ~
            "reserved for \"version\""
          );

        case '@':
          throw new InvalidKeymapException(
            "Keymap attempted to overwrite reserved command \'@\': " ~
            "reserved for \"switch control schemes\""
          );
      } // switch( keylist )
    } // foreach( c; 0 .. keylist.length )
  } // if( keylist.length > 0 )

  // Now we define the actual keymap:
  uint[char] ret;

  // Standard movement keys:
  ret[ kl[ 0] ] = MOVE_NW;
  ret[ kl[ 1] ] = MOVE_NN;
  ret[ kl[ 2] ] = MOVE_NE;
  ret[ kl[ 3] ] = MOVE_WW;
  ret[ kl[ 4] ] = MOVE_EE;
  ret[ kl[ 5] ] = MOVE_SW;
  ret[ kl[ 6] ] = MOVE_SS;
  ret[ kl[ 7] ] = MOVE_SE;
  ret[ kl[ 8] ] = MOVE_WAIT;

  // Inventory management
  ret[ kl[ 9] ] = MOVE_INVENTORY;
  ret[ kl[10] ] = MOVE_EQUIPMENT;
  ret[ kl[11] ] = MOVE_GET;
  ret[ kl[12] ] = MOVE_DROP;

  // Message management
  ret[ kl[13] ] = MOVE_MESS_DISPLAY;
  ret[ kl[14] ] = MOVE_MESS_CLEAR;

  // Game management
  ret[ kl[15] ] = MOVE_SAVE;

version( none )
{
  import std.stdio : writeln;

  writeln( "Size of keylsit: ", keylist.length,          "." );
  writeln( "Size of kl:      ", kl.length,              "." );
  writeln( "Size of ret:     ", ret.length,             "." );
  writeln( "Keylist input:   ", keylist,                "." );
  writeln( "kl final value:  ", cast(string)kl,         "." );
  writeln( "final value:     ", cast(string)(ret.keys()), "." );
}

  // Finally, we check the length of the keymap.  If the keymap isn't the same
  // length as `kl', one of the inputs has been defined twice and the control
  // scheme is broken.
  if( ret.length != kl.length )
  {
    throw new InvalidKeymapException( "Invalid keymap defined " ~
      cast(string)kl ~ "Did you map the same key twice?" );
  }

  // Return the keymap
  return ret;

} // int[char] keymap( string )

/////////////
// Keymaps //
/////////////

// A list of labels used to describe keymaps when selecting them.
static string[] Keymap_labels;

// The global list of keymaps.
static uint[char][] Keymaps;

// The index of the control scheme currently in use in `Keymaps`
static uint Current_keymap = 0;
