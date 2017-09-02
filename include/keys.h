/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */
#ifndef KEY_BINDINGS
# define KEY_BINDINGS

# include "global.h"

/* Macros for getting the function keys (we'll only use 12 here since that's
 * the standard) */

# define KEY_F1  (KEY_F0 +  1)
# define KEY_F2  (KEY_F0 +  2)
# define KEY_F3  (KEY_F0 +  3)
# define KEY_F4  (KEY_F0 +  4)
# define KEY_F5  (KEY_F0 +  5)
# define KEY_F6  (KEY_F0 +  6)
# define KEY_F7  (KEY_F0 +  7)
# define KEY_F8  (KEY_F0 +  8)
# define KEY_F9  (KEY_F0 +  9)
# define KEY_F10 (KEY_F0 + 10)
# define KEY_F11 (KEY_F0 + 11)
# define KEY_F12 (KEY_F0 + 12)

/* vi-like keys */
# define MV_NN 'k'
# define MV_NE 'u'
# define MV_EE 'l'
# define MV_SE 'n'
# define MV_SS 'j'
# define MV_SW 'b'
# define MV_WW 'h'
# define MV_NW 'y'

# define KY_INV 'i'
# define KY_WIELD 'w'

/* alt vi-like keys; hjkl are the same, but diagonal movement is mapped closer
 * to the right hand.  'i'nventory is moved to 'b' (for bag) */
# define AL_NN 'k'
# define AL_NE 'i'
# define AL_EE 'l'
# define AL_SE 'm'
# define AL_SS 'j'
# define AL_SW 'n'
# define AL_WW 'h'
# define AL_NW 'u'

# define AL_INV 'b'

# define MV_WT '.'

/* numpad keys */
# define NP_NN '8'
# define NP_NE '9'
# define NP_EE '6'
# define NP_SE '3'
# define NP_SS '2'
# define NP_SW '1'
# define NP_WW '4'
# define NP_NW '7'

# define NP_WT '5'

/* other keys */

# define KY_GET ','

/* spacebar to clear the message bar */
# define KY_CLEAR ' '
/* display the message buffer */
# define KY_MESS  'P'

# define KY_HJKL    KEY_F12

/* admin keys */
# define KY_QUIT    'Q'
# define KY_HELP    KEY_F1
# define KY_VERSION KEY_F4

#endif /* !KEY_BINDINGS */
