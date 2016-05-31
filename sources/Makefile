###################################
#  Include problem configuration  #
###################################
include config.mk

DIMENSION ?= 3
GEOMETRY  ?= problem.geo
PROBLEM   ?= problem.pde
VIEW      ?= view.geo

###############################
#  Create mesh from geometry  #
###############################
mesh : output/mesh.msh

output/mesh.msh : $(GEOMETRY) config.mk
ifdef NP
	gmsh $< -$(DIMENSION) -part $(NP) -o tmp.msh | tee logs/gmsh.log
	bin/parseMetisMesh tmp.msh $@
else
	gmsh $< -$(DIMENSION) -o $@ | tee logs/gmsh.log
endif

###################
#  Run FreeFem++  #
###################
run : output/thermodynamics.txt

geometry.pde : $(GEOMETRY)
	grep -h 'export' $^ | sed 's/^/real /' > $@;

processed_solver.pde : solver.pde config.mk
ifdef NP
	cpp -w -DDIMENSION=$(DIMENSION) -DPROBLEM=$(PROBLEM) -DMPI $< | \
		sed '/^\#/d' | sed 's#^\(macro.\+\)$$#\1 //EOM#' | sed '/^$$/d' > $@
else
	cpp -w -DDIMENSION=$(DIMENSION) -DPROBLEM=$(PROBLEM) $< | \
		sed '/^\#/d' | sed 's#^\(macro.\+\)$$#\1 //EOM#' | sed '/^$$/d' > $@
endif

output/thermodynamics.txt : processed_solver.pde $(PROBLEM) output/mesh.msh geometry.pde
ifdef NP
	mpirun -np $(NP) FreeFem++-mpi -ne -v 0 $< -plot 0 | tee logs/freefem.log
else
	FreeFem++ -ne -v 0 $< -plot 0 | tee logs/freefem.log
endif

##############
#  Graphics  #
##############
ifeq ($(DIMENSION), 3)
VIDEO = pictures/video.mpg
else
VIDEO = pictures/video.ogv
endif
video : $(VIDEO)

$(VIDEO) : $(VIEW) output/thermodynamics.txt
ifeq ($(DIMENSION), 3)
	gmsh -display :0 $(GEOMETRY) $< -setnumber video 1
	mencoder "mf://output/iso/*.jpg" -mf fps=10 -o $(VIDEO) -ovc lavc -lavcopts vcodec=mpeg4:vhq
else
	DISPLAY=:0 pvpython $< --input phi --range -1,1 --video $(VIDEO)
endif

visualization : $(VIEW) output/thermodynamics.txt
ifeq ($(DIMENSION), 3)
	gmsh -display :0 $(GEOMETRY) $<
else
	DISPLAY=:0 pvpython $< --input phi --range -1,1
	DISPLAY=:0 pvpython $< --input mu
endif

view : $(VIDEO)
	DISPLAY=:0 vlc -f $(VIDEO)

plots :
	gnuplot gnuplot/thermo.plt

###################
#  Clean outputs  #
###################
clean :
	rm -rf  pictures/* output/* logs/*
