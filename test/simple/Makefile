
export EXE=$(shell ocamlc -config-var ext_exe)
TESTS=LAUNCH join_meta ya-wrap-ocamlfind

all:

test: $(TESTS)
	./LAUNCH.sh
	./LAUNCH.sh > LAUNCH.sh.output 2>&1
ifneq ($(OS),Windows_NT)
	diff -Bwiu t/LAUNCH/LAUNCH.sh.expected LAUNCH.sh.output
else
	./LAUNCH_win.sh
endif

%: %.md
	rm -f $<.corrected
	ocaml-mdx test --force-output $<
ifneq ($(OS),Windows_NT)
	test '!' -f $<.corrected || diff -I '```' -Bwiu $< $<.corrected
endif

clean::
	rm -f *.corrected *.output
