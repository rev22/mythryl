/* settracefd.c
 *
 */

#include "../../config.h"

#include "sockets-osdep.h"
#include INCLUDE_SOCKET_H
#include "runtime-base.h"
#include "runtime-values.h"
#include "lib7-c.h"
#include "cfun-proto-list.h"



/* _lib7_Sock_settracefd : Int -> Void
 */
lib7_val_t _lib7_Sock_settracefd (lib7_state_t *lib7_state, lib7_val_t arg)
{
    int         fd      =  INT_LIB7toC(arg);

    return LIB7_void;
}


/* COPYRIGHT (c) 2010 by Jeff Prothero,
 * released under Gnu Public Licence version 3.
 */
