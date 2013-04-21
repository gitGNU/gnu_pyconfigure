# Makefile.in
#
# Copyright © 2012, 2013 Brandon Invergo <brandon@invergo.net>
#
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# List all of the Python packages that will be installed.
# These will be installed to their own package directories. So, if you 
# install a package "foo", it will typically be installed somewhere 
# like /usr/lib/python2.7/site-packages/foo. All Python files (.py, 
# .pyc) from these projects will be installed.
PYPACKAGES = foo bar

# The source for the packages listed in PYPACKAGES should be in
# directories of the same name. If those directories are not contained
# in the root directory of your source package, add their root
# directory here. For example, if package "foo" is under the "src"
# directory in your source, Set PYPACKAGE_ROOT to "src". Leave this
# variable empty if "foo" is in the same directory as this Makefile.
PYPACKAGE_ROOT ?= .

# List any files that should be installed as executable scripts
# here. Write their path relative to this Makefile. If binary "baz" is
# in the same directory as this Makefile, just write "baz". If it is
# under the "bin" sub-directory of your source package, write
# "bin/baz".
SCRIPTS =

# List package data files to be installed here. These files will be
# installed with their respective packages listed in PYPACKAGES. List
# them relative to their parent package (i.e. foo/bar.dat). 
PKG_DATA =

# Other data files that are to be installed to pkgdatadir
# ($prefix/share/$pkg, i.e. /usr/local/share/foo) can be listed here,
# relative to the location of this Makefile. Directory structure will
# be maintained, such that bar/baz.txt will be installed to
# $prefix/share/foo/bar/baz.txt. 
DATA = 

# If all data files (re: DATA) are stored under a particular
# sub-directory, name it here. That directory name will be removed
# during the installation of data files. For example, if
# DATA=bar/baz.txt and the "bar" sub-directory is located in the
# directory "data" (so baz.txt is located at data/bar/baz.txt), and
# DATA_ROOT=data, baz.txt will be installed to
# $prefix/share/foo/bar/baz.txt
DATA_ROOT =

# List whatever files you want to include in your source distribution
# here.  You can include whole directories but note that *everything*
# under that directory will be included
DISTFILES = PKG-INFO Makefile.in configure setup.py install-sh

DESTDIR = 
VPATH = @srcdir@
PACKAGE_BUGREPORT = @PACKAGE_BUGREPORT@
PACKAGE_NAME = @PACKAGE_NAME@
PACKAGE_STRING = @PACKAGE_STRING@
PACKAGE_TARNAME = @PACKAGE_TARNAME@
PACKAGE_DISTNAME = ${PACKAGE_NAME}-${PACKAGE_VERSION}
PACKAGE_URL = @PACKAGE_URL@
PACKAGE_VERSION = @PACKAGE_VERSION@
PATH_SEPARATOR = @PATH_SEPARATOR@
PYTHON = @PYTHON@
VIRTUALENV = @VIRTUALENV@
SPHINXBUILD = @SPHINXBUILD@
SHELL = @SHELL@
MKDIR_P = @MKDIR_P@
INSTALL = @INSTALL@
INSTALL_PROGRAM = @INSTALL_PROGRAM@
INSTALL_DATA = @INSTALL_DATA@
INSTALL_SCRIPT = @INSTALL_SCRIPT@
bindir = @bindir@
docdir = @docdir@
dvidir = @dvidir@
exec_prefix = @exec_prefix@
htmldir = @htmldir@
includedir = @includedir@
infodir = @infodir@
prefix = @prefix@
srcdir = @srcdir@
datadir = @datadir@
datarootdir = @datarootdir@
pythondir = @pythondir@
pyexecdir = @pyexecdir@
pkgdatadir = $(datadir)/@PACKAGE_NAME@
pkgincludedir = $(includedir)/@PACKAGE_NAME@
pkgpythondir = @pkgpythondir@
pkgpyexecdir = @pkgpyexecdir@
PYTHONPATH = $(pythondir)$(PATH_SEPARATOR)$(DESTDIR)$(pythondir)

empty:=
space:= $(empty) $(empty)
comma:= ,


all: build 


.PHONY: all build byte-compile install install-virtualenv				\
install-pypkgs install-scripts install-pkgdata install-data uninstall	\
distclean info install-html html install-pdf pdf install-dvi dvi		\
install-ps ps clean dist check installdirs


build: byte-compile


byte-compile:
	$(PYTHON) -m compileall $(PYPACKAGE_ROOT)/$(PYPACKAGES)


ifneq ($(VIRTUALENV),no)
install: install-dirs install-virtualenv install-pypkgs install-scripts \
	install-pkgdata install-data
else
install: install-dirs install-pypkgs install-scripts install-pkgdata \
	install-data
endif


# Create a virtualenv
install-virtualenv:
	$(VIRTUALENV) $(VIRTUALENV_FLAGS) $(DESTDIR)$(prefix)


