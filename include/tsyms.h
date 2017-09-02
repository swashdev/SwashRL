#ifndef TSYMS_H
# define TSYMS_H

# include "global.h"

/* declare symbols for dungeon tiles--see ``sym.h'' for declaration of the
 * `symbol' struct */

# ifndef SYM_H
#  include "sym.h"
# endif /* !def SYM_H */

# define scs static const symbol

scs SYM_FLOOR  = symdata( '.', A_NORMAL  );
scs SYM_WALL   = symdata( '#', A_REVERSE );
scs SYM_STALA  = symdata( 'V', A_REVERSE );
scs SYM_WATER  = symdata( '}', A_NORMAL  );
scs SYM_DOOR   = symdata( '+', A_REVERSE );
scs SYM_SHADOW = symdata( ' ', A_NORMAL );

# undef scs

#endif /* !def TSYMS_H */
