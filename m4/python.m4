# Python Autoconf macros

# Many of these macros were adapted from ones written by Andrew Dalke
# and James Henstridge and are included with the Automake utility
# under the following copyright terms:
#
# Copyright (C) 1999-2012 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# These macros' namespace and names were updated to not conflict with
# the Automake namespace and to fit naming conventions for Autoconf
# language definitions.

# The remaining macros were written by Brandon Invergo and distributed
# under the same terms. 


# Table of Contents:
#
# 1. Language selection
#    and routines to produce programs in a given language.
#
# 2. Producing programs in a given language.
#
# 3. Looking for a compiler
#    And possibly the associated preprocessor.
#
# 4. Looking for specific libs & functionality


## ----------------------- ##
## 1. Language selection.  ##
## ----------------------- ##


# AC_LANG(Python)
# ---------------
AC_LANG_DEFINE([Python], [py], [PY], [PYTHON], [],
[ac_ext=py
ac_compile='chmod +x conftest.$ac_ext >&AS_MESSAGE_LOG_FD'
ac_link='chmod +x conftest.$ac_ext && cp conftest.$ac_ext conftest >&AS_MESSAGE_LOG_FD'
])


# AC_LANG_PYTHON
# --------------
AU_DEFUN([AC_LANG_PYTHON], [AC_LANG(Python)])


## ----------------------- ##
## 2. Producing programs.  ##
## ----------------------- ##


# AC_LANG_PROGRAM(Python)([PROLOGUE], [BODY])
# -------------------------------------------
m4_define([AC_LANG_PROGRAM(Python)], [dnl
@%:@!$PYTHON
$1
if __name__ == '__main__':
$2
])


# _AC_LANG_IO_PROGRAM(Python)
# ---------------------------
# Produce source that performs I/O.
m4_define([_AC_LANG_IO_PROGRAM(Python)],
[AC_LANG_PROGRAM([dnl
import sys
try:
    h = open('conftest.out')
except:
    sys.exit(1)
else:
    close(h)
    sys.exit(0)
], [
    pass
])])


# _AC_LANG_CALL(Python)([PROLOGUE], [FUNCTION])
# ---------------------
# Produce source that calls FUNCTION
m4_define([_AC_LANG_CALL(Python)],
[AC_LANG_PROGRAM([$1], [$2])])



## -------------------------------------------- ##
## 3. Looking for Compilers and Interpreters.   ##
## -------------------------------------------- ##


AC_DEFUN([AC_LANG_COMPILER(Python)],
[AC_REQUIRE([AC_PROG_PYTHON])])


# AC_PROG_PYTHON(PROG-TO-CHECK-FOR)
# ---------------------------------
# Find a Python interpreter.  Python versions prior to 2.0 are not
# supported. (2.0 was released on October 16, 2000).
AC_DEFUN([AC_PROG_PYTHON],
[AC_ARG_VAR([PYTHON], [the Python interpreter])
m4_define_default([_PC_PYTHON_INTERPRETER_LIST],
                  [python python2 python3 python3.2 python3.1 python3.0 python2.7 dnl
                   python2.6 python2.5 python2.4 python2.3 python2.2 python2.1 python2.0])
m4_ifval([$1],
	[AC_PATH_PROGS(PYTHON, [$1 _PC_PYTHON_INTERPRETER_LIST])],
	[AC_PATH_PROGS(PYTHON, [_PC_PYTHON_INTERPRETER_LIST])])
])
  

# PC_PYTHON_PROG_PYTHONCONFIG(PROG-TO-CHECK-FOR)
# ----------------------------------------------
# Find the python-config program
AC_DEFUN([PC_PYTHON_PROG_PYTHONCONFIG],
[AC_REQUIRE([AC_PROG_PYTHON])[]dnl
AC_ARG_VAR([PYTHONCONFIG], [the Python-config program])
m4_define([_PYTHON_BASENAME], [`basename $PYTHON`])
m4_ifval([$1],
	[AC_PATH_PROGS(PYTHONCONFIG, [$1 _PYTHON_BASENAME-config])],
	[AC_PATH_PROG(PYTHONCONFIG, _PYTHON_BASENAME-config)])
dnl if test -n "$PYTHONCONFIG"; then
dnl    m4_define_default([_PC_PYTHON_VER_STR],
dnl                      [python python2 python3 python3.2 python3.1 python3.0 python2.7 dnl
dnl                       python2.6 python2.5 python2.4 python2.3 python2.2 python2.1 python2.0])
dnl    m4_define(_PC_PYTHON_VER_LIST, m4_split(_PC_PYTHON_VER_STR))
dnl    m4_define(_PC_PYTHON_CONFIG_LIST, m4_combine([ ],
dnl        _PC_PYTHON_CONFIG_LIST, [-], [config]))
dnl    m4_ifval([$1],
dnl  	[AC_PATH_PROGS(PYTHONCONFIG, [$1 _PC_PYTHON_CONFIG_LIST])],
dnl 	[AC_PATH_PROG(PYTHONCONFIG, _PC_PYTHON_CONFIG_LIST)])
dnl fi
]) # PC_PYTHON_PROG_PYTHONCONFIG


