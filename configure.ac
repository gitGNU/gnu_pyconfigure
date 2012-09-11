m4_define(python_min_ver, 2.7.2)
m4_define(python3_min_ver, 3.2.1)
m4_include([m4/python.m4])

AC_INIT(test_project, project_version,
        [test_project-bug@gnu.org])
AC_SUBST(ACLOCAL_AMFLAGS, "-I m4 -I .")
AC_CONFIG_MACRO_DIR([m4])
AM_INIT_AUTOMAKE([-Wall -Werror gnu])

AC_PROG_PYTHON()

# check if we are building for Python 3
PC_PYTHON_VERIFY_VERSION([$PYTHON], 3.0,
                          build_py3k=true,
                          build_py3k=false)

# if building for python 3 make sure we have the minimum version supported
if test "$build_py3k" = "true" ; then
   PC_PYTHON_VERIFY_VERSION([$PYTHON], python3_min_ver,,
                            [AC_MSG_ERROR(Python 3 interpreter too old)])
else
# otherwise check that the Python 2 version is sufficient
   PC_PYTHON_VERIFY_VERSION([$PYTHON], python_min_ver, ,
                            [AC_MSG_ERROR(Python interpreter too old)])
fi


PC_PYTHON_CHECK_PREFIX

PC_PYTHON_CHECK_EXECPREFIX

PC_PYTHON_CHECK_INCLUDES

PC_PYTHON_CHECK_HEADERS(,[AC_MSG_ERROR(could not find Python headers)])

PC_PYTHON_CHECK_LIBS

PC_PYTHON_CHECK_CFLAGS

PC_PYTHON_CHECK_LDFLAGS

PC_PYTHON_CHECK_EXTENSION_SUFFIX

PC_PYTHON_CHECK_ABI_FLAGS

PC_PYTHON_CHECK_PLATFORM

PC_PYTHON_CHECK_SITE_DIR

PC_PYTHON_SITE_PACKAGE_DIR

PC_PYTHON_CHECK_EXEC_DIR

PC_PYTHON_EXEC_PACKAGE_DIR


# check if Python library foo exists
PC_PYTHON_CHECK_LIB([dbus])
PC_PYTHON_CHECK_LIB([foo])

# test if Python library foo can do bar()
PC_PYTHON_CHECK_FUNC([dbus], [get_default_main_loop])
PC_PYTHON_CHECK_FUNC([dbus], [bar])

AC_CONFIG_FILES([])
AC_OUTPUT
