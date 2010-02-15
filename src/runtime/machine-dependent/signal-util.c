/* signal-util.c
 *
 * System independent utility routines for supporting signals and
 * software polling.
 */

#include "../config.h"

#include <stdio.h>
#include "runtime-base.h"
#include "runtime-limits.h"
#include "runtime-state.h"
#include "vproc-state.h"
#include "runtime-heap.h"
#include "runtime-signals.h"
#include "system-signals.h"


/* ChooseSignal:
 *
 * Choose which signal to pass to the Lib7 handler and setup the Lib7 state
 * vector accordingly.
 * WARNING: This should be called with signals masked to avoid race
 * conditions.
 */
void ChooseSignal (vproc_state_t *vsp)
{
    int		i, j, delta;

  /* scan the signal counts looking for a signal that needs to be handled. */
    i = vsp->vp_nextPendingSig;
    j = 0;
    do {
	ASSERT (j++ < NUM_SIGS);
	i++;
	if (i == SIGMAP_SZ) i = MIN_SYSTEM_SIG;
	delta = vsp->vp_sigCounts[i].nReceived - vsp->vp_sigCounts[i].nHandled;
    } while (delta == 0);
    vsp->vp_nextPendingSig = i;

  /* record the signal and count */
    vsp->vp_sigCode = i;
    vsp->vp_sigCount = delta;
    vsp->vp_sigCounts[i].nHandled += delta;
    vsp->vp_totalSigCount.nHandled += delta;

#ifdef SIGNAL_DEBUG
SayDebug ("ChooseSignal: sig = %d, count = %d\n",
vsp->vp_sigCode, vsp->vp_sigCount);
#endif

} /* end of ChooseSignal */


/* MakeResumeCont:
 *
 * Build the resume fate for a signal or poll event handler.
 * This closure contains the address of the resume entry-point and
 * the registers from the Lib7 state.
 *
 * At least 4K avail. heap assumed.
 */
lib7_val_t MakeResumeCont (lib7_state_t *lib7_state, lib7_val_t resume[])
{
  /* allocate the resumption closure */
    LIB7_AllocWrite(lib7_state,  0, MAKE_DESC(10, DTAG_record));
    LIB7_AllocWrite(lib7_state,  1, PTR_CtoLib7(resume));
    LIB7_AllocWrite(lib7_state,  2, lib7_state->lib7_argument);
    LIB7_AllocWrite(lib7_state,  3, lib7_state->lib7_fate);
    LIB7_AllocWrite(lib7_state,  4, lib7_state->lib7_closure);
    LIB7_AllocWrite(lib7_state,  5, lib7_state->lib7_link_register);
    LIB7_AllocWrite(lib7_state,  6, lib7_state->lib7_program_counter);
    LIB7_AllocWrite(lib7_state,  7, lib7_state->lib7_exception_fate);
    /* John (Reppy) says that current_thread should not be included here...
    LIB7_AllocWrite(lib7_state,  8, lib7_state->lib7_current_thread);
    */
    LIB7_AllocWrite(lib7_state,  8, lib7_state->lib7_calleeSave[0]);
    LIB7_AllocWrite(lib7_state,  9, lib7_state->lib7_calleeSave[1]);
    LIB7_AllocWrite(lib7_state, 10, lib7_state->lib7_calleeSave[2]);

    return LIB7_Alloc(lib7_state, 10);

} /* end of MakeResumeCont */


/* MakeHandlerArg:
 *
 * Build the argument record for the Lib7 signal handler.  It has the type
 *
 *   val sigHandler : (int * int * Void Fate) -> 'a
 *
 * The first argument is the signal code, the second is the signal count and the
 * third is the resumption fate.  The Lib7 signal handler should never
 * return.
 * NOTE: maybe this should be combined with ChooseSignal???
 */
lib7_val_t MakeHandlerArg (lib7_state_t *lib7_state, lib7_val_t resume[])
{
    lib7_val_t	resumeCont, arg;
    vproc_state_t *vsp = lib7_state->lib7_vproc;

    resumeCont = MakeResumeCont(lib7_state, resume);

    /* Allocate the Lib7 signal handler's argument record */
    REC_ALLOC3(lib7_state, arg,
	INT_CtoLib7(vsp->vp_sigCode), INT_CtoLib7(vsp->vp_sigCount),
	resumeCont);

#ifdef SIGNAL_DEBUG
SayDebug ("MakeHandlerArg: resumeC = %#x, arg = %#x\n", resumeCont, arg);
#endif
    return arg;

} /* end of MakeHandlerArg */


/* LoadResumeState:
 *
 * Load the Lib7 state with the state preserved in resumption fate
 * made by MakeResumeCont.
 */
void LoadResumeState (lib7_state_t *lib7_state)
{
    lib7_val_t	    *contClosure;
#ifdef SIGNAL_DEBUG
SayDebug ("LoadResumeState:\n");
#endif

    contClosure = PTR_LIB7toC(lib7_val_t, lib7_state->lib7_closure);

    lib7_state->lib7_argument		= contClosure[1];
    lib7_state->lib7_fate		= contClosure[2];
    lib7_state->lib7_closure		= contClosure[3];
    lib7_state->lib7_link_register	= contClosure[4];
    lib7_state->lib7_program_counter	= contClosure[5];
    lib7_state->lib7_exception_fate	= contClosure[6];

    /* John (Reppy) says current_thread
    should not be included here...
    lib7_state->lib7_current_thread	= contClosure[7];
    */

    lib7_state->lib7_calleeSave[0]	= contClosure[7];
    lib7_state->lib7_calleeSave[1]	= contClosure[8];
    lib7_state->lib7_calleeSave[2]	= contClosure[9];

} /* end of LoadResumeState */



/* COPYRIGHT (c) 1995 by AT&T Bell Laboratories.
 * Subsequent changes by Jeff Prothero Copyright (c) 2010,
 * released under Gnu Public Licence version 3.
 */

