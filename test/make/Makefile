DIFF = grep -v "^[ ]*$$" $@.out | diff $@.expect -

CHECK = if [ ` $(DIFF) | wc -l ` -eq 0 ]; then echo "*** $@ OK ***"; else echo "*** $@ FAILED ***"; echo "Here's a diff: "; $(DIFF); exit 1; fi

all: amplitools.usearch.makefile

amplitools.usearch.makefile: amplitools.usearch.makefile.00

amplitools.usearch.makefile.00:
	make -f ../../lib/make/$@ -n $@.uc > $@.out
	$(CHECK)
