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
import shutil
import subprocess


DATADIR = "/home/brandon/Projects/pyconfigure/pyconfigure/src/"


def parse_pkg_info(pkg_info):
    singles = ["Name", "Version", "Summary", "Keywords", "Home-page",
               "Download-URL", "Author", "Author-email", "Maintainer",
               "Maintainer-email", "License", "Requires-Python", 
               "Description", "Metadata-Version"]
    multis = ["Platform", "Supported-Platform", "Classifier", "Requires-Dist",
              "Provides-Dist", "Obsoletes-Dist", "Requires-External",
              "Project-URL"]
    pkg_meta = {}
    for key in singles:
        pkg_meta[key] = ""
    for key in multis:
        pkg_meta[key] = []
    with open(pkg_info) as h:
        lines = h.readlines()
    for line in lines:
        key, sep, val = line.partition(':')
        val = val.strip()
        if key == "Metadata-Version" and float(val) < 1.2:
            sys.exit("*** Error: PKG-INFO metadata format version 1.2 or greater \
is required")
        elif key in singles:
            if pkg_meta[key] == "":
                pkg_meta[key] = val
            else:
                print("==> Warning: multiple entries for metadata field \
'{0}'".format(key))
        elif key in multis:
            pkg_meta[key].append(val)
        else:
            print("==> Warning: unknown metadata field '{0}'".format(key))
            continue
    if "Project-URL" in pkg_meta and len(pkg_meta["Project-URL"]) > 0:
        pkg_meta["URL"] = pkg_meta["Project-URL"][0]
    else:
        pkg_meta["URL"] = ""
    for key in multis:
        if key in pkg_meta and len(pkg_meta[key]) > 0:
            pkg_meta["{0}-list".format(key)] = "',\n\t\t'".join(pkg_meta[key])
        else:
            pkg_meta["{0}-list".format(key)] = ""
    return pkg_meta


def subst_meta(in_file, out_file, pkg_meta):
    with open(in_file) as h:
        lines = h.readlines()
    with open(out_file, 'w') as h:
        for line in lines:
            line_fmt = line.format(**pkg_meta)
            line_fmt = line_fmt.replace("\\[", "{")
            line_fmt = line_fmt.replace("\\]", "}")
            h.write(line_fmt)
    
    
def gen_configure(pkg_meta, output):
    config_src = os.path.join(DATADIR, "configure.ac")
    config_dst = os.path.join(output, "configure.ac")
    bootstrap = os.path.join(DATADIR, "bootstrap.sh")
    install_sh = os.path.join(DATADIR, "install-sh")
    macros = os.path.join(DATADIR, "m4", "python.m4")
    macro_dir = os.path.join(output, "m4")
    subst_meta(config_src, config_dst, pkg_meta)
    print("Copying bootstrap.sh")
    shutil.copy(bootstrap, output)
    print("Copying Python m4 macros")
    try:
        os.mkdir(macro_dir)
    except FileExistsError:
        pass
    shutil.copy(macros, macro_dir)
    print("Generating `configure'")
    shutil.copy(install_sh, output)
    subprocess.call(["autoreconf", "-fvi", output])


def gen_makefile(pkg_meta, output, prefer_make):
    if prefer_make:
        makefile_src = os.path.join(DATADIR, "Makefile.in.make")
    else:
        makefile_src = os.path.join(DATADIR, "Makefile.in.distutils")
    makefile_dst = os.path.join(output, "Makefile.in")
    shutil.copy(makefile_src, makefile_dst)


def gen_distutils(pkg_meta, output, prefer_make):
    if prefer_make:
        setup_py_src = os.path.join(DATADIR, "setup.py.in.make")
    else:
        setup_py_src = os.path.join(DATADIR, "setup.py.in.distutils")
    setup_py_dst = os.path.join(output, "setup.py.in")
    if not prefer_make:
        subst_meta(setup_py_src, setup_py_dst, pkg_meta)
    shutil.copy(setup_py_src, setup_py_dst)


def print_usage():
    print("""Usage: pyconf [OPTIONS] [TARGET] PKG-INFO
Generate `configure' and installation scripts for a Python program

OPTIONS
    -o, --output=DIR    directory to move the generated files
    -m, --prefer-make   prefer using Make for performing installation 
                        logic, instead of the Python-based TARGET
    --no-make           do not generate a Makefile
    --help              show this information
TARGETS:
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
    long_args = ["help", "output", "prefer-make", "no-make"]
    try:
        opts, args = getopt.gnu_getopt(sys.argv[1:], "ho:m", long_args)
    except getopt.GetoptError as err:
        print(str(err))
        print_usage()
        sys.exit(2)
    output = os.getcwd()
    prefer_make = False
    no_make = False
    for o, a in opts:
        if o in ["-h", "--help"]:
            print_usage()
            sys.exit()
        if o in ["-o", "--output"]:
            output = a
        if o in ["-m", "--prefer-make"]:
            prefer_make = True
        if o in ["--no-make"]:
            no_make = True
            prefer_make = False
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
            print("Error: invalid target {0}".format(args[0]))
            sys.exit(2)
        pkg_info = args[1]
    if not os.path.isfile(pkg_info):
        print("Error: PKG-INFO file does not exist")
        sys.exit(2)
    print("Running pyconfigure in {0}".format(output))
    print("Parsing metadata...")
    pkg_meta = parse_pkg_info(pkg_info)
    print("Generating `configure.ac'")
    gen_configure(pkg_meta, output)
    if not no_make:
        print("Generating `Makefile.in'")
        gen_makefile(pkg_meta, output, prefer_make)
    # also with an eye to the future:
    print("Generating `setup.py.in'")
    [gen_distutils][target](pkg_meta, output, prefer_make)
