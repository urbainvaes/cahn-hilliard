-include ssh.mk
problem = $(shell cat .problem)

install :
	@echo Choose problem from: $$(ls inputs); \
		echo -n "Enter problem: " && read problem; \
		echo $${problem} > .problem;
	@make link

link :
	mkdir -p $(addprefix outputs/$(problem)/, output pictures logs)
	cp -alt  outputs/$(problem) $(wildcard sources/*) $(wildcard inputs/$(problem)/*)

uninstall :
	rm -f .problem

clean-all : uninstall
	rm -rf outputs

.DEFAULT :
	cd outputs/$(problem); make -f local.mk $@
