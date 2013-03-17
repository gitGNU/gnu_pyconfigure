#!/usr/bin/env python

# setup.py.in.make
#
# Copyright 2012, 2013 Brandon Invergo <brandon@invergo.net>
#
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.


from __future__ import print_function
import sys
import subprocess


def print_usage():
    print("""Usage: setup.py CMD1 [CMD2 CMD3 ...]

COMMANDS
    install
    uninstall
    clean
    distclean
    dist
    check

Report bugs to: bug-pyconfigure@gnu.org
pyconfigure home page: <http://www.gnu.org/software/pyconfigure/>
General help using GNU software: <http://www.gnu.org/get/help/>""")


if __name__ == "__main__":
    cmds = ["install", "uninstall", "clean", "distclean", "dist", "check"]
    make = ["make", "-C", "@srcdir@"]
    if len(sys.argv) == 1:
        print_usage()
        sys.exit(2)
    args = sys.argv[1:]
    for arg in args:
        if arg not in cmds:
            print("Warning: unknown command {0}".format(arg))
            args.remove(arg)
    make.extend(args)
    val = subprocess.call(make)
    sys.exit(val)
