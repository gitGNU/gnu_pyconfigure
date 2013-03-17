dnl configure.ac
dnl
dnl Copyright 2012, 2013 Brandon Invergo <brandon@invergo.net>
dnl
dnl Copying and distribution of this file, with or without modification,
dnl are permitted in any medium without royalty provided the copyright
dnl notice and this notice are preserved.  This file is offered as-is,
dnl without any warranty.

dnl#########
dnl README #
dnl#########
dnl
dnl This is a basic Autoconf configure.ac file for Python-based
dnl projects. It is not intended to be used as-is, but rather to be
dnl modified to the specific needs of the project.
dnl
dnl Lines prefixed with "dnl" are comments that are automatically
dnl removed by Autoconf/M4, thus they will not appear in the generated
dnl configure script (see the M4 documentation for more information). 
dnl Such comments are used in this file to communicate information to 
dnl you, the developer. In some cases, the comments contain extra 
dnl macros that you might consider including in your configure script. 
dnl If you wish to include them, simply remove the "dnl" from the 
dnl beginning of the line.
dnl
dnl Lines prefixed with "#" are comments that will appear in the 
dnl generated configure script. These comments are thus used to clarify
dnl to the user what is happening in that script
dnl
dnl Wherever pyconfigure-specific macros are used, extra comments are
dnl included to describe the macros.

dnl############
dnl M4 macros #
dnl############
dnl
dnl In general, large M4 macros should be defined in files in the "m4" 
dnl directory but here you can define some short ones that you will use 
dnl in this file.

dnl----
dnl Set the minimum-required Python version(s).
dnl You can use these macros later in this file to do
dnl version checking
dnl----
dnl
dnl m4_define([python_min_ver], [2.7.2])
dnl m4_define([python3_min_ver], [3.2.1])


dnl######################
dnl Package Information #
dnl######################

dnl----
dnl Initialize Autoconf with the package metadata
dnl The arguments have been set via the project's PKG-INFO file
dnl and correspond to:
dnl
dnl 1) package name (i.e. foo)
dnl 2) package version (i.e. 1.2)
dnl 3) bug/info/project email address (i.e. bug-foo@gnu.org)
dnl----
dnl
AC_INIT([{Name}], [{Version}], [{Author-email}])


dnl----
dnl If you plan to use Automake, initialize it hre
dnl Set some Automake flags
dnl----
dnl
dnl AC_SUBST(ACLOCAL_AMFLAGS, "-I m4 -I .")
dnl AM_INIT_AUTOMAKE()


dnl----
dnl Load macros from the m4/ directory. If you plan to write new 
dnl macros, put them in files in this directory.
dnl----
dnl
AC_CONFIG_MACRO_DIR([m4])


dnl###########################
dnl Program/command support  #
dnl###########################
dnl
dnl In this section, we check for the presence of important commands
dnl and programs.

dnl--AC_PROG_PYTHON---------------------------------------------------
dnl This line is the bare minimum that needs to be included. It 
dnl locates the Python interpreter binary. You may optionally pass it
dnl an argument to pass a path to a binary. By default, this will
dnl first check for a binary called "python" and then from there it
dnl will check for version-specific binaries (ie "python3",
dnl "python2.7") in decending version order. Thus, the highest version
dnl binary will be found first. Note that if you call any of the
dnl following macros, you probably won't have to include this one at
dnl all, since most of the macros depend on this one.
dnl----
dnl
AC_PROG_PYTHON


dnl--PC_PYTHON_PROG_PYTHON_CONFIG-------------------------------------
dnl In order to use some of the other macros, you also need the 
dnl python-config command, which will fall subject to the same problem 
dnl of python3-config being preferred to python2-config. This macro
dnl will be automatically included if you use on of the macros that 
dnl depends on it, so you normally don't have to call it. However, if
dnl you require a specific version, you can do something like the
dnl following example.
dnl----
dnl
dnl PC_PYTHON_PROG_PYTHON_CONFIG([python2-config])
dnl if [[ "x$PYTHON_CONFIG" == "x" ]]; then
dnl   PC_PYTHON_PROG_PYTHON_CONFIG([$PYTHON-config])
dnl fi   


dnl----
dnl With the following set of macros, we implement an option 
dnl "--with-virtualenv", which the user can pass to the configure 
dnl script in order to install to a Virtualenv (AC_ARG_WITH). If the 
dnl option is specified by the user, then we check if the program is
dnl available, checking both for "virtualenv" and "virtualenv2" 
dnl (AC_CHECK_PROGS)
dnl----
dnl
# Support installing to a virtualenv via the --with-virtualenv 
# configure flag
AC_ARG_WITH([virtualenv],
	[AS_HELP_STRING([--with-virtualenv], [install to a Python virtualenv])],
	[],
	[with_virtualenv=no])
