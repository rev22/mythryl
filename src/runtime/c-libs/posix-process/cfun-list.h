/* cfun-list.h
 *
 *
 * This file lists the directory library of C functions that are callable by lib7.
 */

#ifndef CLIB_NAME
#define CLIB_NAME	"POSIX-Process"
#define CLIB_VERSION	"1.0"
#define CLIB_DATE	"February 16, 1995"
#endif

CFUNC("osval",  _lib7_P_Process_osval,    "String -> int")
CFUNC("fork",   _lib7_P_Process_fork,     "Void -> int")
CFUNC("exec",   _lib7_P_Process_exec,     "(String * String list) -> 'a")
CFUNC("exece",  _lib7_P_Process_exece,    "(String * String list * String list) -> 'a")
CFUNC("execp",   _lib7_P_Process_execp,   "(String * String list) -> 'a")
CFUNC("waitpid", _lib7_P_Process_waitpid, "int * word -> int * int * int")
CFUNC("exit",    _lib7_P_Process_exit,    "int -> 'a")
CFUNC("kill",    _lib7_P_Process_kill,    "int * int -> Void")
CFUNC("alarm",   _lib7_P_Process_alarm,   "int -> int")
CFUNC("pause",   _lib7_P_Process_pause,   "Void -> Void")
CFUNC("sleep",   _lib7_P_Process_sleep,   "int -> int")



/* COPYRIGHT (c) 1995 AT&T Bell Laboratories.
 * Subsequent changes by Jeff Prothero Copyright (c) 2010,
 * released under Gnu Public Licence version 3.
 */
