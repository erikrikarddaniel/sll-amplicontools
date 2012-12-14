DIFF = grep -v "^[ ]*$$" $@.out | diff $@.expect -

CHECK = if [ ` $(DIFF) | wc -l ` -eq 0 ]; then echo "*** $@ OK ***"; else echo "*** $@ FAILED ***"; echo "Here's a diff: "; $(DIFF); exit 1; fi

all: amplitools.usearch.makefile

clean:
	rm -f *.out

amplitools.usearch.makefile: amplitools.usearch.makefile.00 amplitools.usearch.makefile.01 amplitools.usearch.makefile.02

amplitools.usearch.makefile.00:
	@make -f $@.makefile -n create_links > $@.out
	@make -f $@.makefile -n $@.uc >> $@.out
	@make -f $@.makefile -n all_otuseeds >> $@.out
	@make -f $@.makefile $@.uc.sbatch && cat $@.uc.sbatch >> $@.out && rm $@.uc.sbatch
	@$(CHECK)

amplitools.usearch.makefile.01:
	@make -f $@.makefile -n $@.otutables > $@.out
	@$(CHECK)

amplitools.usearch.makefile.02:
	@make -f $@.makefile -n all_silvas > $@.out
	@$(CHECK)
