CLUSTER_LEVELS = 1.00 0.99 0.98 0.97 0.96 0.95

# Create links
create_links:
	ln -s ../*.perseus.fasta .

all_otuseeds_fasta: $(subst .uc.fasta,.otuseeds.fasta,$(wildcard *.uc.fasta))

# Uclust clustering
%.sort.fasta: %.fasta
	amplifastasort $< > $@

%.uc: %.sort.fasta
	for n in $(CLUSTER_LEVELS); do \
	  n=$(basename $@).`echo "$$n * 100" | bc -l |sed 's/\..*//'`.uc; \
	  usearch --usersort --cluster_smallmem $< -id $$n --uc $$name --centroids $$n.fasta; \
	done

%.otu.list: $(wildcard *.uc)
	uc2otulist $^ > $@

%.otutables: %.otu.list $(filter-out all.,$(wildcard *.fasta))
	@for level in `cut -d " " -f 1 $<`; do \
	  percent=`echo "(1-$$level) * 100"|bc -l|sed 's/\.00//'`; \
	  outfile=$(basename $@).$$percent.otutable; \
	  echo ">>> Creating $$outfile at the $$level difference level <<<"; \
	  ampliotus --format=freecsv --fields=otu,clusterlevel,counts --stripsuffixes=`echo $(lastword $^)|awk -F. '{print "." $$(NF-1) "." $$NF }'` --difference=$$level --listfile=$^ > $$outfile; \
	done
	@touch $@

%.uc.sbatch: $(M4_DIRECTORY)/single_make_target.sbatch.m4
	@$(SBATCH_M4_SINGLE_MAKE_TARGET_CORE_CALL)

%.otuseeds.fasta: %.uc.fasta
	n=`echo $<|awk -F. '{print $$(NF-2)}'`; \
	awk "BEGIN { i=0 }  /^>/ { printf '>OTU$${n}_%06d\n', i++ } !/^>/ { print $$0 }" $< > $@
