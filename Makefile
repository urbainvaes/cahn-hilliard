default : all

ifndef $(geo)
geo := $(shell basename $(shell dirname $(shell readlink geometry.geo)))
endif

ifndef $(problem)
problem := $(shell basename $(shell dirname $(shell readlink problem.pde)))
endif

ifndef $(host)
host := localhost
endif

##################################################
#  Link files and folder for (geometry,problem)  #
##################################################
install :
	@echo Choose geometry from: $$(ls inputs); \
	echo -n "Enter geometry: " && read geo; \
	echo Choose problem from: $$(ls inputs/$${geo} -I "*.geo"); \
	echo -n "Enter problem: " && read problem; \
	make link geo=$${geo} problem=$${problem};

CACHEDIR = .cache/$(geo)/$(problem)
TARGETS_OUT = $(addprefix $(CACHEDIR)/, mesh output pictures includes)
TARGETS_GEO = $(addprefix inputs/$(geo)/, geometry.geo view.geo)
TARGETS_PRB = $(addprefix inputs/$(geo)/$(problem)/, problem.pde problem.geo)

link :
	mkdir -p $(TARGETS_OUT)
	ln -sft . $(TARGETS_OUT) $(TARGETS_GEO) $(TARGETS_PRB)

show-install :
	@echo "Geometry: $(geo)"
	@echo "Problem: $(problem)"


###############################
#  Create mesh from geometry  #
###############################
OUTDIR := .cache/$(geo)/$(problem)
MESH = $(OUTDIR)/mesh/mesh.msh

mesh : link $(MESH)

$(MESH) : geometry.geo problem.geo
	gmsh $< -3 -o $@ | tee $(OUTDIR)/output/gmsh.log


###################
#  Run FreeFem++  #
###################

# Parse variables from gmsh
GMSHVARS = $(OUTDIR)/includes/gmsh.pde
gmshexport : link $(GMSHVARS)

$(GMSHVARS) : geometry.geo problem.geo
	grep -h 'export' $^ | sed 's/^/real /' > $@;

# Run freefem
OUTPUT := $(OUTDIR)/output/thermodynamics.txt
run : link $(OUTPUT)

# Target to keep in case of error
.PRECIOUS : $(OUTPUT)

$(OUTPUT) : solver.pde $(MESH) problem.pde $(GMSHVARS)
	FreeFem++ -ne solver.pde -plot 0 -out $(OUTDIR)/output | tee $(OUTDIR)/output/freefem.log



##############
#  Graphics  #
##############

# Make video
VIDEO = $(OUTDIR)/pictures/$(geo)-$(problem).mpg
video : link $(VIDEO)

$(VIDEO) : view.geo $(OUTPUT)
	gmsh -display :0 $< -setnumber video 1
	mencoder "mf://output/iso/*.jpg" -mf fps=10 -o $(VIDEO) -ovc lavc -lavcopts vcodec=mpeg4:vhq

# View in gmsh
visualization : link view.geo $(OUTPUT)
	gmsh view.geo

# View video
view : link $(VIDEO)
	DISPLAY=:0 vlc -f $(VIDEO)


###########################
#  Run on remote machine  #
###########################
remote-% :
	ssh  $(host) "cd micro/cahn-hilliard-3d; make $* geo=$(geo) problem=$(problem)"

# Run on the cluster
all :
	ssh uv113@macomp01.ma.ic.ac.uk "cd micro/cahn-hilliard-3d; qsub -N $(geo)-$(problem) -v geo=$(geo),problem=$(problem) run"


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
