ifndef VERBOSE
.SILENT:
endif

# Bunch = file with a list of tests
# Problem = the current test

live     = .bunches/.installed
bunch   ?= $(shell test -s $(live) && cat $(live) || echo default)
problem ?= $(shell test -s .bunches/.installed-$(bunch) && cat .bunches/.installed-$(bunch) || head -1 .bunches/$(bunch))
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

fzf-install = $(fzf) --prompt="Select test to install: " -m --bind=ctrl-t:toggle
install :
	find inputs -name "*.h" -regex $(regex) -printf "%P\\n" | gawk -f sources/bin/list_inputs.awk | \
		sed '/^$$/d;/^#/d' | $(fzf-install) >> .bunches/$(bunch) || echo "No change";
	sed -i "/^$$/d" .bunches/$(bunch)

fzf-uninstall = $(fzf) --prompt="Select test to uninstall: " -m --bind=ctrl-t:toggle
uninstall :
	@cat .bunches/$(bunch) | $(fzf-uninstall) | \
		while read p; do sed -i "\#$${p}#d" .bunches/$(bunch); done;

# Select in bunch
select :
	@cat .bunches/$(bunch) | \
		$(fzf) --prompt="Select default test: " > .bunches/.installed-$(bunch) || echo "No test selected"

#################################
#  Set up environment for test  #
#################################
link :
	mkdir -p $(addprefix tests/$(problem)/, output pictures logs);
	ln -srft tests/$(problem) sources/Makefile
	find inputs -name "*.h" -regex $(regex) -printf "%P\\n" | gawk -f sources/bin/list_inputs.awk | \
		grep -Fx -A9 "$(problem)" | sed -n '2,/^$$/p' > tests/$(problem)/config.h

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
	for p in $$(cat .bunches/$(bunch)); do echo $$p; make $* problem=$${p}; done

clean-all :
	rm -rf tests

####################
#  Push to remote  #
####################
push:
	rsync -r --delete --exclude='/.git' --filter="dir-merge,- .gitignore" . uv113@macomp001.ma.ic.ac.uk:cahn-hilliard

sync:
	inotifywait -r -m -q -e modify --format '%w%f' -- inputs sources Makefile |\
		while read file; do echo "Pushing file $$file"; \
		rsync -r $$file uv113@macomp001.ma.ic.ac.uk:cahn-hilliard/$$file;\
		done

#################################
#  Acts on last installed test  #
#################################
.DEFAULT :
	$(MAKE) -C tests/$(problem) $@
