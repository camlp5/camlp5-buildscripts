ifeq ($(OS),Windows_NT)
WD=$(shell cygpath --absolute --windows .)
else
WD=$(shell pwd)
endif
TOP=..

NOT_OCAMLFIND=not-ocamlfind
OCAMLFIND=ocamlfind
PACKAGES=re,fmt,unix,bos

EXEC_SUFFIX := $(shell ocamlc -config-var ext_exe)

EXE=ya-wrap-ocamlfind$(EXEC_SUFFIX) fixin$(EXEC_SUFFIX) join_meta$(EXEC_SUFFIX) LAUNCH$(EXEC_SUFFIX)

all: $(EXE)
	$(MAKE) DESTDIR=$(WD)/$(TOP)/local-install/ install

ya-wrap-ocamlfind$(EXEC_SUFFIX): ya_wrap_ocamlfind.ml
	$(OCAMLFIND) ocamlc -linkpkg -linkall -package $(PACKAGES) $< -o $@

join_meta$(EXEC_SUFFIX): join_meta.ml
	$(OCAMLFIND) ocamlc -linkpkg -linkall -package $(PACKAGES) $< -o $@

fixin$(EXEC_SUFFIX): fixin.ml
	$(OCAMLFIND) ocamlc -linkpkg -linkall -package $(PACKAGES) $< -o $@

LAUNCH$(EXEC_SUFFIX): LAUNCH.ml
	$(OCAMLFIND) ocamlc -linkpkg -linkall -package $(PACKAGES) $< -o $@

install::
	mkdir -p $(DESTDIR)/lib
	touch META
	$(NOT_OCAMLFIND) reinstall-if-diff camlp5-buildscripts -destdir $(DESTDIR)/lib META $(EXE)
	rm -f META

clean::
	rm -f *.bak *.cm* $(EXE) META
