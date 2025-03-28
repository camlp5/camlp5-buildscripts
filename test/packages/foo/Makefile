TOP=../../..

include $(TOP)/test/packages/Makefile.config

all: install

test:

install: foo.cmo foo.cmi foo.cmx foo.o
	$(OCAMLFIND) install -destdir $(TOP)/local-install/lib foo META $^ || true

uninstall::
	$(OCAMLFIND) remove -destdir $(TOP)/local-install/lib foo || true

foo.cmi foo.cmo foo.cmx foo.o:
	$(OCAMLFIND) ocamlc -c foo.ml
	$(OCAMLFIND) ocamlopt -c foo.ml

clean:: uninstall
	rm -f *.cm*
