/* close.c
 *
 */

#include "../../config.h"

#include "runtime-base.h"
#include "runtime-values.h"
#include "runtime-heap.h"
#include "lib7-c.h"
#include "cfun-proto-list.h"

#if HAVE_UNISTD_H
#include <unistd.h>
#endif

/* _lib7_P_IO_close : int -> Void
 *
 * Duplicate an open file descriptor
 */
lib7_val_t _lib7_P_IO_close (lib7_state_t *lib7_state, lib7_val_t arg)
{
    int         status, fd = INT_LIB7toC(arg);

    status = close(fd);

    CHECK_RETURN_UNIT(lib7_state, status)

} /* end of _lib7_P_IO_close */


/* COPYRIGHT (c) 1995 by AT&T Bell Laboratories.
 * Subsequent changes by Jeff Prothero Copyright (c) 2010,
 * released under Gnu Public Licence version 3.
 */
