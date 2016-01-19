bin_SCRIPTS = pyconf
dist_pkgdata_DATA = src/Makefile.in.distutils src/Makefile.in.make \
src/bootstrap.sh src/configure.ac src/install-sh \
src/setup.py.in.distutils src/setup.py.in.make
m4dir = $(pkgdatadir)/m4
dist_m4_DATA = src/m4/python.m4
info_TEXINFOS = doc/pyconfigure.texi
dist_doc_DATA = COPYING COPYING.GPLv3 src/m4/COPYING.EXCEPTION

CLEANFILES = $(bin_SCRIPTS)

EXTRA_DIST = pyconf.in

do_subst = sed -e 's,[@]pkgdatadir[@],$(pkgdatadir),g' \
		-e 's,[@]PACKAGE_VERSION[@], $(PACKAGE_VERSION),g'

pyconf: pyconf.in
	$(do_subst) < $(srcdir)/pyconf.in > pyconf
	chmod +x pyconf
