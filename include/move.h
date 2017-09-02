/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */
#ifndef MOVE_H
# define MOVE_H

# include "global.h"

int getcommand( bool alt_hjkl );

void getdydx( short int dir, short int* dy, short int* dx );

uint8 umove( player* u, map* m, unsigned short int dir );

void uattackm( player* u, monst* m );

void mmove( monst* mn, map* m, short int idy, short int idx, player* u );

void mattacku( monst* m, player* u );

void monstai( map* m, unsigned int index, player* u );

void map_move_all_monsters( map* m, player* u );

void save();

void help( bool alt_hjkl );

#endif /* !def MOVE_H */
