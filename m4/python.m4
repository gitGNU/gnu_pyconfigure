# Python Autoconf macros

# Some of these macros were written by Andrew Dalke and James Henstridge
# and are included with the Automake utility under the following copyright terms:
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


## ----------------------- ##
## 1. Language selection.  ##
## ----------------------- ##


# AC_LANG(Python)
# ---------------
AC_LANG_DEFINE([Python], [py], [PY], [PYTHON], [],
[ac_ext=py
ac_compile='$PYTHON $PYFLAGS conftest.$ac_ext >&AS_MESSAGE_LOG_FD'
ac_link=''
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
$1
if __name__ == "__main__":
    $2
])


# _AC_LANG_NULL_PROGRAM(Python)
# -----------------------------
# Produce source that does nothing.
m4_define([_AC_LANG_NULL_PROGRAM(Python)],
[AC_LANG_PROGRAM([], [])])


# _AC_LANG_IO_PROGRAM(Python)
# ---------------------------
# Produce source that performs I/O.
m4_define([_AC_LANG_IO_PROGRAM(Python)],
[AC_LANG_PROGRAM([dnl
import sys
try:
    h = open("conftest.out")
except:
    sys.exit(1)
else:
    close(h)
    sys.exit(0)
], [pass])])


# _AC_LANG_CALL(Python)([PROLOGUE], [FUNCTION])
# ---------------------
# Produce source that calls FUNCTION
m4_define([_AC_LANG_CALL(Python)],
[AC_LANG_PROGRAM([$1], [$2])])


## -------------------------------------------- ##
## 3. Looking for Compilers and Interpreters.   ##
## -------------------------------------------- ##


# PC_PYTHON_PATH_PY([MINIMUM-VERSION], [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
# ---------------------------------------------------------------------------
AC_DEFUN([PC_PYTHON_PATH],
 [
  dnl Find a Python interpreter.  Python versions prior to 2.0 are not
  dnl supported. (2.0 was released on October 16, 2000).
  m4_define_default([_PC_PYTHON_INTERPRETER_LIST],
[python python2 python3 python3.2 python3.1 python3.0 python2.7 dnl
 python2.6 python2.5 python2.4 python2.3 python2.2 python2.1 python2.0])

  AC_ARG_VAR([PYTHON], [the Python interpreter])

  m4_if([$1],[],[
    dnl No version check is needed.
    # Find any Python interpreter.
    if test -z "$PYTHON"; then
      AC_PATH_PROGS([PYTHON], _PC_PYTHON_INTERPRETER_LIST, :)
    fi
    pc_display_PYTHON=python
  ], [
    dnl A version check is needed.
    if test -n "$PYTHON"; then
      # If the user set $PYTHON, use it and don't search something else.
      AC_MSG_CHECKING([whether $PYTHON version is >= $1])
      PC_PYTHON_CHECK_VERSION([$PYTHON], [$1],
			      [AC_MSG_RESULT([yes])],
			      [AC_MSG_RESULT([no])
			       AC_MSG_ERROR([Python interpreter is too old])])
      pc_display_PYTHON=$PYTHON
    else
      # Otherwise, try each interpreter until we find one that satisfies
      # VERSION.
      AC_CACHE_CHECK([for a Python interpreter with version >= $1],
	[pc_cv_pathless_PYTHON],[
	for pc_cv_pathless_PYTHON in _PC_PYTHON_INTERPRETER_LIST none; do
	  test "$pc_cv_pathless_PYTHON" = none && break
	  PC_PYTHON_CHECK_VERSION([$pc_cv_pathless_PYTHON], [$1], [break])
	done])
      # Set $PYTHON to the absolute path of $pc_cv_pathless_PYTHON.
      if test "$pc_cv_pathless_PYTHON" = none; then
	PYTHON=:
      else
        AC_PATH_PROG([PYTHON], [$pc_cv_pathless_PYTHON])
      fi
      pc_display_PYTHON=$pc_cv_pathless_PYTHON
    fi
  ])

  if test "$PYTHON" = :; then
  dnl Run any user-specified action, or abort.
    m4_default([$3], [AC_MSG_ERROR([no suitable Python interpreter found])])
  else

  dnl Query Python for its version number.  Getting [:3] seems to be
  dnl the best way to do this; it's what "site.py" does in the standard
  dnl library.

  AC_CACHE_CHECK([for $pc_display_PYTHON version], [pc_cv_python_version],
    [pc_cv_python_version=`$PYTHON -c "import sys; sys.stdout.write(sys.version[[:3]])"`])
  AC_SUBST([PYTHON_VERSION], [$pc_cv_python_version])

  dnl Use the values of $prefix and $exec_prefix for the corresponding
  dnl values of PYTHON_PREFIX and PYTHON_EXEC_PREFIX.  These are made
  dnl distinct variables so they can be overridden if need be.  However,
  dnl general consensus is that you shouldn't need this ability.

  AC_SUBST([PYTHON_PREFIX], ['${prefix}'])
  AC_SUBST([PYTHON_EXEC_PREFIX], ['${exec_prefix}'])

  dnl At times (like when building shared libraries) you may want
  dnl to know which OS platform Python thinks this is.

  AC_CACHE_CHECK([for $pc_display_PYTHON platform], [pc_cv_python_platform],
    [pc_cv_python_platform=`$PYTHON -c "import sys; sys.stdout.write(sys.platform)"`])
  AC_SUBST([PYTHON_PLATFORM], [$pc_cv_python_platform])


  dnl Set up 4 directories:

  dnl pythondir -- where to install python scripts.  This is the
  dnl   site-packages directory, not the python standard library
  dnl   directory like in previous automake betas.  This behavior
  dnl   is more consistent with lispdir.m4 for example.
  dnl Query distutils for this directory.
  AC_CACHE_CHECK([for $pc_display_PYTHON script directory],
    [pc_cv_python_pythondir],
    [if test "x$prefix" = xNONE
     then
       pc_py_prefix=$ac_default_prefix
     else
       pc_py_prefix=$prefix
     fi
     pc_cv_python_pythondir=`$PYTHON -c "import sys; from distutils import sysconfig; sys.stdout.write(sysconfig.get_python_lib(0,0,prefix='$pc_py_prefix'))" 2>/dev/null`
     case $pc_cv_python_pythondir in
     $pc_py_prefix*)
       pc__strip_prefix=`echo "$pc_py_prefix" | sed 's|.|.|g'`
       pc_cv_python_pythondir=`echo "$pc_cv_python_pythondir" | sed "s,^$pc__strip_prefix,$PYTHON_PREFIX,"`
       ;;
     *)
       case $pc_py_prefix in
         /usr|/System*) ;;
         *)
	  pc_cv_python_pythondir=$PYTHON_PREFIX/lib/python$PYTHON_VERSION/site-packages
	  ;;
       esac
       ;;
     esac
    ])
  AC_SUBST([pythondir], [$pc_cv_python_pythondir])

  dnl pkgpythondir -- $PACKAGE directory under pythondir.  Was
  dnl   PYTHON_SITE_PACKAGE in previous betas, but this naming is
  dnl   more consistent with the rest of automake.

  AC_SUBST([pkgpythondir], [\${pythondir}/$PACKAGE])

  dnl pyexecdir -- directory for installing python extension modules
  dnl   (shared libraries)
  dnl Query distutils for this directory.
  AC_CACHE_CHECK([for $pc_display_PYTHON extension module directory],
    [pc_cv_python_pyexecdir],
    [if test "x$exec_prefix" = xNONE
     then
       pc_py_exec_prefix=$pc_py_prefix
     else
       pc_py_exec_prefix=$exec_prefix
     fi
     pc_cv_python_pyexecdir=`$PYTHON -c "import sys; from distutils import sysconfig; sys.stdout.write(sysconfig.get_python_lib(1,0,prefix='$pc_py_exec_prefix'))" 2>/dev/null`
     case $pc_cv_python_pyexecdir in
     $pc_py_exec_prefix*)
       pc__strip_prefix=`echo "$pc_py_exec_prefix" | sed 's|.|.|g'`
       pc_cv_python_pyexecdir=`echo "$pc_cv_python_pyexecdir" | sed "s,^$pc__strip_prefix,$PYTHON_EXEC_PREFIX,"`
       ;;
     *)
       case $pc_py_exec_prefix in
         /usr|/System*) ;;
         *)
	   pc_cv_python_pyexecdir=$PYTHON_EXEC_PREFIX/lib/python$PYTHON_VERSION/site-packages
	   ;;
       esac
       ;;
     esac
    ])
  AC_SUBST([pyexecdir], [$pc_cv_python_pyexecdir])

  dnl pkgpyexecdir -- $(pyexecdir)/$(PACKAGE)

  AC_SUBST([pkgpyexecdir], [\${pyexecdir}/$PACKAGE])

  dnl Run any user-specified action.
  $2
  fi

])


