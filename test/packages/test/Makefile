TOP=../../..

include $(TOP)/test/packages/Makefile.config

all: justfoo foobar andbuzz foobarbuzz
	cp foobar $(TOP)/local-install/bin/foobar$(EXE)
	cp foobar $(TOP)/local-install/bin/foobar$(EXE)
	cp foobar $(TOP)/local-install/bin/foobar.opt$(EXE)

test:

foobar:
	$(OCAMLFIND) ocamlc -verbose -package fmt,bar -linkall -linkpkg foobar.ml -o foobar$(EXE)

andbuzz:
	$(OCAMLFIND) ocamlc -verbose -package bar -linkall -linkpkg buzz.cmo andbuzz.ml -o andbuzz

foobarbuzz:
	$(OCAMLFIND) ocamlc -verbose -package fmt,bar -linkall -linkpkg foobar.ml -o foobar buzz.cmo

justfoo:
	$(OCAMLFIND) ocamlc -verbose -package foo -linkall -linkpkg justfoo.ml -o justfoo

clean::
	rm -f *.cm* foobar justfoo andbuzz
