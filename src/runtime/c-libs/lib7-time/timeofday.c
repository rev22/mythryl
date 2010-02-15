/* timeofday.c
 *
 */

#include "../../config.h"

#  include "runtime-osdep.h"
#if defined(HAS_GETTIMEOFDAY)
#  if defined(OPSYS_WIN32)
#if HAVE_SYS_TYPES_H
#    include <sys/types.h>
#endif
#if HAVE_SYS_TIMEB_H
#    include <sys/timeb.h>
#endif
#  else
#if HAVE_SYS_TIME_H
#    include <sys/time.h>
#endif
#  endif
#else
#  error no timeofday mechanism
#endif   
#include "runtime-base.h"
#include "runtime-values.h"
#include "runtime-heap.h"
#include "cfun-proto-list.h"

/* _lib7_Time_timeofday : Void -> (int32.Int, Int)
 *
 * Return the time of day.
 * NOTE: gettimeofday() is not POSIX (time() returns seconds, and is POSIX
 * and ISO C).
 */
lib7_val_t _lib7_Time_timeofday (lib7_state_t *lib7_state, lib7_val_t arg)
{
    int			c_sec, c_usec;
    lib7_val_t		lib7_sec, res;

#ifdef HAS_GETTIMEOFDAY
#if defined(OPSYS_UNIX)
    {
	struct timeval	t;

	gettimeofday (&t, NULL);
	c_sec = t.tv_sec;
	c_usec = t.tv_usec;
    }
#elif defined(OPSYS_WIN32)
  /* we could use Win32 GetSystemTime/SystemTimetoFileTime here,
   * but the conversion routines for 64-bit 100-ns values
   * (in the keyed_map dll) are non-Win32s
   *
   * we'll use time routines from the C runtime for now.
   */
    {
	struct _timeb t;

	_ftime(&t);
	c_sec = t.time;
	c_usec = t.millitm*1000;
    }
#else
#error timeofday not defined for OS
#endif
#else
#error no timeofday mechanism
#endif

    INT32_ALLOC(lib7_state, lib7_sec, c_sec);
    REC_ALLOC2 (lib7_state, res, lib7_sec, INT_CtoLib7(c_usec));

    return res;

} /* end of _lib7_Time_timeofday */



/* COPYRIGHT (c) 1994 by AT&T Bell Laboratories.
 * Subsequent changes by Jeff Prothero Copyright (c) 2010,
 * released under Gnu Public Licence version 3.
 */
