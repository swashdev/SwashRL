/*
 * Copyright (c) 2016-2018 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */

// Defines the interface for functions related to program output for the
// SDL terminal interface.

version( sdl )
{

// Import SDL2 from here.  ``global.d'' won't do this for us because this
// file is only imported from ``display.d''
import derelict.sdl2.sdl, derelict.sdl2.ttf;

// Import the config file so we can use a few config flags from there
import config;

// There's nothing else here yet.  Go away.
// ----------------------------------------
//                \\
//                    (__)
//                    * *\
//                  ('')  \______
//                    -     #### \
//                      \    # ## \
//                       \____   |
//                        || (,,|| 
//                        ||    ||
//                 ~~~    ""    ""    ~~~

} /* version( sdl ) */
