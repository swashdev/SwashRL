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
int Buffered_messages;

void clear_messages()
{
  ushort m;
  for( m = 0; m < Buffered_messages; m++ )
  { Messages[m] = "\0";
  }
  Buffered_messages = 0;
}

string pop_message()
{
  if( Buffered_messages > 0 )
  {
    Buffered_messages -= 1;
    return Messages[Buffered_messages];
  }
  return "\0";
}

void bump_messages()
{
  if( Buffered_messages > Messages.length )
  { Messages.length++;
  }

  ushort m = Buffered_messages - 1;
  for( ; m > 0; m-- )
  { Messages[m] = Messages[m - 1];
  }
}

void message( T... )(T args)
{
  bump_messages();

  Messages[0] = format( args );
  Buffered_messages += 1;
}
