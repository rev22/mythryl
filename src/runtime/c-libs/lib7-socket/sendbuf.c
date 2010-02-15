/* sendbuf.c
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
###         "Railroad carriages are pulled at the enormous speed
###          of fifteen miles per hour by engines which,
###          in addition to endangering life and limb of passengers,
###          roar and snort their way through the countryside,
###          setting fire to the crops, scaring the livestock,
###          and frightening women and children.
###
###          The Almighty certainly never intended that
###          people should travel at such break-neck speed."
### 
###                -- President Martin Van Buren, 1829
 */

/* _lib7_Sock_sendbuf : (socket * bytes * int * int * Bool * Bool) -> int
 *
 * Send data from the buffer; bytes is either a rw_unt8_vector.Rw_Vector, or
 * a unt8_vector.vector.  The arguments are: socket, data buffer, start
 * position, number of bytes, OOB flag, and don't_route flag.
 */
lib7_val_t _lib7_Sock_sendbuf (lib7_state_t *lib7_state, lib7_val_t arg)
{
    int		socket   = REC_SELINT(arg, 0);
    lib7_val_t	buf    = REC_SEL(arg, 1);
    int		nbytes = REC_SELINT(arg, 3);
    char	*data  = STR_LIB7toC(buf) + REC_SELINT(arg, 2);

    /* Compute flags parameter: */
    int flgs = 0;
    if (REC_SEL(arg, 4) == LIB7_true) flgs |= MSG_OOB;
    if (REC_SEL(arg, 5) == LIB7_true) flgs |= MSG_DONTROUTE;

    {   int n = send (socket, data, nbytes, flgs);

        CHECK_RETURN (lib7_state, n);
    }

} /* end of _lib7_Sock_sendbuf */


/* COPYRIGHT (c) 1995 AT&T Bell Laboratories.
 * Subsequent changes by Jeff Prothero Copyright (c) 2010,
 * released under Gnu Public Licence version 3.
 */
