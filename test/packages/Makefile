
TESTDIRS=foo bar test

all:
	set -e; for i in $(TESTDIRS); do cd $$i; $(MAKE) all; cd ..; done

test::
	set -e; for i in $(TESTDIRS); do cd $$i; $(MAKE) test; cd ..; done

clean::
	set -e; for i in $(TESTDIRS); do cd $$i; $(MAKE) clean; cd ..; done
