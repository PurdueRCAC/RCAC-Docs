# FILENAME: Makefile
# Count the words in each data/*.txt file, then collect the counts in summary.txt.

# Recipe lines start with ">" rather than a tab, so the file still works when a
# tab turns into spaces on its way from a web page to your editor.
.RECIPEPREFIX = >

# If a recipe fails, delete its half-written target so a rerun builds it again.
.DELETE_ON_ERROR:

INPUTS := $(sort $(wildcard data/*.txt))
COUNTS := $(patsubst data/%.txt,results/%.count,$(INPUTS))

summary.txt: $(COUNTS)
> cat $^ > $@

results/%.count: data/%.txt | results
> wc -w $< > $@

results:
> mkdir -p $@