# PC_PYTHON_VERIFY_VERSION(PYTHON-PROGRAM, VERSION, [ACTION-IF-TRUE], [ACTION-IF-NOT-FOUND])
# ---------------------------------------------------------------------------
# Run ACTION-IF-TRUE if the Python interpreter PROG has version >= VERSION.
# Run ACTION-IF-FALSE otherwise.
# This test uses sys.hexversion instead of the string equivalent (first
# word of sys.version), in order to cope with versions such as 2.2c1.
# This supports Python 2.0 or higher. (2.0 was released on October 16, 2000).
AC_DEFUN([PC_PYTHON_VERIFY_VERSION],
[AC_REQUIRE([AC_PROG_PYTHON])[]dnl
m4_define([pc_python_safe_ver], m4_bpatsubsts($2, [\.], [_]))
AC_CACHE_CHECK([if Python >= '$2'],
    [[pc_cv_python_min_version_]pc_python_safe_ver],
    [AC_LANG_PUSH(Python)[]dnl
     AC_RUN_IFELSE(
        [AC_LANG_PROGRAM([dnl
import sys
], [dnl
    # split strings by '.' and convert to numeric.  Append some zeros
    # because we need at least 4 digits for the hex conversion.
    # map returns an iterator in Python 3.0 and a list in 2.x
    minver = list(map(int, '$2'.split('.'))) + [[0, 0, 0]]
    minverhex = 0
    # xrange is not present in Python 3.0 and range returns an iterator
    for i in list(range(4)):
        minverhex = (minverhex << 8) + minver[[i]]
    sys.exit(sys.hexversion < minverhex)
])], 
         [[pc_cv_python_min_version_]pc_python_safe_ver="yes"], 
         [[pc_cv_python_min_version_]pc_python_safe_ver="no"])
     AC_LANG_POP(Python)[]dnl
    ])
AS_IF([test "$[pc_cv_python_min_version_]pc_python_safe_ver" = "no"], [$4], [$3])
])# PC_PYTHON_VERIFY_VERSION


# PC_PYTHON_CHECK_VERSION
# -----------------------
# Query Python for its version number.  Getting [:3] seems to be
# the best way to do this; it's what "site.py" does in the standard
# library.
AC_DEFUN([PC_PYTHON_CHECK_VERSION],
[AC_REQUIRE([AC_PROG_PYTHON])[]dnl
AC_CACHE_CHECK([for $1 version], 
    [pc_cv_python_version],
    [AC_LANG_PUSH(Python)[]dnl
     AC_LANG_CONFTEST([
         AC_LANG_PROGRAM([dnl
import sys
], [dnl
    sys.stdout.write(sys.version[[:3]])
])])
     pc_cv_python_version=`$PYTHON conftest.py`
     AC_LANG_POP(Python)[]dnl
    ])
AC_SUBST([PYTHON_VERSION], [$pc_cv_python_version])
])# PC_PYTHON_CHECK_VERSION


# PC_PYTHON_CHECK_PREFIX
# ----------------------
# Use the value of $prefix for the corresponding value of
# PYTHON_PREFIX. This is made a distinct variable so it can be
# overridden if need be.  However, general consensus is that you
# shouldn't need this ability.
AC_DEFUN([PC_PYTHON_CHECK_PREFIX],
[AC_REQUIRE([PC_PYTHON_PROG_PYTHONCONFIG])[]dnl
AC_CACHE_CHECK([for Python prefix], [pc_cv_python_prefix],
    [pc_cv_python_prefix=`$PYTHONCONFIG --prefix`])
AC_SUBST([PYTHON_PREFIX], [$pc_cv_python_prefix])])


