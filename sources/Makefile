######################
#  Useful variables  #
######################
gitRoot = $(shell git rev-parse --show-toplevel)
problem = $(shell realpath -s --relative-to $(gitRoot)/tests $(CURDIR))

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

ifdef PERIODICITY
	cpp_flags += -DPERIODICITY=$(PERIODICITY)
endif

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
	cpp_flags += -DADAPT
endif

ifeq ($(PLOT), 1)
	cpp_flags += -DPLOT
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

processed_solver.pde : solver.pde $(PROBLEM) config.mk $(PERIODICITY)
	cpp -w $(cpp_flags) $< | sed '/^\#/d' | sed 's#^\(macro.\+\)$$#\1 //EOM#' | sed '/^$$/d' > $@

output/thermodynamics.txt : processed_solver.pde $(PROBLEM) output/mesh.msh geometry.pde
	FreeFem++ $< $(ff_flags) | tee logs/freefem.log

##############
#  Graphics  #
##############
ifeq ($(DIMENSION), 3)
VIDEO = pictures/video.mpg
else
VIDEO = pictures/video.avi
endif
video :
	find pictures -mindepth 1 -type d -printf '%P\n' | while read l; \
		do mencoder "mf://pictures/$${l}/*.jpg" -mf fps=1 -o pictures/$${l}.avi \
		-ovc lavc -lavcopts vcodec=mpeg4:vhq; done

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

problem = $(CURDIR:$(gitRoot)/tests/%=%)
label = $(subst /,_,$(problem))
plots :
ifeq ($(DIMENSION), 3)
	gmsh -display :0 $(GEOMETRY) $(VIEW) -setnumber video 1
else
	extension=$(extension) label=$(label) gnuplot gnuplot/make-plots.plt
endif

status :
	@echo "Problem $(problem) reporting for duty"; \
	echo "  Number of iterations calculated: $$(ls output/phi/phi.*.vtk | wc -l)"; \
	echo ""

###################################
#  Communication with programmer  #
###################################

report :
	find pictures -mindepth 1 -type d -printf '%P\n' | while read l; \
		do pdfunite $$(ls -v pictures/$${l}/*.pdf) report-$(label)-$${l}.pdf; \
		done

###################
#  Clean outputs  #
###################
clean :
	rm -rf  pictures/* output/* logs/*