AS_IF([test "x$with_virtualenv" != xno],
	    AC_CHECK_PROGS([VIRTUALENV], [virtualenv virtualenv3 virtualenv2], [no])
	    AS_IF([test "x$VIRTUALENV" = xno],
	    [AC_MSG_FAILURE(
		[--with-virtualenv given but virtualenv could not be found])]),
	AC_SUBST([VIRTUALENV], [no]))
AC_ARG_VAR([VIRTUALENV_FLAGS], [flags to pass to the virtualenv command])


dnl----
dnl If the program uses sphinx-build to build documentation, uncomment 
dnl this to create a SPHINXBUILD variable in the Makefile pointing to 
dnl the program. Thus, the user would specify 
dnl SPHINXBUILD=/path/to/sphinx-build as an argument to the configure
dnl script. Since building the documentation should be optional, just
dnl print a warning.
dnl----
dnl
dnl# Check for sphinx-build
dnl AC_CHECK_PROGS([SPHINXBUILD], [sphinx-build sphinx-build3 sphinx-build2], [no])
dnl AS_IF([test "x$SPHINXBUILD" = xno], 
dnl	    AC_MSG_WARN(sphinx-build is required to build documentation))


dnl----
dnl These two are standard Autoconf macros which check for the 
dnl presence of some standard programs that we will use in the 
dnl Makefile.
dnl----
dnl
AC_PROG_MKDIR_P
AC_PROG_INSTALL	    


dnl#################################
dnl Python installation properties #
dnl#################################
dnl
dnl In this section, we test for various aspects of the Python 
dnl installation on the user's computer. 

dnl--PC_PYTHON_VERIFY_VERSION------------------------------------------
dnl This macro is used to check if the version of the discovered
dnl Python binary meets some minimum requirement. You may optionally
dnl provide actions to take if it does or if it doesn't meet the
dnl requirement.
dnl
dnl If your package only supports Python 2 you'll have to do some extra tests
dnl since by default AC_PROG_PYTHON will find the highest-version python binary,
dnl which may be Python 3.x
dnl----
dnl
dnl # First, look for a binary called "python2". If it can't be found, try just 
dnl # searching for "python", but exit with an error if that binary is Python 3+
dnl AC_PROG_PYTHON([python2])
dnl if [[ "x$PYTHON" == "x" ]]; then
dnl   AC_PROG_PYTHON
dnl   PC_PYTHON_VERIFY_VERSION(3.0, ,
dnl	AC_MSG_ERROR(Python 2 (python_min_ver+) is required))
dnl fi
dnl # Ok, we hopefully have a Python 2 interpreter if we made it this far, now 
dnl # check if it is of the minimum version, otherwise exit with an error
dnl PC_PYTHON_VERIFY_VERSION(python_min_ver, ,
dnl	AC_MSG_ERROR(Python 2 (python_min_ver+) is required))


dnl--PC_PYTHON_CHECK_PREFIX--------------------------------------------
dnl This macro finds out what Python thinks is the PREFIX
dnl (i.e. /usr) and stores it in PYTHON_PREFIX. You probably shouldn't
dnl use this and you should just stick to $prefix, but here it is
dnl anyway.
dnl----
dnl
dnl PC_PYTHON_CHECK_PREFIX


dnl--PC_PYTHON_CHECK_EXEC_PREFIX---------------------------------------
dnl The same as above but for $exec-prefix
dnl----
dnl
dnl PC_PYTHON_CHECK_EXEC_PREFIX


dnl--PC_PYTHON_CHECK_PLATFORM------------------------------------------
dnl This macro checks what platform Python thinks this is (ie
dnl "linux2") and stores it in PYTHON_PLATFORM
dnl----
dnl
dnl PC_PYTHON_CHECK_PLATFORM


dnl--PC_PYTHON_CHECK_SITE_DIR------------------------------------------
dnl This checks where Python packages are installed (usually 
dnl /usr/lib/pythonX.Y/site-packages) and stores it in the variable
dnl pythondir.
dnl----
dnl
dnl PC_PYTHON_CHECK_SITE_DIR


dnl--PC_PYTHON_SITE_PACKAGE_DIR---------------------------------------
dnl This uses PYTHON_SITE_DIR to construct a directory for this
dnl project (ie $PYTHON_SITE_DIR/project_name) and stores it in
dnl pkgpythondir. This value is used by Automake for installing Python
dnl scripts. By default, this begins with $pythondir, unexpanded, to
dnl provide compatibility with GNU Makefile specifications, allowing
dnl the user to change the prefix from the commandline.
dnl----
dnl
PC_PYTHON_SITE_PACKAGE_DIR


dnl--PC_PYTHON_CHECK_EXEC_DIR------------------------------------------
dnl Same as PC_PYTHON_CHECK_SITE_DIR but for $exec-prefix. Stored in
dnl pyexecdir
dnl----
dnl
dnl PC_PYTHON_CHECK_EXEC_DIR