# PC_PYTHON_CHECK_EXECPREFIX
# --------------------------
# Like above, but for $exec_prefix
AC_DEFUN([PC_PYTHON_CHECK_EXECPREFIX],
[AC_REQUIRE([PC_PYTHON_PROG_PYTHONCONFIG])[]dnl
AC_CACHE_CHECK([for Python exec-prefix], [pc_cv_python_exec_prefix],
    [pc_cv_python_exec_prefix=`$PYTHONCONFIG --exec-prefix`])
AC_SUBST([PYTHON_EXEC_PREFIX], [$pc_cv_python_exec_prefix])])


# PC_PYTHON_CHECK_INCLUDES
# ------------------------
# Find the Python header file include flags (ie
# '-I/usr/include/python')
AC_DEFUN([PC_PYTHON_CHECK_INCLUDES],
[AC_REQUIRE([PC_PYTHON_PROG_PYTHONCONFIG])[]dnl
AC_CACHE_CHECK([for Python includes], [pc_cv_python_includes],
    [pc_cv_python_includes=`$PYTHONCONFIG --includes`])
AC_SUBST([PYTHON_INCLUDES], [$pc_cv_python_includes])])


# PC_PYTHON_CHECK_HEADERS([ACTION-IF-PRESENT], [ACTION-IF-ABSENT])
# -----------------------
# Check for the presence and usability of Python.h
AC_DEFUN([PC_PYTHON_CHECK_HEADERS],
[AC_REQUIRE([PC_PYTHON_CHECK_INCLUDES])[]dnl
pc_cflags_store=$CPPFLAGS
CPPFLAGS="$CFLAGS $PYTHON_INCLUDES"
AC_CHECK_HEADER([Python.h], [$1], [$2])
CPPFLAGS=$pc_cflags_store
])


# PC_PYTHON_CHECK_LIBS
# --------------------
# Find the Python lib flags (ie '-lpython')
AC_DEFUN([PC_PYTHON_CHECK_LIBS],
[AC_REQUIRE([PC_PYTHON_PROG_PYTHONCONFIG])[]dnl
AC_CACHE_CHECK([for Python libs], [pc_cv_python_libs],
    [pc_cv_python_libs=`$PYTHONCONFIG --libs`])
AC_SUBST([PYTHON_LIBS], [$pc_cv_python_libs])])


# PC_PYTHON_CHECK_CFLAGS
# ----------------------
# Find the Python CFLAGS
AC_DEFUN([PC_PYTHON_CHECK_CFLAGS],
[AC_REQUIRE([PC_PYTHON_PROG_PYTHONCONFIG])[]dnl
AC_CACHE_CHECK([for Python CFLAGS], [pc_cv_python_CFLAGS],
    [pc_cv_python_cflags=`$PYTHONCONFIG --cflags`])
AC_SUBST([PYTHON_CFLAGS], [$pc_cv_python_cflags])])


# PC_PYTHON_CHECK_LDFLAGS
# -----------------------
# Find the Python LDFLAGS
AC_DEFUN([PC_PYTHON_CHECK_LDFLAGS],
[AC_REQUIRE([PC_PYTHON_PROG_PYTHONCONFIG])[]dnl
AC_CACHE_CHECK([for Python LDFLAGS], [pc_cv_python_LDFLAGS],
    [pc_cv_python_cflags=`$PYTHONCONFIG --ldflags`])
AC_SUBST([PYTHON_LDFLAGS], [$pc_cv_python_ldflags])])


# PC_PYTHON_CHECK_EXTENSION_SUFFIX
# --------------------------------
# Find the Python extension suffix (i.e. '.cpython-32.so')
AC_DEFUN([PC_PYTHON_CHECK_EXTENSION_SUFFIX],
[AC_REQUIRE([PC_PYTHON_PROG_PYTHONCONFIG])[]dnl
AC_CACHE_CHECK([for Python extension suffix], [pc_cv_python_extension_suffix],
    [pc_cv_python_extension_suffix=`$PYTHONCONFIG --extension-suffix`])
AC_SUBST([PYTHON_EXTENSION_SUFFIX], [$pc_cv_python_extension_suffix])])


