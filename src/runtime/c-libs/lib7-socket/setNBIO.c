/* setNBIO.c
 *
 */

#include "../../config.h"

#include "sockets-osdep.h"
#include INCLUDE_SOCKET_H
#include "runtime-base.h"
#include "runtime-values.h"
#include "runtime-heap.h"
#include "lib7-c.h"
#include "cfun-proto-list.h"
#include "socket-util.h"



/*
###                 "This is the biggest fool thing we've ever
###                  done -- the bomb will never go off -- and
###                  I speak as an expert on explosives."
###
###                        -- Admiral William Leahy, 1945,
###                           speaking to President Truman about the atom bomb
*/



/* _lib7_Sock_setNBIO : (socket * Bool) -> Void
 */
lib7_val_t _lib7_Sock_setNBIO (lib7_state_t *lib7_state, lib7_val_t arg)
{
    int		n, status;
    int		socket = REC_SELINT(arg, 0);

#ifdef USE_FCNTL_FOR_NBIO
    n = fcntl(F_GETFL, socket);
    if (n < 0)
        return RAISE_SYSERR (lib7_state, n, __LINE__);
    if (REC_SEL(arg, 1) == LIB7_true)
	n |= O_NONBLOCK;
    else
	n &= ~O_NONBLOCK;
    status = fcntl(F_SETFL, socket, n);
#else
    n = (REC_SEL(arg, 1) == LIB7_true);
    status = ioctl (socket, FIONBIO, (char *)&n);
#endif

    CHECK_RETURN_UNIT(lib7_state, status);

} /* end of _lib7_Sock_setNBIO */


/* COPYRIGHT (c) 1995 AT&T Bell Laboratories.
 * Subsequent changes by Jeff Prothero Copyright (c) 2010,
 * released under Gnu Public Licence version 3.
 */
