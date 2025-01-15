AC_PREREQ([2.69])
AC_INIT([devopss], [1.0], [senyshyn.nazar@gmail.com])
AM_INIT_AUTOMAKE([foreign])
AC_PROG_CXX

AC_CHECK_LIB([gtest], [main], [], [AC_MSG_ERROR([Google Test library not found!])])

AC_CONFIG_FILES([Makefile debian/control debian/rules])
AC_OUTPUT

