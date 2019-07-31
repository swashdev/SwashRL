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

// msg.d:  Declares the global message buffers and functions used to handle
// them

import global;

import std.string;
import std.container : DList;
public import std.range.primitives : popFront;

enum MESSAGE_BUFFER_LINES = 1;

/++
 + The message queue
 +
 + This is a global `DList` used as a queue to store messages that are
 + waiting to be output to the user.  This queue stores messages until the
 + end of the player's and monsters' turns, whereupon `main` calls the message
 + functions which empty this queue out.
 +
 + This queue is populated by the `message` function and is manipulated by
 + the `pop_message` and `clear_messages` functions.
 +
 + See_Also:
 +   <a href="#Message_history">Message_history</a>
 +/
DList!string Messages;

/++
 + The message buffer
 +
 + This is a global array of `string`s which is used for storing the player's
 + message history.  This array will be populated by a maximum of
 + `MAX_MESSAGE_BUFFER` messages which can be read back to the player on
 + demand.
 +
 + This array is populated by the `message` function.
 +
 + See_Also:
 +   <a href="#Messages">Messages</a>
 +/
string[] Message_history;

/++
 + Clears the message queue
 +/
void clear_messages()
{ Messages.clear();
}

/++
 + Pops the first message in the message queue
 +
 + This function gets the first message in `Messages` and removes it from the
 + queue.  If `Messages` is empty, an empty string is returned.
 +
 + Each call of this function will cause the `string` at the front of
 + `Messages` to be removed, unless `Messages` was already empty.
 +
 + See_Also:
 +   <a href="#Messages">Messages</a>
 +
 + Returns:
 +   The `string` which was at the front of `Messages` when the function was
 +   called, or an empty `string` (`""`) if `Messages` was already empty.
 +/
string pop_message()
{
  if( Messages.empty() )
  { return "";
  }

  string ret = Messages.front;
  Messages.removeFront();
  return ret;
}

/++
 + Adds a message to the message queue
 +
 + This function takes in a message and appends it at the back of the
 + `Messages` queue and the `Message_history` array.  The message is formatted
 + from a generic "args" template, allowing the message to be formatted during
 + the function call.
 +
 + See_Also:
 +   <a href="#Messages">Messages</a>,
 +   <a href="#Message_history">Message_history</a>
 +
 + Examples:
 +   ---
 +   // Appends "Hello, world!" to the back of the message queue:
 +   message( "Hello, world!" );
 +   ---
 +   ---
 +   // Appends "The goobling attacks you!" to the back of the message queue:
 +   message( "The %s attacks you!", "goobling" );
 +   ---
 +   ---
 +   // Appends "You eat 3 hamburgers." to the back of the message queue:
 +   message( "You eat %d hamburgers.", 3 );
 +   ---
 +
 + Params:
 +   args = Formatting arguments for the message to be appended to `Messages`
 +/
void message( T... )(T args)
{
  // Append the message to the message buffer...
  Messages.insertBack( format( args ) );

  // ...and to the message history.
  Message_history ~= format( args );

  // Truncate the message buffer when it exceeds the maximum set length:
  if( Message_history.length > MAX_MESSAGE_BUFFER )
  { Message_history = Message_history[1 .. (MAX_MESSAGE_BUFFER + 1)];
  }
}
