# Bunch = file with a list of tests
# Problem = the current test

live     = .bunches/.installed
bunch   ?= $(shell test -s $(live) && cat $(live) || echo default)
problem ?= $(shell cat .bunches/.installed-$(bunch))
fzf     ?= sources/bin/fzf-0.16.3-linux_386

###################
#  Install bunch  #
###################
bunch :
	find .bunches/* -printf "%f\n" 2>/dev/null | $(fzf) --print-query | tail -1 > $(live);

#######################################################
#  Install and uninstall a test to the current bunch  #
#######################################################
regex ?= ".*"
list_inputs = $(shell find inputs -name "*.h" -regex $(regex) | sed 's!inputs/!!;s!\(-\|/\)config.h!!')
choose_input = $(shell echo "$(list_inputs)" | tr " " "\n" | $(fzf) -m --bind=ctrl-t:toggle)

install :
	@echo "$(choose_input)" | tr " " "\n" >> .bunches/$(bunch) || echo "No change";
	@sed -i "/^$$/d" .bunches/$(bunch)

uninstall :
	cat .bunches/$(bunch) | $(fzf) -m --bind=ctrl-t:toggle | while read p; do sed -i "\#$${p}#d" .bunches/$(bunch); done;

# Select in bunch
select :
	cat .bunches/$(bunch) | $(fzf) > .bunches/.installed-$(bunch)

#################################
#  Set up environment for test  #
#################################
link :
	mkdir -p $(addprefix tests/$(problem)/, output pictures logs);
	ln -srf $(PWD)/$(shell find inputs -name "*.h" | grep "$(problem)[/-]") tests/$(problem)/config.h
	ln -srft tests/$(problem) sources/Makefile

unlink :
	rm -rf tests/$(problem)

#####################
#  For convenience  #
#####################
fetch :
	mkdir -p reports
	mv tests/$(problem)/report* reports

################################
#  Act on all installed tests  #
################################

# Execute command for all problems in individual directories
# e.g. make all command='rm -rf tests/$${p}/pictures
all :
	for p in $$(cat .bunches/$(bunch)); do $(command); done

# Execute target for all problems in top directory
all-% :
	for p in $$(cat .bunches/$(bunch)); do make $* problem=$${p}; done

clean-all :
	rm -rf tests

#################################
#  Acts on last installed test  #
#################################
.DEFAULT :
	$(MAKE) -C tests/$(problem) $@