# ---------------------------------------------------------------------------
# Run ACTION-IF-TRUE if the Python interpreter PROG has version >= VERSION.
# Run ACTION-IF-FALSE otherwise.
# This test uses sys.hexversion instead of the string equivalent (first
# word of sys.version), in order to cope with versions such as 2.2c1.
# This supports Python 2.0 or higher. (2.0 was released on October 16, 2000).
AC_DEFUN([PC_PYTHON_CHECK_VERSION],
 [prog="import sys
# split strings by '.' and convert to numeric.  Append some zeros
# because we need at least 4 digits for the hex conversion.
# map returns an iterator in Python 3.0 and a list in 2.x
minver = list(map(int, '$2'.split('.'))) + [[0, 0, 0]]
minverhex = 0
# xrange is not present in Python 3.0 and range returns an iterator
for i in list(range(0, 4)): minverhex = (minverhex << 8) + minver[[i]]
sys.exit(sys.hexversion < minverhex)"
  AS_IF([AM_RUN_LOG([$1 -c "$prog"])], [$3], [$4])])

AC_DEFUN([AC_PROG_PYTHON], [PC_PYTHON_PATH])

AC_DEFUN([AC_LANG_COMPILER(Python)],
[AC_REQUIRE([AC_PROG_PYTHON])])

# PC_PYTHON_CHECK_LIB(LIBRARY, [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
# ----------------------------------------------------------------------
# Macro for checking if a Python library is installed
AC_DEFUN([PC_PYTHON_CHECK_LIB],
[AC_REQUIRE([PC_PYTHON_PATH])[]dnl
AC_CACHE_CHECK([for Python '$1' library],
    [pc_cv_python_lib_$1],
    [AC_LANG_PUSH(Python)[]dnl
     AC_RUN_IFELSE(
	[AC_LANG_PROGRAM([], [dnl
import sys
try:
    import $1
except:
    sys.exit(1)
else:
    sys.exit(0)
])],
	[pc_cv_python_lib_$1="yes"],
	[pc_cv_python_lib_$1="no"])
     AC_LANG_POP(Python)[]dnl
    ])
#AC_SUBST([PYTHON_LIB_$1], [$pc_cv_erlang_lib_$1])
AS_IF([test "$pc_cv_python_lib_$1" = "no"], [$3], [$2])
])# PC_PYTHON_CHECK_LIB
