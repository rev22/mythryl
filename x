#!/usr/bin/mythryl

print "Hello!\n";

include threadkit;

package md = maildrop;

print "Boo!\n";
thread_scheduler .{
    sleep_for  time::from_seconds 2;
};
print "Hiss!\n";


exit 0;
