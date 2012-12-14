SILVA_DIR = /proj/b2010008/nobackup/data/silva
SILVA_SSU_REF = $(SILVA_DIR)/SSURef.arb

all_silvas: $(subst .fasta,.silva_ssuref.arb,$(wildcard *.otuseeds.fasta))

all_silvas.sbatch: $(M4_DIRECTORY)/single_make_target.sbatch.m4
	@$(SBATCH_M4_SINGLE_MAKE_TARGET_CORE_CALL)

%.silva_ssuref.arb: %.fasta $(SILVA_SSU_REF)
	sina -i $< \
	  -o $@ \
	  --ptdb $(wordlist 2,2,$^) \
	  --search \
	  --search-db $(wordlist 2,2,$^) \
	  --lca-fields tax_slv \
	  --log-file $(basename $@).sinalog
	killall arb_pt_server
