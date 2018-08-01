/*
 * Copyright (c) 2016-2018 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
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
  pragma( msg, "WARNING: You are compiling Spelunk! for an operating system that is not currently being actively supported.  While it is highly likely that it will \"just work,\" especially on a Linux distribution or one of the BSDs, it may fail or crash." );
}

version( pdcurses )
{
  pragma( msg, "WARNING: PDCurses is not being actively supported " ~
"due to difficulties with getting dmd to recognize " ~
"any version of pdcurses.lib we have compiled.  We are unsure of the " ~
"problem and are working on a workaround or an alternative.\n" ~
"If you manage to get PDCurses working for Spelunk!, we would be delighted " ~
"to learn how you did it.  Please leave an Issue on our GitHub page:\n" ~
"https://github.com/swashdev/spelunk" );
}
