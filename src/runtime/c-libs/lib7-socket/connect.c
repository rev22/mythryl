/* connect.c
 *
 */

#include "../../config.h"

#include <string.h>
#include <stdio.h>
#include <errno.h>

#include "sockets-osdep.h"
#include INCLUDE_SOCKET_H
#include "runtime-base.h"
#include "runtime-values.h"
#include "runtime-heap.h"
#include "lib7-c.h"
#include "cfun-proto-list.h"

#include "print-if.h"

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
 *
 * This function gets imported into the Mythryl world by:
 *     src/lib/std/src/socket/socket-guts.pkg
 */
lib7_val_t _lib7_Sock_connect (lib7_state_t *lib7_state, lib7_val_t arg)
{
    int		socket = REC_SELINT(arg, 0);
    lib7_val_t	addr   = REC_SEL(   arg, 1);
    int		status;

    socklen_t addrlen  = GET_SEQ_LEN(addr);

    {   unsigned char* a = GET_SEQ_DATAPTR(unsigned char*, addr);
        char buf[ 1024 ];
	int i;
	buf[0] = '\0';
	for (i = 0; i < addrlen; ++i) {
	    sprintf (buf+strlen(buf), "%02x.", a[i]);
	}
        print_if( "connect.c/top: socket d=%d addrlen d=%d addr s='%s'\n", socket, addrlen, buf );
    }
    errno = 0;

    status
        =
        connect (
	    socket,
	    GET_SEQ_DATAPTR(struct sockaddr, addr),
	    addrlen
        );

    print_if( "connect.c/bot: status d=%d errno d=%d\n", status, errno);

    CHECK_RETURN_UNIT(lib7_state, status);		/* CHECK_RETURN_UNIT	is from   src/runtime/c-libs/lib7-c.h	*/
}


/* COPYRIGHT (c) 1995 AT&T Bell Laboratories.
 * Subsequent changes by Jeff Prothero Copyright (c) 2010,
 * released under Gnu Public Licence version 3.
 */
