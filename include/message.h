/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */

import global;

static string[MAX_MESSAGE_BUFFER] Messages;

// clear the message buffer
void clear_messages();

// pop and display a message
string pop_message();

// read all messages
void read_messages();

// bump all messages up one in the stack
void bump_messages();

// buffer the message in the message bar
void buffer_message();

// buffer a message
void message( string mess );

// display past messages
void message_history();
