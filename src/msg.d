/*
 * Copyright (c) 2016-2018 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */

import global;

import std.string;
import std.container : DList;
public import std.range.primitives : popFront;

enum MESSAGE_BUFFER_LINES = 1;

// `Messages' is used for new messages...
DList!string Messages;

// ...whereas `Message_history' is used for stored previous messages which can
// be read by the P key prompt
string[] Message_history;

void clear_messages()
{ Messages.clear();
}

string pop_message()
{
  if( Messages.empty() )
  { return "";
  }

  string ret = Messages.front;
  Messages.removeFront();
  return ret;
}

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
