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

static const symbol SYM_FLOOR  = symdata( '.', CLR_GRAY  | A_NORMAL  );
static if( REVERSED_WALLS )
{
static const symbol SYM_WALL   = symdata( '#', CLR_GRAY  | A_REVERSE );
static const symbol SYM_STALA  = symdata( 'V', CLR_GRAY  | A_REVERSE );
}
else
{
static const symbol SYM_WALL   = symdata( '#', CLR_GRAY  | A_NORMAL  );
static const symbol SYM_STALA  = symdata( 'V', CLR_GRAY  | A_NORMAL  );
}
static const symbol SYM_DOOR   = symdata( '+', CLR_BROWN | A_NORMAL  );
static const symbol SYM_WATER  = symdata( '}', CLR_GRAY  | A_NORMAL  );
static const symbol SYM_SHADOW = symdata( ' ', CLR_GRAY  | A_NORMAL  );
