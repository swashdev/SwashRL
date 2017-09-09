/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */

import global;

import std.string;

enum MESSAGE_BUFFER_LINES = 1;

static string[MAX_MESSAGE_BUFFER] Messages;
int Buffered_messages;

void clear_messages()
{
  ushort m;
  for( m = 0; m < MAX_MESSAGE_BUFFER; m++ )
    Messages[m] = "\0";
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
  ushort m = MAX_MESSAGE_BUFFER - 1;
  for( ; m > 0; m-- )
  { Messages[m] = Messages[m - 1];
  }
}

void message_history()
{
  import std.string: toStringz;

  clear();
  foreach (m; 0 .. MAX_MESSAGE_BUFFER)
  { mvprintw( m, 0, toStringz(Messages[m]) );
  }
  refresh();
  getch();
}

void read_messages()
{
  while( Buffered_messages > 0 )
  {
    clear_message_line(); // from display.h
    mvprintw( 0, 0, "%s%s",
              toStringz(pop_message()), toStringz(Buffered_messages > 1 ? "  (More)" : "") );
    refresh();
    if( Buffered_messages > 0 )
    { getch();
    }
  }
}

void message(T...)(T args) {
  if( Buffered_messages >= MAX_MESSAGE_BUFFER )
  {
    read_messages();
    getch();
  }

  bump_messages();

  Messages[0] = format( args );
  Buffered_messages += 1;
}
