##################################
#  Install and uninstall a test  #
##################################
install :
	@problems=$$(find inputs -type d -links 2 -printf '%P\n'); \
		select problem in $${problems}; do echo $${problem} >> .problems; break; done;

uninstall :
	@problems=$$(cat .problems); \
		select problem in $${problems}; do sed -i "\#$${problem}#d" .problems; break; done;

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
all-% :
	for p in $$(cat .problems); do make $* problem=$${p}; done

clean-all :
	rm -rf tests

#################################
#  Acts on last installed test  #
#################################
.DEFAULT :
	$(MAKE) -C tests/$(problem) $@
