include ssh.mk

problem ?= $(shell cat .problem)

link :
	mkdir -p $(addprefix tests/$(problem)/, output pictures logs);
	cp -alft  tests/$(problem) sources/* $$(realpath inputs/$(problem)/*);
	rm -f problem && ln -sf inputs/$(problem) problem;
	echo $(problem) > .problem;

install :
	@ gitroot=$$(pwd); \
		echo Git root: $${gitroot}; \
		echo Choose problem from:; \
		cd inputs; subdirs=$$(find * -maxdepth 0 -type d); \
		while [[ $${subdirs} != ""  ]]; do \
			select subdir in $${subdirs}; do break; done; cd $${subdir}; \
			if [[ $${problem} != "" ]]; then problem=$${problem}/; fi; \
			problem=$${problem}$${subdir}; \
			subdirs=$$(find * -maxdepth 0 -type d); done; \
		cd $${gitroot}; \
		make link problem=$${problem}

uninstall :
	rm -f .problem problem

all-% :
	@ find inputs -type d -links 2 -printf '%P\n' | while read line; \
		do make $* problem=$${line}; \
		done;

clean-all : uninstall
	rm -rf tests

.DEFAULT :
	$(MAKE) -C tests/$(problem) $@
