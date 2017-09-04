/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */

import global;

int getcommand( bool alt_hjkl );

void getdydx( ubyte dir, byte* dy, byte* dx );

ubyte umove( player* u, map* m, ubyte dir );

void uattackm( player* u, monst* m );

void mmove( monst* mn, map* m, byte idy, byte idx, player* u );

void mattacku( monst* m, player* u );

void monstai( map* m, uint index, player* u );

void map_move_all_monsters( map* m, player* u );

void save();

void help( bool alt_hjkl );
