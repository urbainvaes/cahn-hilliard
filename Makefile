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

#######################
#  Location of files  #
#######################
GEO    = inputs/$(geo)/geometry.geo
VIEW   = inputs/$(geo)/view.geo
PRBGEO = inputs/$(geo)/$(problem)/problem.geo
PRBPDE = inputs/$(geo)/$(problem)/problem.pde

PRBDIR   = outputs/$(geo)/$(problem)
OUTDIR   = $(PRBDIR)/output
INCDIR   = $(PRBDIR)/includes
LOGDIR   = $(PRBDIR)/logs
THERMO   = $(OUTDIR)/thermodynamics.txt
MESH     = meshes/$(geo)-$(problem).msh
VIDEO    = pictures/$(geo)-$(problem).mpg


##################################################
#  Link files and folder for (geometry,problem)  #
##################################################
install :
	@echo Choose geometry from: $$(ls inputs); \
		echo -n "Enter geometry: " && read geo; \
		echo Choose problem from: $$(ls inputs/$${geo} -I "*.geo"); \
		echo -n "Enter problem: " && read problem; \
		make link geo=$${geo} problem=$${problem};

link :
	mkdir -p $(OUTDIR) $(INCDIR) $(LOGDIR) meshes pictures
	ln -sft . $(OUTDIR) $(INCDIR) $(LOGDIR)
	ln -sft . $(GEO) $(VIEW) $(PRBGEO) $(PRBPDE)

show-install :
	@echo "Geometry: $(geo)"
	@echo "Problem: $(problem)"

###############################
#  Create mesh from geometry  #
###############################
mesh : $(MESH)

$(MESH) : $(GEO) $(PRBGEO)
	make link geo=$(geo) problem=$(problem)
	gmsh geometry.geo -3 -o $@ | tee $(LOGDIR)/gmsh.log

###################
#  Run FreeFem++  #
###################
run : $(THERMO)

$(INCDIR)/gmsh.pde : $(GEO) $(PRBGEO)
	grep -h 'export' $^ | sed 's/^/real /' > $@;

$(THERMO) : solver.pde $(MESH) $(PRBPDE) $(INCDIR)/gmsh.pde
	make link geo=$(geo) problem=$(problem)
	FreeFem++ -ne solver.pde -plot 0 -in $(MESH) -out $(PRBDIR)/output | tee $(LOGDIR)/freefem.log

##############
#  Graphics  #
##############
video : $(VIDEO)

$(VIDEO) : view.geo $(THERMO)
	make link geo=$(geo) problem=$(problem)
	ln -sf $(MESH) mesh.msh
	gmsh -display :0 $< -setnumber video 1
	mencoder "mf://output/iso/*.jpg" -mf fps=10 -o $(VIDEO) -ovc lavc -lavcopts vcodec=mpeg4:vhq

visualization : view.geo $(THERMO)
	make link geo=$(geo) problem=$(problem)
	ln -sf $(MESH) mesh.msh
	gmsh view.geo

view : $(VIDEO)
	DISPLAY=:0 vlc -f $(VIDEO)

########################################################################
#  Run on remote machine or submit to the math complute cluster queue  #
########################################################################
remote-% :
	ssh  $(host) "cd micro/cahn-hilliard-3d; make $* geo=$(geo) problem=$(problem)"

all :
	ssh uv113@macomp01.ma.ic.ac.uk "cd micro/cahn-hilliard-3d; qsub -N $(geo)-$(problem) -v geo=$(geo),problem=$(problem) run"

######################################################################
#  Clean links, output of current problem, or all regenerable files  #
######################################################################
LINKS = $(shell find . -type l -printf "%P ")

clean-links :
	rm -f $(LINKS)

clean :
	rm -rf $(MESH) $(VIDEO) output/* includes/*

clean-all : clean-links
	rm -rf outputs meshes pictures
