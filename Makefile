include ssh.mk

problem ?= $(shell cat .problem)

link :
	mkdir -p $(addprefix tests/$(problem)/, output pictures logs);
	cp -alft  tests/$(problem) sources/* inputs/$(problem)/*;
	rm -f problem && ln -sf inputs/$(problem) problem;
	echo $(problem) > .problem;

install :
	@ echo Choose problem from: $$(ls inputs); \
		echo -n "Enter problem: " && read problem; \
		make link problem=$${problem}

uninstall :
	rm -f .problem problem

clean-all : uninstall
	rm -rf tests

.DEFAULT :
	$(MAKE) -C tests/$(problem) $@
