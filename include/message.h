/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */
#ifndef MESSAGE_H
# define MESSAGE_H

# include "global.h"

# ifndef MAX_MESSAGE_BUFFER
#  define MAX_MESSAGE_BUFFER 20
# endif /* !MAX_MESSAGE_BUFFER */

static str Messages[MAX_MESSAGE_BUFFER];
# if MAX_MESSAGE_BUFFER > 255
static uint16 Buffered_messages;
# else
static uint8 Buffered_messages;
# endif /* MAX_MESSAGE_BUFFER > 255 */

/* clear the message buffer */
void clear_messages();

/* pop and display a message */
str pop_message();

/* read all messages */
void read_messages();

/* bump all messages up one in the stack */
void bump_messages();

/* buffer the message in the message bar */
void buffer_message();

/* buffer a message */
void message( str mess );

/* display past messages */
void message_history();

#endif /* MESSAGE_H */
