/* gettime.c
 *
 */

#include "../../config.h"

#include "runtime-base.h"
#include "runtime-values.h"
#include "runtime-heap.h"
#include "vproc-state.h"
#include "runtime-state.h"
#include "runtime-timer.h"
#include "cfun-proto-list.h"

/* _lib7_Time_gettime : Void -> (int32.Int * int * int32.Int * int * int32.Int * int)
 *
 * Return the total CPU time, system time and garbage collection time used by this
 * process so far.
 */
lib7_val_t _lib7_Time_gettime (lib7_state_t *lib7_state, lib7_val_t arg)
{
    Time_t		t, s;
    lib7_val_t		tSec, sSec, gcSec, res;
    vproc_state_t	*vsp = lib7_state->lib7_vproc;

    get_cpu_time (&t, &s);

    INT32_ALLOC (lib7_state, tSec, t.seconds);
    INT32_ALLOC (lib7_state, sSec, s.seconds);
    INT32_ALLOC (lib7_state, gcSec, vsp->vp_gcTime->seconds);
    REC_ALLOC6 (lib7_state, res,
	tSec, INT_CtoLib7(t.uSeconds),
	sSec, INT_CtoLib7(s.uSeconds),
	gcSec, INT_CtoLib7(vsp->vp_gcTime->uSeconds));

    return res;

} /* end of _lib7_Time_gettime */



/* COPYRIGHT (c) 1994 by AT&T Bell Laboratories.
 * Subsequent changes by Jeff Prothero Copyright (c) 2010,
 * released under Gnu Public Licence version 3.
 */
