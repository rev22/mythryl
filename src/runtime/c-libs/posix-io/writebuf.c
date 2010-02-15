/* writebuf.c
 *
 */

#include "../../config.h"

#include "runtime-unixdep.h"

#if HAVE_UNISTD_H
#include <unistd.h>
#endif

#include "runtime-base.h"
#include "runtime-heap.h"
#include "lib7-c.h"
#include "cfun-proto-list.h"

/* _lib7_P_IO_writebuf : (int * rw_unt8_vector.Rw_Vector * int * int) -> int
 *                      fd     data              nbytes start              
 *
 * Write nbytes of data from the given array to the specified file, 
 * starting at the given offset. Assume bounds have been checked.
 */
lib7_val_t _lib7_P_IO_writebuf (lib7_state_t *lib7_state, lib7_val_t arg)
{
    int		fd = REC_SELINT(arg, 0);
    lib7_val_t	start = REC_SEL(arg, 1);
    size_t	nbytes = REC_SELINT(arg, 2);
    char	*data = STR_LIB7toC(start) + REC_SELINT(arg, 3);
    ssize_t    	n;

    n = write (fd, data, nbytes);

    CHECK_RETURN (lib7_state, n)

} /* end of _lib7_P_IO_writebuf */



/* COPYRIGHT (c) 1995 by AT&T Bell Laboratories.
 * Subsequent changes by Jeff Prothero Copyright (c) 2010,
 * released under Gnu Public Licence version 3.
 */
