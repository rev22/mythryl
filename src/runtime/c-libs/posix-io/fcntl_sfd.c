/* fcntl_sfd.c
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

/* _lib7_P_IO_fcntl_sfd : int * word -> Void
 *
 * Set the close-on-exec flag associated with the file descriptor.
 */
lib7_val_t _lib7_P_IO_fcntl_sfd (lib7_state_t *lib7_state, lib7_val_t arg)
{
    int             status;
    int             fd0 = REC_SELINT(arg, 0);
    Word_t          flag = REC_SELWORD(arg, 1);

    status = fcntl(fd0, F_SETFD, flag);

    CHECK_RETURN_UNIT(lib7_state,status)

} /* end of _lib7_P_IO_fcntl_sfd */


/* COPYRIGHT (c) 1995 by AT&T Bell Laboratories.
 * Subsequent changes by Jeff Prothero Copyright (c) 2010,
 * released under Gnu Public Licence version 3.
 */