dnl--PC_PYTHON_EXEC_PACKAGE_DIR----------------------------------------
dnl Same as PC_PYTHON_SITE_PACKAGE_DIR but for $exec-prefix. Stored in
dnl pkgpyexecdir
dnl----
dnl
PC_PYTHON_EXEC_PACKAGE_DIR


dnl###############################
dnl Checking Python capabilities #
dnl###############################

dnl--PC_PYTHON_CHECK_MODULE([PYTHON-MODULE], [ACTION-IF-PRESENT],
dnl                         [ACTION-IF-ABSENT]) 
dnl This macro lets you check if a given Python module exists on the
dnl system.
dnl----
dnl
dnl PC_PYTHON_CHECK_MODULE([foo])


dnl--PC_PYTHON_CHECK_FUNC([PYTHON-MODULE], [FUNCTION], [ARGS], 
dnl                       [ACTION-IF-SUCCESSFUL], [ACTION-IF-FAIL]) 
dnl
dnl This macro lets you test if a given function, possibly contained
dnl in a given module, exists. If any exception is encountered when
dnl calling this function, the check will fail. 
dnl----
dnl
dnl # test if Python library foo can do bar()
dnl PC_PYTHON_CHECK_FUNC([foo], [bar])


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


dnl##################################
dnl Python module build environment #
dnl##################################
dnl
dnl Here we check for necessary information for building Python modules
dnl written in C

dnl--PC_PYTHON_CHECK_INCLUDES------------------------------------------
dnl This macro figures out the include flags necessary for loading the
dnl Python headers (ie -I/usr/lib/python). The results are stored in
dnl PYTHON_INCLUDES
dnl----
dnl
dnl PC_PYTHON_CHECK_INCLUDES


dnl--PC_PYTHON_CHECK_HEADERS([ACTION-IF-PRESENT], [ACTION-IF-ABSENT])--
dnl Using the information found from PC_PYTHON_CHECK_INCLUDES, check
dnl to make sure that Python.h can be loaded. Note that if you use
dnl this, you don't strictly need to also include
dnl PC_PYTHON_CHECK_INCLUDES.
dnl----
dnl
dnl PC_PYTHON_CHECK_HEADERS(,[AC_MSG_ERROR(could not find Python headers)])


dnl--PC_PYTHON_CHECK_LIBS----------------------------------------------
dnl This checks what LIBS flags are necessary to use the Python
dnl libraries (ie -lpython). The results are stored in PYTHON_LIBS
dnl----
dnl
dnl PC_PYTHON_CHECK_LIBS


dnl--PC_PYTHON_TEST_LIBS([FUNCTION-TO-TEST], [ACTION-IF-PRESENT], [ACTION-IF-ABSENT])
dnl This checks whether the LIBS flag for libpython discovered with
dnl PC_PYTHON_CHECK_LIBS is loadable and if a given function can be
dnl found in the library. You may use this to test for the presence of
dnl features in the library. 
dnl----
dnl
dnl PC_PYTHON_TEST_LIBS([PyObject_Print],,
dnl                     [AC_MSG_ERROR(The Python library could not be loaded)])
dnl # Add PYTHON_LIBS to LIBS
dnl LIBS="$LIBS $PYTHON_LIBS"


dnl--PC_PYTHON_CHECK_CFLAGS--------------------------------------------
dnl This macro checks what Python thinks are the proper CFLAGS to
dnl use and stores them in PYTHON_CFLAGS. Note that this info is only
dnl available for Python versions which include a python-config tool
dnl (2.5+).
dnl----
dnl
dnl PC_PYTHON_CHECK_CFLAGS
dnl # Add PYTHON_CFLAGS to CFLAGS
dnl CFLAGS="$CFLAGS $PYTHON_CFLAGS"


dnl--PC_PYTHON_CHECK_LDFLAGS-------------------------------------------
dnl The same as above but for LDFLAGS
dnl----
dnl
dnl PC_PYTHON_CHECK_LDFLAGS
dnl # Add PYTHON_LDFLAGS to LDFLAGS
dnl LDFLAGS="$LDFLAGS $PYTHON_LDFLAGS"


dnl--PC_PYTHON_CHECK_EXTENSION_SUFFIX----------------------------------
dnl This checks for what Python expects the suffix of extension
dnl modules to be (i.e. .cpython-32mu.so) and stores it in
dnl PYTHON_EXTENSION SUFFIX. This information is only available for
dnl Python 3+
dnl----
dnl
dnl PC_PYTHON_CHECK_EXTENSION_SUFFIX


dnl--PC_PYTHON_CHECK_ABI_FLAGS----------------------------------------
dnl This checks for the ABI flags used by Python (i.e. "mu") and
dnl stores it in PYTHON_ABI_FLAGS. This information is only available
dnl for Python 3+
dnl----
dnl
dnl PC_PYTHON_CHECK_ABI_FLAGS


dnl#########
dnl Finish #
dnl#########

dnl Define the files to be configured
AC_CONFIG_FILES([Makefile setup.py])
dnl Generate config.status
AC_OUTPUT
