/* unix-raise-syserr.c
 *
 */

#include "../config.h"

#include "runtime-unixdep.h"
#ifdef HAS_STRERROR
#  include <string.h>
#endif
#include <stdio.h>
#include <errno.h>
#include "runtime-base.h"
#include "runtime-state.h"
#include "runtime-heap.h"
#include "runtime-globals.h"
#include "lib7-c.h"


#ifndef HAS_STRERROR
/* strerror:
 * An implementation of strerror for those systems that do not provide it.
 */
static char *strerror (int errnum)
{
    extern int	sys_nerr;
    extern char	*sys_errlist[];

    if ((errnum < 0) || (sys_nerr <= errnum))
	return "<unknown system error>";
    else
	return sys_errlist[errnum];

} /* end of strerror */
#endif


/* RaiseSysError:
 *
 * Raise the Lib7 exception SYSTEM_ERROR, which has the spec:
 *
 *    exception SYSTEM_ERROR of (String * System_Error Null_Or)
 *
 * For the time being, we use the errno value as the System_Error; eventually that
 * will be represented by an (int * String) pair.  If alt_msg is non-zero,
 * then use it as the error string and use NULL for the System_Error.
 */
lib7_val_t RaiseSysError (lib7_state_t *lib7_state, const char *altMsg, const char *at)
{
    lib7_val_t	    s, atStk, syserror, arg, exn;
    const char	    *msg;
    char	    buf[32];

    if (altMsg != NULL) {
	msg = altMsg;
	syserror = OPTION_NONE;
    }
    else if ((msg = strerror(errno)) != NULL) {
	OPTION_SOME(lib7_state, syserror, INT_CtoLib7(errno))
    }
    else {
	sprintf(buf, "<unknown error %d>", errno);
	msg = buf;
	OPTION_SOME(lib7_state, syserror, INT_CtoLib7(errno));
    }

#if (defined(DEBUG_OS_INTERFACE) || defined(DEBUG_TRACE_CCALL))
    SayDebug ("RaiseSysError: errno = %d, msg = \"%s\"\n",
	(altMsg != NULL) ? -1 : errno, msg);
#endif

    s = LIB7_CString (lib7_state, msg);
    if (at != NULL) {
	lib7_val_t atMsg = LIB7_CString (lib7_state, at);
	LIST_cons(lib7_state, atStk, atMsg, LIST_nil);
    }
    else
	atStk = LIST_nil;
    REC_ALLOC2 (lib7_state, arg, s, syserror);
    EXN_ALLOC (lib7_state, exn, PTR_CtoLib7(SysErrId), arg, atStk);

    RaiseLib7Exception (lib7_state, exn);

    return exn;

} /* end of RaiseSysError */


/*
 * COPYRIGHT (c) 1995 by AT&T Bell Laboratories.
 */
