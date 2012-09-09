m4_define(python_min_ver, 2.7.2)
m4_define(python3_min_ver, 3.2.1)
m4_include([m4/python.m4])

AC_INIT(test_project, project_version,
        [test_project-bug@gnu.org])
AC_SUBST(ACLOCAL_AMFLAGS, "-I m4 -I .")
AC_CONFIG_MACRO_DIR([m4])
AM_INIT_AUTOMAKE([-Wall -Werror gnu])

PC_PYTHON_PATH(python_min_ver)

# check if we are building for python 3
PC_PYTHON_CHECK_VERSION([$PYTHON], [3.0],
                         build_py3k=true,
                         build_py3k=false)

# if building for python 3 make sure we have the minimum version supported
if test $build_py3k = true ; then
  AC_MSG_CHECKING([for $PYTHON >=] python3_min_ver)
  PC_PYTHON_CHECK_VERSION([$PYTHON], python3_min_ver,
                          [AC_MSG_RESULT(yes)],
                          [AC_MSG_ERROR(too old)])
fi

# check for python.h
AC_MSG_CHECKING([for python.h])

#AM_CHECK_PYTHON_HEADERS(,[AC_MSG_ERROR(could not find Python headers)])
AC_CHECK_HEADER([python.h], , [AC_MSG_ERROR(could not find Python headers)])

# check if Python library foo exists
PC_PYTHON_CHECK_LIB([foo],
                    [AC_MSG_RESULT(yes)],
                    [AC_MSG_ERROR(missing)])

# test if Python library foo can do bar
AC_MSG_CHECKING([for foo.bar()])
AC_LANG_PUSH(Python)[]dnl
AC_RUN_IFELSE([AC_LANG_PROGRAM([dnl
import foo
],
[dnl
foo.bar()
]), AC_MSG_RESULT(yes), AC_MSG_ERROR(no)])

AC_CONFIG_FILES([])
AC_OUTPUT
