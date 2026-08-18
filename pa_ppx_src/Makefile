
NOT_OCAMLFIND=not-ocamlfind

bootstrap: ../src/join_meta.ml ../src/ya_wrap_ocamlfind.ml ../src/fixin.ml ../src/LAUNCH.ml


../src/%.ml: %.ml
	$(NOT_OCAMLFIND) preprocess -package pa_ppx_regexp,camlp5.pr_o -syntax camlp5o $< > $@.NEW && \
	mv $@.NEW $@

.SUFFIXES: .ml
