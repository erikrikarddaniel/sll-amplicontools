R_COLOURS = mycolours <- c("forestgreen", "blue", "red", "orange", "greenyellow", "cyan", "navy", "purple", "royalblue", "orangered", "orchid", "yellow", "darksalmon", "deeppink", "darkseagreen", "khaki", "slategray", "yellowgreen")
READ_SF = sf <- read.delim(file="samples.factors.csv", header=T); sf <- sf[with(sf, order(sample)), ]

GPLOTS = suppressPackageStartupMessages(library(gplots))
PDF = pdf("$@")
SVG = svg("$@")
HEATMAP_WITH_LEGEND = heatmap.2(as.matrix(read.delim(file="$<", header=T, row.names=1)), scale="row", trace="none", ColSideColors=mycolours[sf$$main_group], col=rev(heat.colors(75)), margins=c(4,10)); legend("topright", levels(sf$$main_group), fill=mycolours[unique(as.numeric(sf$$main_group))], cex=0.6)

VEGAN_DIVERSITY_PRE = Rscript --vanilla -e 'library(vegan); write.table(diversity(t(read.delim(file="$<",row.names=1)), index="
VEGAN_DIVERSITY_POST = "), file="$@", col.names = FALSE, row.names = TRUE, append = TRUE)'
VEGAN_VEGDIST_PRE = Rscript --vanilla -e 'library(vegan); write.table(as.matrix(vegdist(t(read.delim(file="$<",row.names=1)), method="
VEGAN_VEGDIST_POST = ")), file="$@", col.names = TRUE, row.names = TRUE)'

symlinks:
	ln -fs ../*.otutable ../*.otutaxtable ../samples.factors.csv ../*taxonomy ../*.newick .

# 8. R-based analyses
rmatrices: $(subst table,table.rmatrix,$(wildcard *table))

%.otutable.rmatrix: %.otutable
	otutable2Rmatrix $< > $@

%.otutaxtable.rmatrix: %.otutaxtable
	otutable2Rmatrix $< > $@

# Alpha diversity vectors:
%.ss.shannon.rvector: %.ss.otutable.rmatrix
	echo "sample	value" > $@
	$(VEGAN_DIVERSITY_PRE)shannon$(VEGAN_DIVERSITY_POST)
	sed -i 's/"//g' $@
	sed -i 's/ /\t/' $@

all_shannons: $(subst otutable.rmatrix,shannon.rvector,$(wildcard *.ss.otutable.rmatrix))

%.ss.pielous.rvector: %.ss.otutable.rmatrix
	echo "sample	value" > $@
	Rscript --vanilla -e 'library(vegan); d <- t(read.delim(file="$<", row.names=1)); sh <- diversity(d, index="shannon"); write.table(sh/log(specnumber(d)), file="$@", col.names = FALSE, row.names = TRUE, append = TRUE)'
	sed -i 's/"//g' $@
	sed -i 's/ /\t/' $@

all_pielous: $(subst otutable.rmatrix,pielous.rvector,$(wildcard *.ss.otutable.rmatrix))

%.ss.simpson.rvector: %.ss.otutable.rmatrix
	$(VEGAN_DIVERSITY_PRE)simpson$(VEGAN_DIVERSITY_POST)

all_simpsons: $(subst otutable.rmatrix,simpson.rvector,$(wildcard *.ss.otutable.rmatrix))

%.ss.invsimpson.rvector: %.ss.otutable.rmatrix
	$(VEGAN_DIVERSITY_PRE)invsimpson$(VEGAN_DIVERSITY_POST)

all_invsimpsons: $(subst otutable.rmatrix,invsimpson.rvector,$(wildcard *.ss.otutable.rmatrix))

# Boxplots of rvectors
%.boxplot.svg: samples.factors.csv %.rvector
	rvector2boxplot --format=svg --groupfile=$^ --output=$@

all_boxplots: $(subst .rvector,.boxplot.svg,$(wildcard *.rvector))

# Beta diversity matrices:
%.bray-curtis.rmatrix: %.otutable.rmatrix
	$(VEGAN_VEGDIST_PRE)bray$(VEGAN_VEGDIST_POST)

# EdgeR analyses
%.edgertw: samples.factors.csv %.taxonomy %.otutable.rmatrix
	otutable2edgertagwisetable --verbose --groupfile=$< --taxonomyfile=$(wordlist 2,3,$^) > $@

all_edgertw: $(subst .otutable.rmatrix,.edgertw,$(filter-out %.ss.otutable.rmatrix,$(wildcard *.otutable.rmatrix)))

# Split otutable on taxonomy
%.phylumsplit: %.taxonomy %.otutable
	otutable2taxonsplit --verbose --fieldnum=3 --hierlevel=2 --basename=$@ --suffix=otutable --taxonomyfile=$^ && touch $@

%.ss.phylumsplit: %.taxonomy %.ss.otutable
	otutable2taxonsplit --verbose --fieldnum=3 --hierlevel=2 --basename=$@ --suffix=ss.otutable --taxonomyfile=$^ && touch $@

%.classsplit: %.taxonomy %.otutable
	otutable2taxonsplit --verbose --fieldnum=3 --hierlevel=3 --basename=$@ --suffix=otutable --taxonomyfile=$^ && touch $@

%.ss.classsplit: %.taxonomy %.ss.otutable
	otutable2taxonsplit --verbose --fieldnum=3 --hierlevel=3 --basename=$@ --suffix=ss.otutable --taxonomyfile=$^ && touch $@

# Sum otutables on rank
%.sumbyrank: %.taxonomy %.otutable
	otutablesumbyrank --basename=$(basename $@) --suffix=otutable --taxonomyfile=$^ 
	touch $@

%.ss.sumbyrank: %.taxonomy %.otutable
	otutablesumbyrank --basename=$(basename $(basename $@)) --suffix=ss.otutable --taxonomyfile=$^ 
	touch $@

all_sumbyranks: $(subst .otutable,.sumbyrank,$(filter-out $(wildcard *split*) $(wildcard *rank*),$(wildcard *.otutable)))

%.phylumplusproteoclass.otutable: %.rank01.otutable %.rank02.otutable
	sed '/Proteobacteria/d' $< > $@
	grep 'proteobacteria' $(lastword $^) >> $@

# Create heatmap SVG or PDF files
%.heatmap.svg: %.otutable.rmatrix
	Rscript --vanilla -e '$(GPLOTS); $(R_COLOURS); $(READ_SF); $(SVG); $(HEATMAP_WITH_LEGEND)'

%.heatmap.pdf: %.otutable.rmatrix
	Rscript --vanilla -e '$(GPLOTS); $(R_COLOURS); $(READ_SF); $(PDF); $(HEATMAP_WITH_LEGEND)'

# phyloseq associated stuff
%.phyloseqtaxtab: %.silvataxonomy
	sinataxonomy2phyloseqtaxtab $< > $@

all_phyloseqtaxtabs: $(subst .silvataxonomy,.phyloseqtaxtab,$(wildcard *.silvataxonomy))

# Tweaking Megan
all_megan_import_files: $(subst .megan.csv,.otutable.megan.csv,$(filter-out %.otutable.megan.csv,$(wildcard *.megan.csv)))

%.silva_ssuref.otutable.megan.csv: %.silva_ssuref.megan.csv %.otutable
	otutable2megancsv --meganexport=$^ > $@
