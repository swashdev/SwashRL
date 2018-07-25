/*
 * Copyright (c) 2016-2018 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */

// Declares a function `keymap' which returns an associative array
// representing a control scheme.

import global;

// An exception used to catch when the programmer has accidentally overwritten
// one of the reserved key commands: Q, ?, v, and @
class InvalidKeymapException : Exception
{
  this( string msg, string file = __FILE__, size_t line = __LINE__ )
  { super( msg, file, line );
  }
}

// Takes in a `string' which represents the list of commands as keypresses.
// If `keylist' isn't long enough to fill the keymap, the remaining keys
// are left as standard.  The order of the commands is the same as in
// ``moves.d''.
// QUIT, HELP, VERSION, AND "SWITCH CONTROL SCHEMES" ARE *NOT* HANDLED BY
// THIS ARRAY; THEY ARE STATIC AND DECLARED GLOBALLY IN ``keys.d''
uint[char] keymap( string keylist = "" )
{
  // The standard keymap, which is being overwritten
  string kl = "ykuhlbjn. iw,P ";

  // Check to make sure that the keylist will not overwrite any reserved
  // commands
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
        break;

      case '?':
        throw new InvalidKeymapException(
          "Keymap attempted to overwrite reserved command \'?\': " ~
          "reserved for \"help\""
        );
        break;

      case 'v':
        throw new InvalidKeymapException(
          "Keymap attempted to overwrite reserved command \'v\': " ~
          "reserved for \"version\""
        );
        break;

      case '@':
        throw new InvalidKeymapException(
          "Keymap attempted to overwrite reserved command \'@\': " ~
          "reserved for \"switch control schemes\""
        );
        break;
    } // switch( keylist )
  } // foreach( c; 0 .. keylist.length )

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

  // Menu management
  ret[ kl[ 9] ] = MOVE_MENU_SELECT;

  // Inventory management
  ret[ kl[10] ] = MOVE_INVENTORY;
  ret[ kl[11] ] = MOVE_WIELD;
  ret[ kl[12] ] = MOVE_GET;

  // Message management
  ret[ kl[13] ] = MOVE_MESS_DISPLAY;
  ret[ kl[14] ] = MOVE_MESS_CLEAR;

  // Finally, we check the length of the keymap.  If the keymap isn't the same
  // length as `kl', one of the inputs has been defined twice and the control
  // scheme is broken.
  if( ret.length != kl.length )
  {
    throw new InvalidKeymapException( "Invalid keymap defined--" ~
      "Did you map the same key twice?" );
  }

  // Return the keymap
  return ret;

} // int[char] keymap( string )
