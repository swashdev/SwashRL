/*
 * Copyright (c) 2016-2018 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */

import global;

import std.string;
import std.container : DList;
import std.range.primitives : popFront;

enum MESSAGE_BUFFER_LINES = 1;

DList!string Messages;

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
{ Messages.insertBack( format( args ) );
}
