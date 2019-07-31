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
