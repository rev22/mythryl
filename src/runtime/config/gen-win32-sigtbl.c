/* gen-win32-sigtable.c
 *
 * generate the "win32-sigtable.c" file.
 */

#include "../config.h"

#include <signal.h>
#include <stdio.h>
#include "gen.h"
#include "win32-sigtab.h"

#ifndef DST_FILE
#define DST_FILE "win32-sigtable.c"
#endif

main ()
{
    FILE	    *f;
    int i;

    f = OpenFile (DST_FILE, NULL);

    fprintf (f, "/* This file autogenerated by src/runtime/config/gen-win32-sigtable.c -- do not edit. */\n");
    fprintf (f, "\n");

    fprintf (f, "static sys_const_t SigInfo[NUM_SIGS] = {\n");
    for (i = 0; i < NUM_SIGS; i++) {
      fprintf(f, "\t{ %d, \"%s\" },\n", win32SigTab[i].n, win32SigTab[i].sname);
    }
    fprintf (f, "};\n");

    fprintf (f, "static sysconst_table_t SigTable = {\n");
    fprintf (f, "    /* numConsts */ NUM_SIGS,\n");
    fprintf (f, "    /* consts */    SigInfo\n");
    fprintf (f, "};\n");

    CloseFile (f, NULL);

    exit (0);

}

/* COPYRIGHT (c) 1996 Bell Laboratories, Lucent Technologies
 */
/* end of gen-win32-sigtable.c */

