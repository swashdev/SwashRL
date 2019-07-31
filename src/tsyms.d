/*
 * Copyright 2015-2019 Philip Pavlick
 *
 * This software is provided 'as-is', without any express or implied
 * warranty.  In no event will the authors be held liable for any damages
 * arising from the use of this software.
 * 
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 * 
 * 1. The origin of this software must not be misrepresented; you must not
 *    claim that you wrote the original software. If you use this software
 *    in a product, an acknowledgment in the product documentation would be
 *    appreciated but is not required.
 * 2. Altered source versions must be plainly marked as such, and must not be
 *    misrepresented as being the original software.
 * 3. This notice may not be removed or altered from any source distribution.
 */

import global;

// declare symbols for dungeon Tiles--see ``sym.d'' for declaration of the
// `Symbol' struct and `symdata' function.

static const Symbol SYM_FLOOR  = symdata( '.', Color( CLR_GRAY, false ) );
static const Symbol SYM_WALL   = symdata( '#',
                                          Color( CLR_GRAY, REVERSED_WALLS ) );
static const Symbol SYM_STALA  = symdata( 'V',
                                          Color( CLR_GRAY, REVERSED_WALLS ) );
static const Symbol SYM_DOOR   = symdata( '+', Color( CLR_BROWN, false ) );
static const Symbol SYM_WATER  = symdata( '}', Color( CLR_BLUE, false ) );
static const Symbol SYM_SHADOW = symdata( ' ', Color( CLR_BLACK, false ) );
