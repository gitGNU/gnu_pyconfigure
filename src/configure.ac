# configure.ac
#
# Copyright 2012 Brandon Invergo <brandon@invergo.net>
#
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# This is a basic Autoconf configure.ac file for Python-based
# projects. It is not intended to be used as-is, but rather to be
# modified to the specific needs of the project.


dnl#######################################
dnl Define some m4 macros here as needed #
dnl#######################################

# The minimum-required Python versions
#m4_define(python_min_ver, 2.7.2)
#m4_define(python3_min_ver, 3.2.1)


dnl#############################################
dnl Import the Python-specific Autoconf macros #
dnl#############################################

# Unless these macros are included upstream somewhere, this must be included
m4_include([m4/python.m4])


dnl#######################################
dnl Autoconf and Automake initialization #
dnl#######################################

# Initialize Autoconf.
AC_INIT(project_name, project_version, [project_name-bug@gnu.org])

# Set some Automake flags
AC_SUBST(ACLOCAL_AMFLAGS, "-I m4 -I .")

# Initialize Automake
#AM_INIT_AUTOMAKE()

# Load macros from the m4/ directory
AC_CONFIG_MACRO_DIR([m4])

dnl#########################
dnl Python-specific macros #
dnl#########################

dnl# AC_PROG_PYTHON ##################################################
dnl
dnl This is line is the bare minimum that needs to be included. It
dnl locates the Python interpreter binary. You may optionally pass it
dnl an argument to pass a path to a binary. By default, this will
dnl first check for a binary called "python" and then from there it
dnl will check for version-specific binaries (ie "python3",
dnl "python2.7") in decending version order. Thus, the highest version
dnl binary will be found first. Note that if you call any of the
dnl following macros, you probably won't have to include this one at
dnl all, since most of the macros depend on this one.

AC_PROG_PYTHON

# Support installing to a virtualenv via the --with-virtualenv configure flag
AC_ARG_WITH([virtualenv],
	[AS_HELP_STRING([--with-virtualenv], [install to a Python virtualenv])],
	[],
	[with_virtualenv=no])
AS_IF([test "x$with_virtualenv" != xno],
	    AC_CHECK_PROGS([VIRTUALENV], [virtualenv virtualenv2], [no])
	    AS_IF([test "x$VIRTUALENV" = xno],
	    [AC_MSG_FAILURE(
		[--with-virtualenv given but virtualenv could not be found])]),
	AC_SUBST([VIRTUALENV], [no]))
AC_ARG_VAR([VIRTUALENV_FLAGS], [flags to pass to the virtualenv command])

# If the program uses sphinx-build to build documentation, uncomment this to 
# create a SPHINXBUILD variable in the Makefile pointing to the program
#AC_CHECK_PROGS([SPHINXBUILD], [sphinx-build sphinx-build3 sphinx-build2], [no])
#AS_IF([test "x$SPHINXBUILD" = xno], 
#	    AC_MSG_WARN(sphinx-build is required to build documentation))


# A couple extra useful commands
AC_PROG_MKDIR_P
AC_PROG_INSTALL	    


dnl # PC_PYTHON_VERIFY_VERSION #######################################
dnl
dnl This macro is used to check if the version of the discovered
dnl Python binary meets some minimum requirement. You may optionally
dnl provide actions to take if it does or if it doesn't meet the
dnl requirement.

## If your package only supports Python 2 you'll have to do some extra tests
## since by default AC_PROG_PYTHON will find the highest-version python binary,
## which may be Python 3.x

## First, look for a binary called "python2". If it can't be found, try just 
## searching for "python", but exit with an error if that binary is Python 3+

#AC_PROG_PYTHON([python2])
#if [[ "x$PYTHON" == "x" ]]; then
#   AC_PROG_PYTHON
#   PC_PYTHON_VERIFY_VERSION(3.0, ,
#	AC_MSG_ERROR(Python 2 (python_min_ver+) is required))
#fi

## Ok, we hopefully have a Python 2 interpreter if we made it this far, now 
## check if it is of the minimum version, otherwise exit with an error

