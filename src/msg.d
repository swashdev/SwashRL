/*
 * Copyright (c) 2016-2018 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */

import global;

import std.string;

enum MESSAGE_BUFFER_LINES = 1;

static string[] Messages;

void clear_messages()
{
  Messages.length = 0;
}

string pop_message()
{
  string ret = "";
  if( Messages.length > 0 )
  {
    ret = Messages[$-1];
    Messages.length--;
  }

  return ret;
}

void message( T... )(T args)
{
  Messages = format( args ) ~ Messages;
}
