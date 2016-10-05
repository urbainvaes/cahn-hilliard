##################################
#  Install and uninstall a test  #
##################################
install :
	find inputs -type d -printf '%P\n' | \
		while read l; do [[ $$(find inputs/$$l/* -type d) = "" ]] && echo $$l; done | \
		fzf -m --bind=ctrl-t:toggle >> .problems;

uninstall :
	cat .problems | fzf -m --bind=ctrl-t:toggle | while read p; do sed -i "\#$${p}#d" .problems; done;

problem ?= $(shell cat .problems | tail -1)

#################################
#  Set up environment for test  #
#################################
link :
	mkdir -p $(addprefix tests/$(problem)/, output pictures logs);
	cp -alft tests/$(problem) sources/* $$(realpath inputs/$(problem)/*);

unlink :
	rm -rf tests/$(problem)

################################
#  Act on all installed tests  #
################################

# Execute command for all problems in individual directories
all :
	for p in $$(cat .problems); do cd tests/$${p}; $(command); cd $(CURDIR); done

# Execute target for all problems in top directory
all-% :
	for p in $$(cat .problems); do make $* problem=$${p}; done

clean-all :
	rm -rf tests

#################################
#  Acts on last installed test  #
#################################
.DEFAULT :
	$(MAKE) -C tests/$(problem) $@
