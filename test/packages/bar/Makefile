TOP=../../..

include $(TOP)/test/packages/Makefile.config

all: install

test:

install: bar.cmo bar.cmi bar.cmx bar.o buzz.cmo buzz.cmi buzz.cmx buzz.o
	$(OCAMLFIND) install -destdir $(TOP)/local-install/lib bar META $^ || true

uninstall::
	$(OCAMLFIND) remove -destdir $(TOP)/local-install/lib bar || true

bar.cmi bar.cmo bar.cmx bar.o:
	$(OCAMLFIND) ocamlc -package foo -c bar.ml
	$(OCAMLFIND) ocamlopt -package foo -c bar.ml

buzz.cmi buzz.cmo buzz.cmx buzz.o:
	$(OCAMLFIND) ocamlc -package foo -c buzz.ml
	$(OCAMLFIND) ocamlopt -package foo -c buzz.ml

clean:: uninstall
	rm -f *.cm*
