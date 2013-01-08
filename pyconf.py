#!/usr/bin/env python

# Copyright (C) 2013 Brandon Invergo <brandon@invergo.net>
#
# This file is part of pyconfigure.
#
# pyconfigure is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# pyconfigure is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with pyconfigure.  If not, see <http://www.gnu.org/licenses/>.


from __future__ import print_function
import os.path
import sys
import getopt
import shutils
import subprocess


DATADIR = "/usr/local/share/pyconfigure/"


def parse_pkg_info(pkg_info):
    pass


def gen_configure(pkg_meta, output):
    config_src = os.path.join(DATADIR, "configure.ac")
    config_dst = os.path.join(output, "configure.ac")
    bootstrap = os.path.join(DATADIR, "bootstrap.sh")
    with open(config_src, 'r') as h:
        config_lines = h.readlines()
    init_i = config_lines.index("@AC_INIT_LINE@")
    config_lines[init_i] = "AC_INIT([{0}], [{1}], [{2}])".format(
        pkg_meta["name"],
        pkg_meta["version"],
        pkg_meta["email"])
    with open(config_dst, 'w') as h:
        for line in config_lines:
            h.write(line)
    shutils.copy(bootstrap, output)
    subprocess.call(["autoreconf", "-fvi", output])


def gen_makefile(pkg_meta, output, prefer_make):
    pass


def gen_distutils(pkg_meta, output, prefer_make):
    pass


def print_usage():
    print("""Usage: pyconf [OPTIONS] [TARGET] PKG-INFO
Generate `configure' and installation scripts for a Python program

OPTIONS
    -o, --output=DIR    directory to move the generated files
    --prefer-make       prefer Make for performing installation logic,
                        otherwise prefer the TARGET
    --help              show this information
TARGETSl:
    distutils (default)

By default, the generated `Makefile' will be a wrapper around the
TARGET-based script for Python (i.e. distutils' `setup.py' script).
If `--prefer-make' is specified, the TARGET-based Python script will
be a wrapper around `Makefile'.

For more information on the PKG-INFO file format, see PEP 345.
<http://www.python.org/dev/peps/pep-0345/>

Report bugs to: bug-pyconfigure@gnu.org
pyconfigure home page: <http://www.gnu.org/software/pyconfigure/>
General help using GNU software: <http://www.gnu.org/get/help/>""")


if __name__ == "__main__":
    long_args = ["help", "output", "prefer-make"]
    try:
        opts, args = getopt.gnu_getopt(sys.argv[1:], "ho:", long_args)
    except getopt.GetoptError as err:
        print(str(err))
        print_usage()
        sys.exit(2)
    output = os.getcwd()
    prefer_make = False
    for o, a in opts:
        if o in ["-h", "--help"]:
            print_usage()
            sys.exit()
        if o in ["-o", "--output"]:
            output = a
        if o in ["--prefer-make"]:
            prefer_make = True
        else:
            print("Warning: unhandled option")
    if len(args) == 0:
        print_usage()
        sys.exit(2)
    elif len(args) == 1:
        target = 0
        pkg_info = args[0]
    else:
        # do the following with an eye to the future of handling more
        # Python packaging systems:
        target = {"distutils":0}.get(args[0])
        if target is None:
            print("Error: invalid target {0}".format([args[0]))
            sys.exit(2)
        pkg_info = args[1]
    if not os.isfile(pkg_info):
        print("Error: PKG-INFO file does not exist")
        sys.exit(2)
    pkg_meta = parse(pkg_info)
    gen_configure(pkg_meta, output)
    gen_makefile(pkg_meta, output, prefer_make)
    # also with an eye to the future:
    [gen_distutils][target](pkg_meta, output, prefer_make)
