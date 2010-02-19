/* socket.c
 *
 */

#include "../../config.h"

#include "sockets-osdep.h"
#include INCLUDE_SOCKET_H
#include "runtime-base.h"
#include "runtime-values.h"
#include "lib7-c.h"
#include "cfun-proto-list.h"

/*
###       "Transmission of documents via telephone wires
###        is possible in principle, but the apparatus
###        required is so expensive that it will never
###        become a practical proposition."
###
###                           -- Dennis Gabor, 1962
###                              British physicist,
###                              author of Inventing the Future. 
 */



/* _lib7_Sock_socket : (int * int * int) -> socket
 */
lib7_val_t _lib7_Sock_socket (lib7_state_t *lib7_state, lib7_val_t arg)
{
    int domain   =  REC_SELINT(arg, 0);
    int type     =  REC_SELINT(arg, 1);
    int protocol =  REC_SELINT(arg, 2);

    int sock     = socket (domain, type, protocol);

    if (sock < 0)   return RAISE_SYSERR(lib7_state, status, __LINE__);	/* RAISE_SYSERR is defined in src/runtime/c-libs/lib7-c.h */
    else	    return INT_CtoLib7(sock);
}


/* COPYRIGHT (c) 1995 AT&T Bell Laboratories.
 * Subsequent changes by Jeff Prothero Copyright (c) 2010,
 * released under Gnu Public Licence version 3.
 */
