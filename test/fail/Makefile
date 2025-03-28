TOP=../..
EXE=$(shell ocamlc -config-var ext_exe)

all:

test::
	rm -f FAILED
	if [ -f FAILED ] ; then false; fi
	ocamlfind fmt/NONEXISTENT || touch FAILED
	if [ ! -f FAILED ] ; then false; fi
	rm -f FAILED
	TOP=$(TOP) ../../src/LAUNCH -- ocamlfind fmt/NONEXISTENT || touch FAILED
	if [ ! -f FAILED ] ; then false; fi
	rm -f FAILED
	TOP=$(TOP) ../../src/LAUNCH -- ocamlfind camlp5-buildscripts/LAUNCH -- touch SUCCESS
	if [ ! -f SUCCESS ] ; then false; fi
	rm -f SUCCESS
	echo "==== ALL PASSED ===="

clean::