#PC_PYTHON_VERIFY_VERSION(python_min_ver, ,
#	AC_MSG_ERROR(Python 2 (python_min_ver+) is required))

## In order to use some of the other macros, you also need the python-config
## command, which will fall subject to the same problem of python3-config 
## being preferred

#PC_PYTHON_PROG_PYTHON_CONFIG([python2-config])
#if [[ "x$PYTHON_CONFIG" == "x" ]]; then
#   PC_PYTHON_PROG_PYTHON_CONFIG([$PYTHON-config])
#fi   



dnl # PC_PYTHON_CHECK_PREFIX #########################################
dnl
dnl This macro finds out what Python thinks is the PREFIX
dnl (i.e. /usr) and stores it in PYTHON_PREFIX. You probably shouldn't
dnl use this and you should just stick to $prefix, but here it is
dnl anyway.

#PC_PYTHON_CHECK_PREFIX



dnl # PC_PYTHON_CHECK_EXEC_PREFIX ####################################
dnl
dnl The same as above but for $exec-prefix

#PC_PYTHON_CHECK_EXEC_PREFIX



dnl # PC_PYTHON_CHECK_INCLUDES #######################################
dnl
dnl This macro figures out the include flags necessary for loading the
dnl Python headers (ie -I/usr/lib/python). The results are stored in
dnl PYTHON_INCLUDES

#PC_PYTHON_CHECK_INCLUDES



dnl # PC_PYTHON_CHECK_HEADERS([ACTION-IF-PRESENT], [ACTION-IF-ABSENT])
dnl
dnl Using the information found from PC_PYTHON_CHECK_INCLUDES, check
dnl to make sure that Python.h can be loaded. Note that if you use
dnl this, you don't strictly need to also include
dnl PC_PYTHON_CHECK_INCLUDES.

#PC_PYTHON_CHECK_HEADERS(,[AC_MSG_ERROR(could not find Python headers)])



dnl # PC_PYTHON_CHECK_LIBS ###########################################
dnl
dnl This checks what LIBS flags are necessary to use the Python
dnl libraries (ie -lpython). The results are stored in PYTHON_LIBS

#PC_PYTHON_CHECK_LIBS



dnl # PC_PYTHON_TEST_LIBS([FUNCTION-TO-TEST], [ACTION-IF-PRESENT], [ACTION-IF-ABSENT])
dnl
dnl This checks whether the LIBS flag for libpython discovered with
dnl PC_PYTHON_CHECK_LIBS is loadable and if a given function can be
dnl found in the library. You may use this to test for the presence of
dnl features in the library. 

#PC_PYTHON_TEST_LIBS([PyObject_Print],,
#                     [AC_MSG_ERROR(The Python library could not be loaded)])
## Add PYTHON_LIBS to LIBS
#LIBS="$LIBS $PYTHON_LIBS"



dnl # PC_PYTHON_CHECK_CFLAGS #########################################
dnl
dnl This macro checks what Python thinks are the proper CFLAGS to
dnl use and stores them in PYTHON_CFLAGS. Note that this info is only
dnl available for Python versions which include a python-config tool
dnl (2.5+).

#PC_PYTHON_CHECK_CFLAGS
## Add PYTHON_CFLAGS to CFLAGS
#CFLAGS="$CFLAGS $PYTHON_CFLAGS"



dnl # PC_PYTHON_CHECK_LDFLAGS ########################################
dnl
dnl The same as above but for LDFLAGS

#PC_PYTHON_CHECK_LDFLAGS
## Add PYTHON_LDFLAGS to LDFLAGS
#LDFLAGS="$LDFLAGS $PYTHON_LDFLAGS"



dnl # PC_PYTHON_CHECK_EXTENSION_SUFFIX ###############################
dnl
dnl This checks for what Python expects the suffix of extension
dnl modules to be (i.e. .cpython-32mu.so) and stores it in
dnl PYTHON_EXTENSION SUFFIX. This information is only available for
dnl Python 3+

#PC_PYTHON_CHECK_EXTENSION_SUFFIX



