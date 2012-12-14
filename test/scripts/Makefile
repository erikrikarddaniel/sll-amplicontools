DIFF = grep -v "^[ ]*$$" $@.out | diff $@.expect -

CHECK = if [ ` $(DIFF) | wc -l ` -eq 0 ]; then echo "*** $@ OK ***"; else echo "*** $@ FAILED ***"; echo "Here's a diff: "; $(DIFF); exit 1; fi

SIZE_CHECK = if [ ` stat -c "%s" $@.out ` -eq ` stat -c "%s" $@.expect ` ]; then echo "*** $@ OK ***"; else echo "*** $@ FAILED ($@.out and $@.expect different sizes) ***"; exit 1; fi

GREP_CHECK = pattern=`cat $@.expect`; if [ `grep "$$pattern" $@.out | wc -l` -gt 0 ]; then echo "*** $@ OK ***"; else echo "*** $@ FAILED ***"; echo "Didn't find $$pattern in output"; exit 1; fi

XML_CHECK =

all: amplifastasort ampliotus fasta2table

clean: cleanraw cleandatsample
	@rm -rf *.out *.tmp err *.newname.tar* otutable2taxonsplit.*.*.otutable otutablesumbyrank.*.rank* sam2meganannot.*.out*

cleanraw:
	@rm -f sam*.raw

cleandatsample:
	@rm -f pyronoisedatrepl*repl*.dat

amplifastasort: amplifastasort.00 amplifastasort.01

ampliotus: ampliotus.00 ampliotus.01 ampliotus.02 ampliotus.03 ampliotus.04 ampliotus.05 ampliotus.06 ampliotus.07 ampliotus.08 ampliotus.09 ampliotus.10 ampliotus.11 ampliotus.12

fasta2table: fasta2table.00

amplifastasort.00:
	@../../scripts/amplifastasort $@.fasta > $@.out
	@$(CHECK)

amplifastasort.01:
	@../../scripts/amplifastasort --forward $@.fasta > $@.out
	@$(CHECK)

ampliotus.00:
	@../../scripts/ampliotus --difference=0.03 --listfile=$@.list $@.?.fasta > $@.out
	@$(CHECK)

ampliotus.01:
	@../../scripts/ampliotus --difference=0.03 --listfile=$@.list $@.?.fasta > $@.out
	@$(CHECK)

# Fasta output.
ampliotus.02:
	@../../scripts/ampliotus --format=fasta --difference=0.03 --listfile=$@.list $@.?.fasta > $@.out
	@$(CHECK)

ampliotus.03:
	@../../scripts/ampliotus --format=fasta --difference=0.03 --listfile=$@.list $@.?.fasta > $@.out
	@$(CHECK)

ampliotus.04:
	@../../scripts/ampliotus --format=taxcsv --difference=0.08 --listfile=$@.otu.list --taxfile=$@.seqtaxonomy $@.?.fna > $@.out
	@$(CHECK)

ampliotus.05:
	@../../scripts/ampliotus --format=taxcsv --difference=0.08 --listfile=$@.otu.list --taxfile=$@.seqtaxonomy $@.?.fna > $@.out
	@$(CHECK)

ampliotus.06:
	@../../scripts/ampliotus --fields > $@.out
	@$(CHECK)

ampliotus.07:
	@../../scripts/ampliotus --format=freecsv --fields=otu,seqname,best_hit_subject,best_hit_taxonomy,best_hit_identity,best_hit_alnlen,counts,sequence --difference=0.08 --listfile=$@.otu.list --taxfile=$@.seqtaxonomy $@.?.fna > $@.out
	@$(CHECK)

ampliotus.08:
	@../../scripts/ampliotus --format=freecsv --fields=otu,best_hit_taxonomy,counts --difference=0.08 --listfile=$@.otu.list --taxfile=$@.seqtaxonomy $@.?.fna > $@.out
	@$(CHECK)

ampliotus.09:
	@../../scripts/ampliotus --format=freecsv --fields=otu,best_hit_taxonomy,counts --difference=0.08 --listfile=$@.otu.list --taxfile=$@.seqtaxonomy $@.*.fasta > $@.out
	@$(CHECK)

ampliotus.10:
	@../../scripts/ampliotus --format=freecsv --fields=otu,clusterlevel,counts --difference=0.03 --listfile=$@.list $@.?.fasta > $@.out
	@$(CHECK)

ampliotus.11:
	@../../scripts/ampliotus --format=amplisql --method_name=FCluster --stripsuffixes=\.fasta --difference=0.03 --listfile=$@.list $@.?.fasta > $@.out
	@$(CHECK)

ampliotus.12:
	@../../scripts/ampliotus --format=freecsv --fields=otu,clusterlevel,counts --percent-id=97 --listfile=$@.list $@.?.fasta > $@.out
	@$(CHECK)

fasta2table.00:
	@../../scripts/fasta2table $@.fasta > $@.out
	@$(CHECK)
