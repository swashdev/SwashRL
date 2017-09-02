/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */
#ifndef DISPLAY_H
# define DISPLAY_H

# include "global.h"

void display( uint8 y, uint8 x, symbol s, bool center );

void display_player( player u );

void display_mon( monst m );

void display_map_mons( map to_display );

void display_map( map to_display );

void display_map_all( map to_display );

void clear_message_line();

void display_map_and_player( map to_display, player u );

void refresh_status_bar( player* u );

#if 0
/* If no version of curses is being used, use this array to store the output
 * to the screen. */
static char output[MAP_Y + RESERVED_LINES][MAP_X];

void display( map to_display, player u, bool skip_message_line );

# endif /* ANY_CURSES */

#endif /* !def DISPLAY_H */
