###################################
#  Include problem configuration  #
###################################
include config.mk

DIMENSION ?= 3

# Files
GEOMETRY  ?= problem.geo
PROBLEM   ?= problem.pde
VIEW      ?= view.geo

# Flags
cpp_flags = -DDIMENSION=$(DIMENSION) -DPROBLEM=$(PROBLEM) -DGEOMETRY=$(GEOMETRY)
ff_flags = -ne -v 0

ifdef NS
	cpp_flags += -DNS
endif

ifdef ELECTRO
	cpp_flags += -DELECTRO
endif

ifdef GRAVITY
	cpp_flags += -DGRAVITY
endif

ifdef ADAPT
	ff_flags += -adapt 1
endif

ifdef PLOT
	ff_flags += -plot 1
endif

###############################
#  Create mesh from geometry  #
###############################
mesh : output/mesh.msh

output/mesh.msh : $(GEOMETRY) config.mk
	gmsh $< -$(DIMENSION) -o $@ | tee logs/gmsh.log

###################
#  Run FreeFem++  #
###################
run : output/thermodynamics.txt

geometry.pde : $(GEOMETRY)
	grep -h 'export' $^ | sed 's/^/real /' > $@;

processed_solver.pde : solver.pde $(PROBLEM) config.mk
	cpp -w $(cpp_flags) $< | sed '/^\#/d' | sed 's#^\(macro.\+\)$$#\1 //EOM#' | sed '/^$$/d' > $@

output/thermodynamics.txt : processed_solver.pde $(PROBLEM) output/mesh.msh geometry.pde
	FreeFem++ $< $(ff_flags) | tee logs/freefem.log

##############
#  Graphics  #
##############
ifeq ($(DIMENSION), 3)
VIDEO = pictures/video.mpg
else
VIDEO = pictures/video.ogv
endif
video : $(VIDEO)

$(VIDEO) : $(VIEW)
ifeq ($(DIMENSION), 3)
	gmsh -display :0 $(GEOMETRY) $< -setnumber video 1
	mencoder "mf://output/iso/*.jpg" -mf fps=10 -o $(VIDEO) -ovc lavc -lavcopts vcodec=mpeg4:vhq
else
	DISPLAY=:0 pvpython $< --input phi --range -1,1 --video $(VIDEO)
endif

visualization : $(VIEW)
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
