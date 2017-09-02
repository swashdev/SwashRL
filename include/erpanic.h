/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */
#ifndef ERPANIC_H
# define ERPANIC_H

# include "global.h"

# define SP_UNKNOWN_ERROR -127
# define SP_MEMORY_ALLOCATION_ERROR -1
# define SP_NO_ERRORS 0
# define SP_TERMINATED_EARLY_NO_ERROR 1
# define SP_USER_ERROR 2

void panic( int8 error );

#endif /* !def ERPANIC_H */