dnl # PC_PYTHON_CHECK_ABI_FLAGS ######################################
dnl
dnl This checks for the ABI flags used by Python (i.e. "mu") and
dnl stores it in PYTHON_ABI_FLAGS. This information is only available
dnl for Python 3+

#PC_PYTHON_CHECK_ABI_FLAGS



dnl # PC_PYTHON_CHECK_PLATFORM #######################################
dnl 
dnl This macro checks what platform Python thinks this is (ie
dnl "linux2") and stores it in PYTHON_PLATFORM

#PC_PYTHON_CHECK_PLATFORM



dnl # PC_PYTHON_CHECK_SITE_DIR #######################################
dnl
dnl This checks where Python packages are installed (usually 
dnl /usr/lib/pythonX.Y/site-packages) and stores it in pythondir.

#PC_PYTHON_CHECK_SITE_DIR



dnl # PC_PYTHON_SITE_PACKAGE_DIR #####################################
dnl
dnl This uses PYTHON_SITE_DIR to construct a directory for this
dnl project (ie $PYTHON_SITE_DIR/project_name) and stores it in
dnl pkgpythondir. This value is used by Automake for installing Python
dnl scripts. By default, this begins with ${pythondir}, unexpanded, to
dnl provide compatibility with GNU Makefile specifications, allowing
dnl the user to change the prefix from the commandline.

PC_PYTHON_SITE_PACKAGE_DIR



dnl # PC_PYTHON_CHECK_EXEC_DIR #######################################
dnl
dnl Same as PC_PYTHON_CHECK_SITE_DIR but for $exec-prefix. Stored in
dnl pyexecdir

#PC_PYTHON_CHECK_EXEC_DIR



dnl # PC_PYTHON_EXEC_PACKAGE_DIR #####################################
dnl
dnl Same as PC_PYTHON_SITE_PACKAGE_DIR but for $exec-prefix. Stored in
dnl pkgpyexecdir

PC_PYTHON_EXEC_PACKAGE_DIR



dnl # PC_PYTHON_CHECK_MODULE([PYTHON-MODULE], [ACTION-IF-PRESENT],
dnl                          [ACTION-IF-ABSENT]) 
dnl
dnl This macro lets you check if a given Python module exists on the
dnl system.

#PC_PYTHON_CHECK_MODULE([foo])



dnl # PC_PYTHON_CHECK_FUNC([PYTHON-MODULE], [FUNCTION], [ARGS], 
dnl                        [ACTION-IF-SUCCESSFUL], [ACTION-IF-FAIL]) 
dnl
dnl This macro lets you test if a given function, possibly contained
dnl in a given module, exists. If any exception is encountered when
dnl calling this function, the check will fail. 
# test if Python library foo can do bar()
#PC_PYTHON_CHECK_FUNC([foo], [bar])



dnl Advanced notes:
dnl m4/python.m4 implements Python as a language in Autoconf. This
dnl means that you can use all the usual AC_LANG_* macros with Python
dnl and it will behave as expected. In particular, this means that you
dnl can run arbitrary Python code. For example:
dnl
dnl AC_LANG_PUSH(Python)[]
dnl AC_RUN_IFELSE([AC_LANG_PROGRAM([dnl
dnl # some code here
dnl import foo
dnl ], [dnl
dnl     # some more code here
dnl     foo.bar()
dnl ])], [ACTION-IF-SUCCESSFUL], [ACTION-IF-FAILED])
dnl AC_LANG_POP(Python)[]
dnl  
dnl As usual, AC_LANG_PROGRAM takes two arguments, PROLOG code and
dnl MAIN code. The PROLOG code goes verbatim at the top of the file,
dnl while the MAIN code is embedded in an if __name__ == "__main__":
dnl block. Python's indentation rules complicate things, however. In
dnl particular, you must be sure that all of the code in MAIN is
dnl indented once by default. PROLOG code does not require this.


# Files to be configured
AC_CONFIG_FILES([Makefile])
# Generate config.status
AC_OUTPUT
