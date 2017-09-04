/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */

import global;

void display( ubyte y, ubyte x, symbol s, bool center );

void display_player( player u );

void display_mon( monst m );

void display_map_mons( map to_display );

void display_map( map to_display );

void display_map_all( map to_display );

void clear_message_line();

void display_map_and_player( map to_display, player u );

void refresh_status_bar( player* u );
