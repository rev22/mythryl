/* to-inetaddr.c
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
###               "The Americans have need of the telephone, but
###                we do not. We have plenty of messenger boys."
###
###                         --- Sir William Preece, 1878
###                             Chief Engineer, British Post Office
*/

/* _lib7_Sock_toinetaddr : (in_addr * int) -> addr
 *
 * Given a INET address and port number, allocate a INET-domain socket address.
 */
lib7_val_t _lib7_Sock_toinetaddr (lib7_state_t *lib7_state, lib7_val_t arg)
{
    lib7_val_t		inAddr = REC_SEL(arg, 0);
    lib7_val_t		data, res;
    struct sockaddr_in	addr;

    memset(&addr, 0, sizeof(struct sockaddr_in));

    addr.sin_family = AF_INET;
    memcpy (
	&addr.sin_addr,
	GET_SEQ_DATAPTR(char, inAddr),
	sizeof(struct in_addr));
    addr.sin_port = htons(REC_SELINT(arg, 1));

    data = LIB7_CData (lib7_state, &addr, sizeof(struct sockaddr_in));
    SEQHDR_ALLOC (lib7_state, res, DESC_word8vec, data, sizeof(struct sockaddr_in));

    return res;

} /* end of _lib7_Sock_toinetaddr */




/* COPYRIGHT (c) 1995 AT&T Bell Laboratories.
 * Subsequent changes by Jeff Prothero Copyright (c) 2010,
 * released under Gnu Public Licence version 3.
 */
