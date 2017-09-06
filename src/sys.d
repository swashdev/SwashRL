/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */

// In previous iterations this file would detect your architecture and #define
// a bunch of flags so Spelunk! knew what operating system you were using, but
// since we're moving to D I'm pretty sure all we need this file for is
// warning people not to use Apple products

version( !Windows && !linux && !FreeBSD )
{
  pragma( msg, "Warning: You are compiling Spelunk! for an operating system\
 that is not currently being actively supported.  It may fail or crash." );
}
