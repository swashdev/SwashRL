/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */
#include "global.h"

#include <stdio.h>
#include <string.h>

#if MAX_MESSAGE_BUFFER > 255
# define mindex  uint16
#else
# define mindex  uint8
#endif /* MAX_MESSAGE_BUFFER > 255 */

void clear_messages()
{
  mindex m;
  for( m = 0; m < MAX_MESSAGE_BUFFER; m++ )
    Messages[m] = "\0";
  Buffered_messages = 0;
}

str pop_message()
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
  mindex m = MAX_MESSAGE_BUFFER - 1;
  for( ; m > 0; m-- )
  { Messages[m] = Messages[m - 1];
  }
}

void message_history()
{
  mindex m;
  clear();
  for( m = 0; m < MAX_MESSAGE_BUFFER; m++ )
  { mvprintw( m, 0, Messages[m] );
  }
  refresh();
  getch();
}

void read_messages()
{
  while( Buffered_messages > 0 )
  {
    clear_message_line(); /* from display.h */
    mvprintw( 0, 0, "%s%s",
              pop_message(), Buffered_messages > 1 ? "  (More)" : "" );
    refresh();
    if( Buffered_messages > 0 )
      getch();
  }
}

void message( str mess )
{
  if( Buffered_messages >= MAX_MESSAGE_BUFFER )
  {
    read_messages();
    getch();
  }

  bump_messages();

  Messages[0] = mess;
  Buffered_messages += 1;
}

void buffer_message()
{
  uint8 x;
  str buf = (str) malloc( 81 * (sizeof (char)) );
  for( x = 0; x < 80; x++ )
  {
    buf[x] = mvinch( 0, x );
    /* terminate the string if we get three spaces in a row */
    if( x >= 3 )
    {
      if( buf[x] == ' ' && buf[x - 1] == ' ' && buf[x - 2] == ' ' )
      {
        buf[x - 2] = '\0';
        break;
      }
    }
  }

  clear_message_line();
  
  buf[80] = '\0';
  message( buf );
}

#if 0
void fmessage( const str mess, ... )
{
  str str;
  va_list args;
  

  if( len > 0 )
  { 
    message( str );
    free( str );
  }
  else
  {
    free( str );
    panic( SP_MEMORY_ALLOCATION_ERROR );
  }
}
#endif

#undef  mindex
