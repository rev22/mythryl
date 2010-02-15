/* ftruncate.c
 *
 */
#include "../../config.h"

#include "runtime-unixdep.h"
#include "runtime-heap.h"
#include "lib7-c.h"
#include "cfun-proto-list.h"

#if HAVE_SYS_TYPES_H
#include <sys/types.h>
#endif

#if HAVE_SYS_STAT_H
#include <sys/stat.h>
#endif

/* _lib7_P_FileSys_ftruncate : (int * int) -> Void
 *                            fd   length
 *
 * Make a directory
 */
lib7_val_t _lib7_P_FileSys_ftruncate (lib7_state_t *lib7_state, lib7_val_t arg)
{
    int		    fd = REC_SELINT(arg, 0);
    off_t	    len = REC_SELINT(arg, 1);
    int		    status;

    status = ftruncate (fd, len);

    CHECK_RETURN_UNIT(lib7_state, status)

} /* end of _lib7_P_FileSys_ftruncate */


/* COPYRIGHT (c) 1995 by AT&T Bell Laboratories.
 * Subsequent changes by Jeff Prothero Copyright (c) 2010,
 * released under Gnu Public Licence version 3.
 */
