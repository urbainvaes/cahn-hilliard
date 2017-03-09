######################
#  Useful variables  #
######################
gitRoot = $(shell git rev-parse --show-toplevel)
# problem = $(shell realpath -s --relative-to $(gitRoot)/tests $(CURDIR))
problem = $(CURDIR:$(gitRoot)/tests/%=%)
label = $(subst /,_,$(problem))

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

ifeq ($(BEFORE), 1)
	cpp_flags += -DBEFORE
	BEFORE_FILE = before.pde
endif

ifeq ($(AFTER), 1)
	cpp_flags += -DAFTER
	AFTER_FILE = after.pde
endif

ifeq ($(MUMPS), 1)
	cpp_flags += -DMUMPS
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
geometry.pde : $(GEOMETRY)
	grep -h 'export' $^ | sed 's/^/real /' > $@;

processed_solver.pde : solver.pde config.mk $(PROBLEM) $(PERIODICITY) $(BEFORE_FILE) $(AFTER_FILE)
	cpp -w $(cpp_flags) $< | sed '/^\#/d' | sed 's#^\(macro.\+\)$$#\1 //EOM#' | sed '/^$$/d' > $@

run : processed_solver.pde geometry.pde output/mesh.msh
	FreeFem++ $< $(ff_flags) | tee logs/freefem.log

##############
#  Graphics  #
##############
plots :
ifeq ($(DIMENSION), 3)
	gmsh -display :0 $(GEOMETRY) $(VIEW) -setnumber video 1
else
	label=$(label) gnuplot gnuplot/make-plots.plt
endif

visualization : $(VIEW)
ifeq ($(suffix $(VIEW)), .geo)
	gmsh -display :0 $(GEOMETRY) $<
endif
ifeq ($(suffix $(VIEW)), .py)
	DISPLAY=:0 pvpython $< --input phi --range -1,1
endif

video :
	find pictures -mindepth 1 -type d -printf '%P\n' | while read l; \
		do mencoder "mf://pictures/$${l}/*.png" -mf fps=10 -o pictures/$${l}.avi \
		-ovc lavc -lavcopts vcodec=mpeg4:vhq; done

status :
	@echo "Problem $(problem) reporting for duty"; \
	echo "  Number of iterations calculated: $$(ls output/phi/phi.*.vtk 2>/dev/null | wc -l)"; \
	echo ""

macros :
	./bin/macroPlots

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
