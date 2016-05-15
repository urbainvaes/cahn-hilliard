###################################
#  Include problem configuration  #
###################################
include config.mk

DIMENSION ?= 3
GEOMETRY  ?= problem.geo
VIEW      ?= view.geo

###############################
#  Create mesh from geometry  #
###############################
mesh : output/mesh.msh

output/mesh.msh : $(GEOMETRY)
	gmsh $< -$(DIMENSION) -o $@ | tee logs/gmsh.log

###################
#  Run FreeFem++  #
###################
run : output/thermodynamics.txt

geometry.pde : $(GEOMETRY)
	grep -h 'export' $^ | sed 's/^/real /' > $@;

processed_solver.pde : solver.pde
	cpp -w -DDIMENSION=$(DIMENSION) $^ | \
		sed '/^\#/d' | sed 's#^\(macro.\+\)$$#\1 //EOM#' > $@

output/thermodynamics.txt : processed_solver.pde problem.pde output/mesh.msh geometry.pde
	FreeFem++ -ne $< -plot 0 | tee logs/freefem.log

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
	gmsh -display :0 -setnumber video 1 $(GEOMETRY) $<
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
