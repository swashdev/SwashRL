/*
 * Copyright 2016-2019 Philip Pavlick
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License.  You may obtain a copy
 * of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * SwashRL is distributed with a special exception to the normal Apache
 * License 2.0.  See LICENSE for details.
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
