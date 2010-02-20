/* connect.c
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


/*
###        "How often, or on what system, the Thought Police
###         plugged in any individual wire was guesswork.
###
###         It was even conceivable that they watched
###         everybody all the time.
###
###         But at any rate, they could plug in your wire
###         whenever they wanted to."
###
###                             -- George Orwell, 1984
 */

/* _lib7_Sock_connect: (Socket, Address) -> Void
 */
lib7_val_t _lib7_Sock_connect (lib7_state_t *lib7_state, lib7_val_t arg)
{
    int		socket = REC_SELINT(arg, 0);
    lib7_val_t	addr = REC_SEL(arg, 1);
    int		status;

    status
        =
        connect (
	    socket,
	    GET_SEQ_DATAPTR(struct sockaddr, addr),
	    GET_SEQ_LEN(addr)
        );

    CHECK_RETURN_UNIT(lib7_state, status);		/* CHECK_RETURN_UNIT	is from   src/runtime/c-libs/lib7-c.h	*/
}


/* COPYRIGHT (c) 1995 AT&T Bell Laboratories.
 * Subsequent changes by Jeff Prothero Copyright (c) 2010,
 * released under Gnu Public Licence version 3.
 */