# Dynamically create Make prerequisites from the list of
# PYPACKAGES. So, if PYPACKAGES=foo, this will dynamically create a
# prerequisite "install-pkg-foo". This technique is used in the next
# several rules.
install-pypkgs: $(addprefix install-pkg-,$(PYPACKAGES))


# The rule for each dynamically generated PYPACKAGES prereq. Find all
# the Python files (.py or pyc) in the package's directory and install
# them to the pythondir (i.e. $prefix/lib/python3.3/site-packages/foo).
install-pkg-%:
	for f in $(shell find $(srcdir)/$(PYPACKAGE_ROOT)/$* -name "*.py" -or -name "*.pyc"); do \
		$(INSTALL_DATA) $$f $(DESTDIR)$(pythondir)/$${f#$(srcdir)/$(PYPACKAGE_ROOT)/}; \
	done


# Install all the scripts to $(prefix)/bin
install-scripts: 
	for script in $(SCRIPTS); do \
		$(INSTALL_PROGRAM) $(srcdir)/$$script $(DESTDIR)$(bindir)/`basename $$script`; \
	done


# Install Python module data to the respecitve Python module directories
install-pkgdata: 
	for f in $(addprefix $(srcdir)/$(PYPACKAGE_ROOT)/,$(PKG_DATA)); do \
		$(INSTALL_DATA) $$f $(DESTDIR)$(pythondir)/$${f#$(srcdir)/$(PYPACKAGE_ROOT)/}; \
	done


# Install other data to $(prefix)/share/package_name
install-data:
	for f in $(DATA); do \
		$(INSTALL_DATA) $(srcdir)/$$f $(DESTDIR)$(pkgdatadir)/$$f; \
	done


# Create all the required directories
install-dirs:
	$(MKDIR_P) $(DESTDIR)$(pythondir)/{$(subst $(space),$(comma),$(PYPACKAGES))}
	if [ "$(DATA)" != "" ]; then \
		$(MKDIR_P) $(DESTDIR)$(pkgdatadir); \
	fi
	if [ "$(SCRIPTS)" != "" ]; then \
		$(MKDIR_P) $(DESTDIR)$(bindir); \
	fi


# Remove installed files
uninstall: 
	rm -rvf $(addprefix $(pythondir)/,$(PYPACKAGES))
	rm -rvf $(addprefix $(bindir)/,$(SCRIPTS))
	rm -rvf $(pkgdatadir)


# Clean up anything that is generated during the installation process
clean:


# Clean up the output of configure
distclean: 
	rm -v $(srcdir)/config.log
	rm -v $(srcdir)/config.status
	rm -rvf $(srcdir)/autom4te.cache
	rm -v $(srcdir)/Makefile
	rm -v $(srcdir)/setup.py


# Generate a distribution archive (tar.gz by default)
dist:
	mkdir $(PACKAGE_DISTNAME)
	cp -r $(DISTFILES) $(PACKAGE_DISTNAME)
	tar -czf $(PACKAGE_DISTNAME).tar.gz $(PACKAGE_DISTNAME)
	rm -rf $(PACKAGE_DISTNAME)


# If you have unit tests or any other such checks, you can run them in
# the "check" target
check:


# The following show how to install documentation. In this example,
# docs are built from a separate Makefile contained in the docs
# directory which uses the SPHINXBUILD variable to store the location
# of the sphinx-build (Python doc tool) binary to use.

# $(DESTDIR)$(infodir)/foo.info: docs/build/texinfo/foo.info
# 	$(POST_INSTALL)
# 	$(INSTALL_DATA) @< $(DESTDIR)$@
# 	if $(SHELL) -c 'install-info --version' >/dev/null 2>&1; then
# 		install-info --dir-file=$(DESTDIR)$(infodir)/dir \
# 				$(DESTDIR)$(infodir)/foo.info;
# 	else true; fi
#
# info: docs/build/texinfo/foo.info
#
# docs/build/texinfo/foo.info: $(wildcard docs/source/*)
# ifneq ($(SPHINXBUILD),no)
# 	$(MAKE) -C docs info SPHINXBUILD=$(SPHINXBUILD)
# endif
#
#
# install-html: html installdirs
# 	$(INSTALL_DATA) docs/build/html/* $(DESTDIR)$(htmldir)
#
# html: docs/build/html/index.html
#
# docs/build/html/index.html: $(wildcard $(srcdir)/docs/source/*)
# ifneq ($(SPHINXBUILD),no)
# 	$(MAKE) -C docs html SPHINXBUILD=$(SPHINXBUILD)
# endif
#
#
# install-pdf: pdf installdirs
# 	$(INSTALL_DATA) docs/build/latex/foo.pdf $(DESTDIR)$(pdfdir)
#
# pdf: docs/build/latex/Foo.pdf
#
# docs/build/latex/foo.pdf: $(wildcard $(srcdir)/docs/source/*)
# ifneq ($(SPHINXBUILD),no)
# 	$(MAKE) -C docs latexpdf SPHINXBUILD=$(SPHINXBUILD)
# endif
#
#
# install-dvi:
#
# dvi:
#
# install-ps:
#
# ps:


