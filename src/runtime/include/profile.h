/* profile.h
 *
 */

#ifndef _PROFILE_
#define _PROFILE_

#ifndef PROFILE_QUANTUM_US
#  define PROFILE_QUANTUM_US	10000		/* profile timer quantum in uS */
#endif

extern lib7_val_t	ProfCntArray;

/* Indices into the ProfCntArray for the run-time and GC; these need to
 * track the definitions in sml-nj/boot/NJ/prof-control.pkg.
 */
#define PROF_RUNTIME	INT_CtoLib7(0)
#define PROF_MINOR_GC	INT_CtoLib7(1)
#define PROF_MAJOR_GC	INT_CtoLib7(2)
#define PROF_OTHER	INT_CtoLib7(3)

#endif /* _PROFILE_ */



/* COPYRIGHT (c) 1996 AT&T Research.
 * Subsequent changes by Jeff Prothero Copyright (c) 2010,
 * released under Gnu Public Licence version 3.
 */