# PC_PYTHON_CHECK_ABI_FLAGS
# -------------------------
# Find the Python ABI flags
AC_DEFUN([PC_PYTHON_CHECK_ABI_FLAGS],
[AC_REQUIRE([PC_PYTHON_PROG_PYTHONCONFIG])[]dnl
AC_CACHE_CHECK([for Python ABI flags], [pc_cv_python_abi_flags],
    [pc_cv_python_abi_flags=`$PYTHONCONFIG --abiflags`])
AC_SUBST([PYTHON_ABI_FLAGS], [$pc_cv_python_abi_flags])])


# PC_PYTHON_CHECK_PLATFORM
# ------------------------
# At times (like when building shared libraries) you may want
# to know which OS platform Python thinks this is.
AC_DEFUN([PC_PYTHON_CHECK_PLATFORM],
[AC_REQUIRE([AC_PROG_PYTHON])[]dnl
AC_CACHE_CHECK([for Python platform], 
    [pc_cv_python_platform],
    [AC_LANG_PUSH(Python)[]dnl
     AC_LANG_CONFTEST([
         AC_LANG_PROGRAM([dnl
import sys
], [dnl
    sys.stdout.write(sys.platform)
])])
    pc_cv_python_platform=`$PYTHON conftest.py`
    AC_LANG_POP(Python)[]dnl
   ])
AC_SUBST([PYTHON_PLATFORM], [$pc_cv_python_platform])
])


# PC_PYTHON_CHECK_SITE_DIR
# ---------------------
# The directory to which new libraries are installed (i.e. the
# "site-packages" directory.
AC_DEFUN([PC_PYTHON_CHECK_SITE_DIR],
[AC_REQUIRE([AC_PROG_PYTHON])[]dnl
AC_CACHE_CHECK([for Python site-packages directory],
    [pc_cv_python_site_dir],
    [AC_LANG_PUSH(Python)[]dnl
    if test "x$prefix" = xNONE
     then
       pc_py_prefix=$ac_default_prefix
     else
       pc_py_prefix=$prefix
     fi
     AC_LANG_CONFTEST([
         AC_LANG_PROGRAM([dnl
import sys
try:
    import sysconfig
except:
    from distutils import sysconfig
    sitedir = sysconfig.get_python_lib(False, False, prefix='$pc_py_prefix')
else:
    sitedir = sysconfig.get_path('purelib', vars={'base':'$pc_py_prefix'})
], [dnl
    sys.stdout.write(sitedir)
])])
     pc_cv_python_site_dir=`$PYTHON conftest.py`
     AC_LANG_POP(Python)[]dnl
     case $pc_cv_python_site_dir in
     $pc_py_prefix*)
       pc__strip_prefix=`echo "$pc_py_prefix" | sed 's|.|.|g'`
       pc_cv_python_site_dir=`echo "$pc_cv_python_site_dir" | sed "s,^$pc__strip_prefix,$PYTHON_PREFIX,"`
       ;;
     *)
       case $pc_py_prefix in
         /usr|/System*) ;;
         *)
	  pc_cv_python_site_dir=$PYTHON_PREFIX/lib/python$PYTHON_VERSION/site-packages
	  ;;
       esac
       ;;
     esac
     ])
AC_SUBST([PYTHON_SITE_DIR], [$pc_cv_python_site_dir])])# PC_PYTHON_CHECK_SITE_DIR
])

# PC_PYTHON_SITE_PACKAGE_DIR
# --------------------------
# $PACKAGE directory under PYTHON_SITE_DIR
AC_DEFUN([PC_PYTHON_SITE_PACKAGE_DIR],
[AC_REQUIRE([PC_PYTHON_CHECK_SITE_DIR])[]dnl
AC_SUBST([PYTHON_SITE_PACKAGE_DIR], [$PYTHON_SITE_DIR/$PACKAGE])])


