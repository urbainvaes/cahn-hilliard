######################
#  Useful variables  #
######################
gitRoot = $(shell git rev-parse --show-toplevel)
binDir  = $(gitRoot)/sources/bin
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
plot_flags = --parallel

ifdef PERIODICITY
	cpp_flags += -DPERIODICITY=$(PERIODICITY)
endif

ifeq ($(NS), 1)
	cpp_flags += -DNS
	plot_flags += --flow
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

ifeq ($(TIMEADAPT), 1)
	cpp_flags += -DTIMEADAPT
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

ifeq ($(OD2), 1)
	cpp_flags += -DOD2
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
FF_COMMAND ?= FreeFem++

geometry.pde : $(GEOMETRY)
	grep -h 'export' $^ | sed 's/^/real /' > $@;

processed_solver.pde : solver.pde config.mk $(PROBLEM) $(PERIODICITY) $(BEFORE_FILE) $(AFTER_FILE)
	cpp -w -C -P $(cpp_flags) $< > $@

run : processed_solver.pde geometry.pde output/mesh.msh
	$(FF_COMMAND) $< $(ff_flags) | tee logs/freefem.log

##############
#  Graphics  #
##############
plots :
ifeq ($(DIMENSION), 3)
	gmsh -display :0 $(VIEW) -setnumber video 1
else
	python $(binDir)/python/plot.py $(plot_flags) $(label)
endif

field   ?= all
step    ?= 1
startAt ?= 0

visualization : $(VIEW)
ifeq ($(suffix $(VIEW)), .geo)
	gmsh -v 1000 -setstring field $(field) -setnumber step $(step) -setnumber startAt $(startAt) $<
endif
ifeq ($(suffix $(VIEW)), .py)
	DISPLAY=:0 pvpython $< --input phi --range -1,1
endif

fps ?= 10
video :
	find pictures -mindepth 1 -type d -printf '%P\n' | while read l; \
		do mencoder "mf://pictures/$${l}/*.png" -mf fps=$(fps) -o pictures/$${l}.avi \
		-ovc lavc -lavcopts vcodec=mpeg4:vhq; done

status :
	@echo "Problem $(problem) reporting for duty"; \
	echo "  Number of iterations calculated: $$(ls output/done/done-*.txt 2>/dev/null | wc -l)"; \
	echo ""

macros :
	mkdir -p output/macros
	grep "Iteration: "                             logs/freefem.log | awk '{ print $$NF }' > output/macros/iter.txt
	grep "Time: "                                  logs/freefem.log | awk '{ print $$NF }' > output/macros/time.txt
	grep "Time step: "                             logs/freefem.log | awk '{ print $$NF }' > output/macros/timeStep.txt
	grep "Mass: "                                  logs/freefem.log | awk '{ print $$NF }' > output/macros/mass.txt
	grep "Integrated diffusive mass flux: "        logs/freefem.log | awk '{ print $$NF }' > output/macros/diffMass.txt
	grep "Integrated convective mass flux: "       logs/freefem.log | awk '{ print $$NF }' > output/macros/convMass.txt
	grep "Bulk free energy: "                      logs/freefem.log | awk '{ print $$NF }' > output/macros/bulkFree.txt
	grep "Wall free energy: "                      logs/freefem.log | awk '{ print $$NF }' > output/macros/wallFree.txt
	grep "Integrated free energy dissipations: "   logs/freefem.log | awk '{ print $$NF }' > output/macros/dissFree.txt
	grep "Integrated diffusive free energy flux: " logs/freefem.log | awk '{ print $$NF }' > output/macros/diffFree.txt
	grep "Increase in free energy: "               logs/freefem.log | awk '{ print $$NF }' > output/macros/incFree.txt
	grep "Free energy balance"                     logs/freefem.log | awk '{ print $$NF }' > output/macros/freeBal.txt
	python $(binDir)/python/graphs.py $(label)

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
