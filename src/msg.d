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
  if( Messages.length > 0 )
  {
    string ret = Messages[$-1];
    Messages.length--;
  }
}

void bump_messages()
{
  if( Buffered_messages > Messages.length )
  { Messages.length++;
  }

  uint m = Buffered_messages - 1;
  for( ; m > 0; m-- )
  { Messages[m] = Messages[m - 1];
  }
}

void message( T... )(T args)
{
  Messages = format( args ) ~ Messages;
}
