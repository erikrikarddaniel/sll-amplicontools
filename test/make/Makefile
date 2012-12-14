DIFF = grep -v "^[ ]*$$" $@.out | diff $@.expect -

CHECK = if [ ` $(DIFF) | wc -l ` -eq 0 ]; then echo "*** $@ OK ***"; else echo "*** $@ FAILED ***"; echo "Here's a diff: "; $(DIFF); exit 1; fi

all: amplitools.usearch.makefile

clean:
	rm -f *.out

amplitools.usearch.makefile: amplitools.usearch.makefile.00 amplitools.usearch.makefile.01 amplitools.usearch.makefile.02

amplitools.usearch.makefile.00:
	@cd $@.d; make -f $@.makefile -n create_links > $@.out
	@cd $@.d; make -f $@.makefile -n $@.uc >> $@.out
	@cd $@.d; make -f $@.makefile -n all_otuseeds >> $@.out
	@cd $@.d; make -f $@.makefile $@.uc.sbatch >> $@.out && cat $@.uc.sbatch >> $@.out && rm $@.uc.sbatch
	@cd $@.d; $(CHECK)

amplitools.usearch.makefile.01:
	@cd $@.d; make -f $@.makefile -n $@.otutables > $@.out
	@cd $@.d; $(CHECK)

amplitools.usearch.makefile.02:
	@cd $@.d; make -f $@.makefile -n all_silvas > $@.out
	@cd $@.d; make -f $@.makefile all_silvas.sbatch >> $@.out && cat all_silvas.sbatch >> $@.out && rm all_silvas.sbatch
	@cd $@.d; $(CHECK)
