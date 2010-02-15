/* fcntl_gfd.c
 *
 */

#include "../../config.h"

#include "runtime-unixdep.h"

#if HAVE_FCNTL_H
#include <fcntl.h>
#endif

#include "runtime-heap.h"
#include "lib7-c.h"
#include "cfun-proto-list.h"

/* _lib7_P_IO_fcntl_gfd : int -> word
 *
 * Get the close-on-exec flag associated with the file descriptor.
 */
lib7_val_t _lib7_P_IO_fcntl_gfd (lib7_state_t *lib7_state, lib7_val_t arg)
{
    int             flag;
    lib7_val_t        v;

    flag = fcntl(INT_LIB7toC(arg), F_GETFD);

    if (flag == -1)
        return RAISE_SYSERR(lib7_state, flag);
    else {
        WORD_ALLOC (lib7_state, v, flag);
        return v;
    }

} /* end of _lib7_P_IO_fcntl_gfd */


/* COPYRIGHT (c) 1995 by AT&T Bell Laboratories.
 * Subsequent changes by Jeff Prothero Copyright (c) 2010,
 * released under Gnu Public Licence version 3.
 */
