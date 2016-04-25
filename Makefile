# Default target
default : visualization

ifndef $(geo)
geo = $(shell basename $(shell dirname $(shell readlink geometry.geo)))
endif

ifndef $(problem)
problem = $(shell basename $(shell dirname $(shell readlink problem.pde)))
endif

##################################################
#  Link files and folder for (geometry,problem)  #
##################################################
install :
	@echo Choose geometry from: $$(ls inputs); \
	echo -n "Enter geometry: " && read geo; \
	echo Choose problem from: $$(ls inputs/$${geo} -I "*.geo"); \
	echo -n "Enter problem: " && read problem; \
	make batch-install geo=$${geo} problem=$${problem};


CACHEDIR = .cache/$(geo)/$(problem)
TARGETS_OUT = $(addprefix $(CACHEDIR)/, mesh output pictures includes)
TARGETS_GEO = $(addprefix inputs/$(geo)/, geometry.geo view.geo)
TARGETS_PRB = $(addprefix inputs/$(geo)/$(problem)/, problem.pde problem.geo)

batch-install :
	mkdir -p $(TARGETS_OUT)
	ln -sft . $(TARGETS_OUT) $(TARGETS_GEO) $(TARGETS_PRB)


###############################
#  Create mesh from geometry  #
###############################
MESH = mesh/mesh.msh
OUTDIR := $(shell readlink output)

mesh : $(MESH)

$(MESH) : geometry.geo problem.geo
	gmsh $< -3 -o $@ | tee $(OUTDIR)/gmsh.log


###################
#  Run FreeFem++  #
###################

# Parse variables from gmsh
GMSHVARS = includes/gmsh.pde
gmshexport : $(GMSHVARS)

$(GMSHVARS) : geometry.geo problem.geo
	grep -h 'export' $^ | sed 's/^/real /' > $@;

# Run freefem
OUTPUT := $(OUTDIR)/output.msh
run : $(OUTPUT)

# Number of processors
np = $(shell grep 'np = [0-9]*;' problem.geo | sed 's/[^0-9]*//g')

# Target to keep in case of error
.PRECIOUS : $(OUTPUT)

$(OUTPUT) : solver.pde $(MESH) problem.pde $(GMSHVARS)
	mpirun -np $(np) \
		FreeFem++-mpi -ne -nw -v 0 solver.pde -plot 0 -out $(OUTDIR) | tee $(OUTDIR)/freefem.log

# Run on the cluster
submit :
	ssh uv113@macomp01.ma.ic.ac.uk qsub -v geo=$(geo),problem=$(problem) micro/cahn-hilliard-3d/run


##############
#  Graphics  #
##############

# Make video
VIDEO = pictures/$(geo)-$(problem).mpg
video : $(VIDEO)

output/iso/done : view.geo $(OUTPUT)
	gmsh $< -setnumber video 1

$(VIDEO) : output/iso/done
	mencoder "mf://output/iso/*.jpg" -mf fps=10 -o $(VIDEO) -ovc lavc -lavcopts vcodec=mpeg4:vhq

# View in gmsh
visualization : view.geo $(OUTPUT)
	gmsh $<

# View video
view : $(VIDEO)
	vlc $(VIDEO)


######################################################################
#  Clean links, output of current problem, or all regenerable files  #
######################################################################
LINKS = $(shell find . -type l -printf "%P ")

clean-links :
	rm -f $(LINKS)

clean :
	rm -rf output/* mesh/* includes/* pictures/*

clean-all : clean-links
	rm -rf .cache
