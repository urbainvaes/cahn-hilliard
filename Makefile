# Default target
all :
	ssh uv113@macomp01.ma.ic.ac.uk "cd micro/cahn-hilliard-3d; qsub -N $(geo)-$(problem) -v geo=$(geo),problem=$(problem) run_script"

run-live :
	ssh uv113@macomp01.ma.ic.ac.uk 'cd micro/cahn-hilliard-3d; make clean; make run; make remote-video host="urbain@155.198.212.223"'

# Default values for input variables
geo     := $(shell basename $(shell dirname $(shell readlink geometry.geo)))
problem := $(shell basename $(shell dirname $(shell readlink problem.pde)))
host    := localhost

# Install symlinks to problem files
install :
	@echo Choose geometry from: $$(ls inputs); \
		echo -n "Enter geometry: " && read geo; \
		echo Choose problem from: $$(ls inputs/$${geo} -I "*.geo"); \
		echo -n "Enter problem: " && read problem; \
		make link geo=$${geo} problem=$${problem};

LINK_DIR = outputs/$(geo)/$(problem)
LINK_OUT = $(addprefix $(LINK_DIR)/, output pictures includes logs)
LINK_IN  = $(addprefix inputs/$(geo)/, geometry.geo view.geo $(addprefix $(problem)/, problem.pde problem.geo))
LINK_COM = local.mk solver.pde aux

link :
	mkdir -p $(LINK_OUT)
	ln -sfrt . $(LINK_OUT) $(LINK_IN)
	ln -sfrt $(LINK_DIR) $(addprefix $(shell pwd)/, $(LINK_IN) $(LINK_COM))

show-install :
	@echo "Geometry: $(geo)"
	@echo "Problem: $(problem)"

#  Run on remote machine or submit to the math complute cluster queue
remote-% :
	ssh  $(host) "cd micro/cahn-hilliard-3d; make $* geo=$(geo) problem=$(problem)"

# Symlink all videos
link-videos :
	for file in $$(find $$(pwd) -name "video.mpg"); do \
		name=$$(echo $${file} | sed "s#^.\+outputs/\([^/]\+\)/\([^/]\+\)/pictures/video.mpg#\1-\2.mpg#g"); \
		ln -sfr $${file} videos/$${name}; \
	done

# Clean
uninstall :
	rm -f $(shell find . -type l -printf "%P ")

clean-all : uninstall
	rm -rf outputs

# Make targets in isolated directory by default
.DEFAULT :
	cd $(LINK_DIR); make -f local.mk $@
