/*
 * Copyright 2016-2019 Philip Pavlick
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License.  You may obtain a copy
 * of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * SwashRL is distributed with a special exception to the normal Apache
 * License 2.0.  See LICENSE for details.
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
