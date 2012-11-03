#Copyright 2012 Brandon Invergo <brandon@invergo.net>
#
#Copying and distribution of this software, with or without modification,
#are permitted in any medium without royalty provided the copyright
#notice and this notice are preserved.  This file is offered as-is,
#without any warranty.

prefix = /usr
bindir = ${prefix}/bin
MAKEINFO = ${bindir}/makeinfo
TEXI2HTML = $(MAKEINFO) --html --no-split
TEXI2PDF = ${bindir}/texi2pdf

all: info html pdf

.PHONY: all info html pdf

info: python-configure.info

html: python-configure.html

pdf: python-configure.pdf

python-configure.info: python-configure.texi
	$(MAKEINFO) $<

python-configure.html: python-configure.texi
	$(TEXI2HTML) $<

python-configure.pdf: python-configure.texi
	$(TEXI2PDF) $<
