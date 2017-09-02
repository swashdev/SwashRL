/* sys.h was contributed by Elronnd on 2017-04-14, and subsequently modified
 * by me to fit the style guide :-) */

/* This file detects your system architecture and compiler; sets compiler
 * flags (#defines) accordingly; and, if applicable, includes some header
 * files.  If your system or compiler are not detected, it is probably because
 * they are not supported by the project maintainer(s) at this time.
 * For curses versions, see ``include/config.h'' and ``include/global.h''
 */

/* Get bitness */
#if defined(_WIN32) || defined(_WIN64)
# ifdef _WIN64
#  define BIT64
# else
#  define BIT32
# endif
#elif defined(__GNUC__)
# if defined(__x86_64__) || defined(__ppc64__)
#  define BIT64
# else
#  define BIT32
# endif
#else
# error "Unsupported compiler or architecture. (32-bit or 64-bit only)"
#endif

#ifdef BIT64
# define BITS 64
#else
# define BITS 32
#endif


/* Get platform */
#if !defined(_WIN32) && (defined(__unix__) || defined(__unix) || (defined(__APPLE__) && defined(__MACH__)))
# include <sys/param.h>
# define UNIX
#endif

#ifdef _WIN32
# define WINDOWS

#elif defined(__APPLE__)
# include <TargetConditionals.h>
# if defined(TARGET_OS_MAC) || defined(TARGET_OS_OSX)
#  define MACOS
# else
#  warning "Unsupported apple platform"
# endif

#elif defined(__ANDROID__)
# define ANDROID
# warning "Android is not yet supported."

#elif defined(__linux__) || defined(__linux)
# define LINUX


#elif defined(__DragonFly__)
# define DRAGONFLY_BSD

#elif defined(__FreeBSD__)
# define FREEBSD

#elif defined(__NetBSD__)
# define NETBSD

#elif defined(__OpenBSD__)
# define OPENBSD

#else
# warning "Unsupported operating system."
#endif


/* Get compiler */
#ifdef __clang__
# define CLANG
#elif defined(__INTEL_COMPILER)
# define ICC
#elif defined(__GNUC__)
# define GCC
#elif defined(_MSC_VER)
# define MSVC
#else
# warning "Unsupported compiler."
# define NO_COMPILER
#endif
