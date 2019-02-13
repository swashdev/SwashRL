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

// This file displays a message during compilation depending on what system
// you're compiling for and other configuration options.  If support for a
// particular system or configuration has been dropped, add a relevant warning
// here.

version( Windows )
{
  pragma( msg, "Compiling for Windows" );
}
else version( linux )
{
  pragma( msg, "Compiling for Linux" );
}
else version( FreeBSD )
{
  pragma( msg, "Compiling for FreeBSD" );
}
else
{
  pragma( msg, "WARNING: You are compiling SwashRL for an operating system that is not currently being actively supported.  While it is highly likely that it will \"just work,\" especially on a Linux distribution or one of the BSDs, it may fail or crash." );
}

version( ncurses )
{
  pragma( msg, "Compiling with ncurses support" );
}
version( pdcurses )
{
  pragma( msg, "Compiling with PDCurses support" );
}
version( sdl )
{
  pragma( msg, "Compiling with SDL2 support" );
}
