#########################
#  Include ssh targets  #
#########################
include ssh.mk

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

ifeq ($(NS), 1)
	cpp_flags += -DNS
endif

ifeq ($(ELECTRO), 1)
	cpp_flags += -DELECTRO
endif

ifeq ($(GRAVITY), 1)
	cpp_flags += -DGRAVITY
endif

ifeq ($(ADAPT), 1)
	ff_flags += -adapt 1
endif

ifeq ($(PLOT), 1)
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
endif

view : $(VIDEO)
	DISPLAY=:0 vlc -f $(VIDEO)

plots :
	gnuplot gnuplot/make-plots.plt

################
#  Run status  #
################
problem = $(shell realpath -s --relative-to $(gitRoot)/tests $(CURDIR))

status :
	@echo "Problem $(problem) reporting for duty"; \
	echo "  Number of iterations calculated: $$(ls output/phi/phi.*.vtk | wc -l)"; \
	echo ""

############
#  Report  #
############
report :
	find pictures -mindepth 1 -type d -printf '%P\n' | while read l; \
		do pdfunite $$(ls -v pictures/$${l}/*.pdf) report-$${l}.pdf; done

###################
#  Clean outputs  #
###################
clean :
	rm -rf  pictures/* output/* logs/*
