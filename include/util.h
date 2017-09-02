/*
 * Copyright (c) 2017 Philip Pavlick.  All rights reserved.
 *
 * Spelunk! may be modified and distributed, but comes with NO WARRANTY!
 * See license.txt for details.
 */
#ifndef UTIL_H
# define UTIL_H

/* This file declares some simple variable types or functions which are useful
 * in C but may not be available to all compilers, such as boolean variables.
 * It is also in charge of defining utilities dependent on certain standards
 * of C */

/* Explicit integer types */
# ifdef C99
/* C99 implements standardized explicit integer types for us */
#  include <stdint.h>
typedef  int8_t   int8;
typedef uint8_t  uint8;
typedef  int16_t  int16;
typedef uint16_t uint16;
typedef  int32_t  int32;
typedef uint32_t uint32;
# else /* !C99 */
/* These definitions of integer data types are flimsy at best.  While 'char'
 * and 'short' have been standardized, 'int' is not: 'int' may be the same
 * size as 'short', in which case we must use 'long int'.  However, on some
 * systems 'long int' is 64-bit, not 32-bit.  Use discretion. */
typedef   signed char       int8;
typedef unsigned char      uint8;
typedef   signed short int  int16;
typedef unsigned short int uint16;
#  ifdef USE_LONG
typedef   signed long int   int32;
typedef unsigned long int  uint32;
#  else /* ndef USE_LONG */
typedef   signed int        int32;
typedef unsigned int       uint32;
#  endif /* def USE_LONG */
# endif /* def C99 */

# ifndef MAX_INT8
#  define MAX_INT8   127
# endif
# ifndef MIN_INT8
#  define MIN_INT8  -127
# endif
# ifndef MAX_UINT8
#  define MAX_UINT8  255
# endif
# ifndef MAX_INT16
#  define MAX_INT16  32767
# endif
# ifndef MIN_INT16
#  define MIN_INT16 -32767
# endif
# ifndef MAX_UINT16
#  define MAX_UINT16 65535
# endif
# ifndef MAX_INT32
#  define MAX_INT32  2147483647
# endif
# ifndef MIN_INT32
#  define MIN_INT32 -2147483647
# endif
# ifndef MAX_UINT32
#  define MAX_UINT32 4294967295
# endif

/* Booleans */

/* disabling this bool declaration because it clashes with the pdcurses bool */
#if 0
# ifndef bool
#  if C99 /* see if the C99 standard boolean type is available to us */
#   include <stdbool.h>
typedef _Bool bool;
#  else /* no C99--fall back on C89 standard */
/* Use the smallest data type available to us--note that we are allowing
 * booleans to have negative values */
typedef int8 bool;
#  endif /* C99 true */
# endif /* bool */
#endif

/* pdcurses defines TRUE and FALSE for us (how helpful!) but just in case
 * they're still not defined by this point... */
# ifndef TRUE
#  define TRUE  1
# endif /* !TRUE */
# ifndef FALSE
#  define FALSE 0
# endif /* FALSE */

/* NULL */
/* This is another "just in case" definition; I'm not aware of any C compiler
 * that doesn't recognize NULL, but you never know */
# ifndef NULL
#  define NULL (void*) 0
# endif /* !def NULL */

/* Strings */
# ifndef str
typedef char* str;
# endif /* !def str */


/* Array functions */
# define len(array) (sizeof (array)  / sizeof (array[0]))

/* some utility functions */

/* returns whether floor <= n <= ceil, automatic FALSE if floor > ceil */
bool within_minmax( int n, int floor, int ceil );

char lowercase( char in );
char uppercase( char in );

/* if floor > ceil, return n
 * if n < floor, return floor
 * if n > ceil, return ceil
 * otherwise return n */
int32 minmax( int32 n, int32 floor, int32 ceil );

#endif /* !UTIL_H */
