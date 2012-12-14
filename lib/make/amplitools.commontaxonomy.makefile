# Makefile with targets common for all taxon identification schemes

OTUTAXTABLE_HEAD = echo "`grep -i '^\# *otu' $<`	`head -n 1 $(wordlist 2,2,$^)|cut -f 2-`	Type sequence"|sed 's/\# Seqname//'
OTUTAXTABLE_CONTENT = join -t $$'\t' $(wordlist 3,4,$^) | join -t $$'\t' - $(wordlist 5,5,$^)

all_otutaxtables: $(subst .otutable,.otutaxtable,$(wildcard *.otutable))

%.usort: %
	sed 's/#.*//' $< | grep "^[A-Za-z0-9_]" | sort -u > $@

%.seqtable: %.fasta
	fasta2table $< > $@

%.otutaxtable: %.otutable %.otuseeds.taxonomy %.otutable.usort %.otuseeds.taxonomy.usort %.otuseeds.seqtable.usort
	$(OTUTAXTABLE_HEAD) > $@.head
	$(OTUTAXTABLE_CONTENT) > $@.content
	cat $@.head $@.content > $@ && rm $@.head $@.content
