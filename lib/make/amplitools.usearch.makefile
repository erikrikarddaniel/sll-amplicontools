# Uclust clustering
%.sort.fasta: %.fasta
	amplifastasort $< > $@

%.100.uc: %.sort.fasta
	$(USEARCH)

%.99.uc: %.sort.fasta
	$(USEARCH)

%.98.uc: %.sort.fasta
	$(USEARCH)

%.97.uc: %.sort.fasta
	$(USEARCH)

%.96.uc: %.sort.fasta
	$(USEARCH)

%.95.uc: %.sort.fasta
	$(USEARCH)
