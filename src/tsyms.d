/*
 * Copyright 2016-2018 Philip Pavlick
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License, excepting that
 * Derivative Works are not required to carry prominent notices in changed
 * files.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import global;

// declare symbols for dungeon tiles--see ``sym.d'' for declaration of the
// `symbol' struct and `symdata' function.

static const symbol SYM_FLOOR  = symdata( '.', Color( CLR_GRAY, false ) );
static const symbol SYM_WALL   = symdata( '#',
                                          Color( CLR_GRAY, REVERSED_WALLS ) );
static const symbol SYM_STALA  = symdata( 'V',
                                          Color( CLR_GRAY, REVERSED_WALLS ) );
static const symbol SYM_DOOR   = symdata( '+', Color( CLR_BROWN, false ) );
static const symbol SYM_WATER  = symdata( '}',
                                          Color( CLR_BLUE, REVERSED_WALLS ) );
static const symbol SYM_SHADOW = symdata( ' ', Color( CLR_BLACK, false ) );
