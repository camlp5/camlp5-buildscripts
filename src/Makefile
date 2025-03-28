ifeq ($(OS),Windows_NT)
WD=$(shell cygpath --absolute --windows .)
EXE=.exe
else
WD=$(shell pwd)
EXE=
endif
TOP=..

NOT_OCAMLFIND=not-ocamlfind
OCAMLFIND=ocamlfind
PACKAGES=re,fmt,unix,bos

BIN=ya-wrap-ocamlfind$(EXE) fixin$(EXE) join_meta$(EXE) LAUNCH$(EXE)
ifeq ($(OS),Windows_NT)
PL=LAUNCH.PL
endif
all: $(BIN)
	$(MAKE) DESTDIR=$(WD)/$(TOP)/local-install/ install

ya-wrap-ocamlfind$(EXE): ya_wrap_ocamlfind.ml
	$(OCAMLFIND) ocamlc -linkpkg -linkall -package $(PACKAGES) $< -o $@

join_meta$(EXE): join_meta.ml
	$(OCAMLFIND) ocamlc -linkpkg -linkall -package $(PACKAGES) $< -o $@

fixin$(EXE): fixin.ml
	$(OCAMLFIND) ocamlc -linkpkg -linkall -package $(PACKAGES) $< -o $@

LAUNCH$(EXE): LAUNCH.ml
	$(OCAMLFIND) ocamlc -linkpkg -linkall -package $(PACKAGES) $< -o $@

install::
	mkdir -p $(DESTDIR)/lib
	touch META
	$(NOT_OCAMLFIND) reinstall-if-diff camlp5-buildscripts -destdir $(DESTDIR)/lib META $(BIN) $(PL)
	rm -f META

clean::
	rm -f *.bak *.cm* $(BIN) META
