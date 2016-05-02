# Default target
all :
	ssh uv113@macomp01.ma.ic.ac.uk "cd micro/cahn-hilliard-3d; qsub -N $(geo)-$(problem) -v geo=$(geo),problem=$(problem) run"

ifndef $(geo)
geo := $(shell basename $(shell dirname $(shell readlink geometry.geo)))
endif

ifndef $(problem)
problem := $(shell basename $(shell dirname $(shell readlink problem.pde)))
endif

# Install symlinks to problem files
install :
	@echo Choose geometry from: $$(ls inputs); \
		echo -n "Enter geometry: " && read geo; \
		echo Choose problem from: $$(ls inputs/$${geo} -I "*.geo"); \
		echo -n "Enter problem: " && read problem; \
		make link geo=$${geo} problem=$${problem};

LINK_OUT = $(addprefix outputs/$(geo)/$(problem)/, output pictures includes logs mesh)
LINK_IN  = $(addprefix inputs/$(geo)/, geometry.geo view.geo $(addprefix $(problem)/, problem.pde problem.geo))
LINK_COM = local.mk solver.pde aux
LINK_DIR = .protected-$(geo)-$(problem)

link :
	mkdir -p $(LINK_DIR) $(LINK_OUT)
	ln -sft . $(LINK_OUT) $(LINK_IN)
	ln -sfrt $(LINK_DIR) $(addprefix $(shell pwd)/, $(LINK_OUT) $(LINK_IN) $(LINK_COM))

show-install :
	@echo "Geometry: $(geo)"
	@echo "Problem: $(problem)"

# Run in isolated environment
protected-% :
	cd $(LINK_DIR); make -f local.mk $* geo=$(geo) problem=$(problem)

#  Run on remote machine or submit to the math complute cluster queue
ifndef $(host)
host := localhost
endif

remote-% :
	ssh  $(host) "cd micro/cahn-hilliard-3d; make $* geo=$(geo) problem=$(problem)"

# Include local makefile
include local.mk

# Clean
uninstall :
	rm -f $(shell find . -type l -printf "%P ")

clean-all : uninstall
	rm -rf .protected-* outputs
