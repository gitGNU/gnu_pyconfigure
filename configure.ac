AC_INIT(pyconfigure, 0.2.3, bug-pyconfigure@gnu.org)
AM_INIT_AUTOMAKE

AC_PROG_INSTALL
AC_PATH_PROG([MAKEINFO], [makeinfo], 
	     [AC_MSG_WARN([makeinfo needed to build documentation])])
AC_PATH_PROG([TEXI2PDF], [texi2pdf],
	     [AC_MSG_WARN([texi2pdf needed to build documentation])])

AC_CONFIG_FILES([Makefile])
AC_OUTPUT