# PC_PYTHON_CHECK_EXEC_DIR
# ------------------------
# directory for installing python extension modules (shared libraries)
AC_DEFUN([PC_PYTHON_CHECK_EXEC_DIR],
[AC_REQUIRE([AC_PROG_PYTHON])[]dnl
  AC_CACHE_CHECK([for Python extension module directory],
    [pc_cv_python_exec_dir],
    [AC_LANG_PUSH(Python)[]dnl
    if test "x$pc_cv_python_exec_prefix" = xNONE
     then
       pc_py_exec_prefix=$pc_cv_python_prefix
     else
       pc_py_exec_prefix=$pc_cv_python_exec_prefix
     fi
     AC_LANG_CONFTEST([
         AC_LANG_PROGRAM([dnl
import sys
try:
    import sysconfig
except:
    from distutils import sysconfig
    sitedir = sysconfig.get_python_lib(True, False, prefix='$pc_py_exec_prefix')
else:
    sitedir = sysconfig.get_path('platlib', vars={'platbase':'$pc_py_exec_prefix'})
], [dnl
    sys.stdout.write(sitedir)
])])
     pc_cv_python_exec_dir=`$PYTHON conftest.py`
     AC_LANG_POP(Python)[]dnl
     case $pc_cv_python_exec_dir in
     $pc_py_exec_prefix*)
       pc__strip_prefix=`echo "$pc_py_exec_prefix" | sed 's|.|.|g'`
       pc_cv_python_pyexecdir=`echo "$pc_cv_python_exec_dir" | sed "s,^$pc__strip_prefix,$PYTHON_EXEC_PREFIX,"`
       ;;
     *)
       case $pc_py_exec_prefix in
         /usr|/System*) ;;
         *)
	   pc_cv_python_exec_dir=$PYTHON_EXEC_PREFIX/lib/python$PYTHON_VERSION/site-packages
	   ;;
       esac
       ;;
     esac
    ])
AC_SUBST([PYTHON_EXEC_DIR], [$pc_cv_python_pyexecdir])]) #PY_PYTHON_CHECK_EXEC_LIB_DIR
])

# PC_PYTHON_EXEC_PACKAGE_DIR
# --------------------------
# $PACKAGE directory under PYTHON_SITE_DIR
AC_DEFUN([PC_PYTHON_EXEC_PACKAGE_DIR],
[AC_REQUIRE([PC_PYTHON_CHECK_EXEC_DIR])[]dnl
AC_SUBST([PYTHON_EXEC_PACKAGE_DIR], [PYTHON_EXEC_DIR/$PACKAGE])])


## -------------------------------------------- ##
## 4. Looking for specific libs & functionality ##
## -------------------------------------------- ##


# PC_PYTHON_CHECK_LIB(LIBRARY, [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
# ----------------------------------------------------------------------
# Macro for checking if a Python library is installed
AC_DEFUN([PC_PYTHON_CHECK_LIB],
[AC_REQUIRE([AC_PROG_PYTHON])[]dnl
AC_CACHE_CHECK([for Python '$1' library],
    [pc_cv_python_lib_$1],
    [AC_LANG_PUSH(Python)[]dnl
     AC_RUN_IFELSE(
	[AC_LANG_PROGRAM([dnl
import sys
try:
    import $1
except:
    sys.exit(1)
else:
    sys.exit(0)
], [
    pass
])],
	[pc_cv_python_lib_$1="yes"],
	[pc_cv_python_lib_$1="no"])
     AC_LANG_POP(Python)[]dnl
    ])
AS_IF([test "$pc_cv_python_lib_$1" = "no"], [$3], [$2])
])# PC_PYTHON_CHECK_LIB


# PC_PYTHON_CHECK_FUNC(LIBRARY, FUNCTION, ARGS, [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
AC_DEFUN([PC_PYTHON_CHECK_FUNC],
[AC_REQUIRE([AC_PROG_PYTHON])[]dnl
AC_CACHE_CHECK([for Python m4_ifnblank($1, '$1.$2()', '$2()') function],
    [pc_cv_python_func_$1_$2],
    [AC_LANG_PUSH(Python)[]dnl
     AC_RUN_IFELSE(
	[AC_LANG_PROGRAM([dnl
import sys
m4_ifnblank([$1], [import $1], [])
], 
[
m4_ifnblank([$1], [
    try:
        $1.$2($3)], [
    try:
        $2($3)])
    except:
        sys.exit(1)
    else:
        sys.exit(0)
])],
	[pc_cv_python_func_$1_$2="yes"],
	[pc_cv_python_func_$1_$2="no"])
     AC_LANG_POP(Python)[]dnl
    ])
AS_IF([test "$pc_cv_python_func_$1_$2" = "no"], [$5], [$4])
])# PC_PYTHON_CHECK_FUNC
