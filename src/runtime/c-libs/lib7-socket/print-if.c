/* print-if.c
 *
 * See overview comments in
 *
 *     src/runtime/c-libs/lib7-socket/print-if.h
 */

#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

#include "print-if.h"

int print_if_fd = 0;	/* Zero value means no trace logging. (We'd never log to stdin anyhow...)	*/

#define MAX_BUF 4096

void   print_if   (const char * fmt, ...) {

    if (!print_if_fd) {

       return;

    } else {

	char buf[ MAX_BUF ];

	va_list va;
	va_start(va, fmt);
	vsnprintf(buf, MAX_BUF, fmt, va); 
	va_end(va);

	{   int len = strlen( buf );
	    write( print_if_fd, buf, len );
	}
    }
}
