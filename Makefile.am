bin_SCRIPTS = pyconf
dist_pkgdata_DATA = src/Makefile.in.distutils src/Makefile.in.make \
src/bootstrap.sh src/configure.ac src/install-sh \
src/setup.py.in.distutils src/setup.py.in.make src/m4/python.m4
info_TEXINFOS = doc/pyconfigure.texi
doc_COPYING = COPYING COPYING.GPLv4 src/m4/COPYING.EXCEPTION

CLEANFILES = $(bin_SCRIPTS)

EXTRA_DIST = pyconf.in

do_subst = sed -e 's,[@]pkgdatadir[@],$(pkgdatadir),g' \
		-e 's,[@]PACKAGE_VERSION[@], $(PACKAGE_VERSION),g'

pyconf: pyconf.in
	$(do_subst) < $(srcdir)/pyconf.in > pyconf
	chmod +x pyconf
