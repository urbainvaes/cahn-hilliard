######################
#  Useful variables  #
######################
GITROOT = $(shell git rev-parse --show-toplevel)
BINDIR  = $(GITROOT)/sources/bin
PROBLEM = $(CURDIR:$(GITROOT)/tests/%=%)
LABEL   = $(subst /,_,$(PROBLEM))

#########################
#  Include ssh targets  #
#########################
include $(GITROOT)/sources/ssh.mk


###################################
#  Include PROBLEM configuration  #
###################################
include config.mk

# Default values (configurable in command line or via config.mk)
DIMENSION    ?= 3
SOLVER       ?= $(GITROOT)/sources/solver.pde
CPP_FLAGS    ?= -P -DGITROOT=$(GITROOT) -DDIMENSION=$(DIMENSION) -imacros config.mk

FF_COMMAND   ?= FreeFem++
FF_FLAGS     ?= -ne -v 0
PLOT_FLAGS   ?= --parallel
VIDEO_FPS    ?= 10
VIEW_FIELD   ?= all
VIEW_STARTAT ?= 0
VIEW_STEP    ?= 1


###############################
#  Create mesh from geometry  #
###############################
mesh : output/mesh.msh

geometry.geo : $(GEOMETRY) config.mk
	cpp $(CPP_FLAGS) $< > $@

output/mesh.msh : geometry.geo
	gmsh $< -$(DIMENSION) -o $@ | tee logs/gmsh.log


###################
#  Run FreeFem++  #
###################

solver.pde : $(SOLVER) config.mk
	cpp -C -w $(CPP_FLAGS) $(SOLVER) > $@

run : solver.pde
	$(FF_COMMAND) solver.pde $(FF_FLAGS) | tee logs/freefem.log


##############
#  Graphics  #
##############
plots :
ifeq ($(DIMENSION), 3)
	gmsh -display :0 $(VIEW) -setnumber video 1
else
	python $(BINDIR)/python/plot.py $(plot_flags) $(LABEL)
endif

view.geo:
	cpp -C -P -w -imacros config.mk $(VIEW) > $@

view :
	gmsh \
	    -v 1000 \
		-setstring field $(VIEW_FIELD) \
		-setnumber step $(VIEW_STEP) \
		-setnumber startAt $(VIEW_STARTAT) \
		view.geo

video :
	find pictures -mindepth 1 -type d -printf '%P\n' | while read l; \
		do mencoder "mf://pictures/$${l}/*.png" -mf VIDEO_FPS=$(VIDEO_FPS) -o pictures/$${l}.avi \
		-ovc lavc -lavcopts vcodec=mpeg4:vhq; done

##################################
#  Graphs of mass, energy, etc.  #
##################################
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
	python $(BINDIR)/python/graphs.py $(LABEL)


###################
#  Clean outputs  #
###################
clean :
	rm -rf  pictures/* output/* logs/*


###########################
#  Convenience functions  #
###########################
report :
	find pictures -mindepth 1 -type d -printf '%P\n' | while read l; \
		do pdfunite $$(ls -v pictures/$${l}/*.pdf) report-$(LABEL)-$${l}.pdf; \
		done

status :
	@echo "Problem $(PROBLEM) reporting for duty"; \
	echo "  Number of iterations calculated: $$(ls output/done/done-*.txt 2>/dev/null | wc -l)"; \
	echo ""
