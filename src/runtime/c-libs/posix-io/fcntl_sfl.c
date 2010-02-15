/* fcntl_sfl.c
 *
 */

#include "../../config.h"

#include "runtime-unixdep.h"

#if HAVE_FCNTL_H
#include <fcntl.h>
#endif

#include "runtime-base.h"
#include "runtime-values.h"
#include "runtime-heap.h"
#include "lib7-c.h"
#include "cfun-proto-list.h"

/* _lib7_P_IO_fcntl_sfl : int * word -> Void
 *
 * Set file status flags
 */
lib7_val_t _lib7_P_IO_fcntl_sfl (lib7_state_t *lib7_state, lib7_val_t arg)
{
    int             status;
    int             fd0 = REC_SELINT(arg, 0);
    Word_t          flag = REC_SELWORD(arg, 1);

    status = fcntl(fd0, F_SETFL, flag);

    CHECK_RETURN_UNIT(lib7_state,status)

} /* end of _lib7_P_IO_fcntl_sfl */


/* COPYRIGHT (c) 1995 by AT&T Bell Laboratories.
 * Subsequent changes by Jeff Prothero Copyright (c) 2010,
 * released under Gnu Public Licence version 3.
 */
