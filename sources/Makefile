######################
#  Useful variables  #
######################
GITROOT   = $(shell git rev-parse --show-toplevel)
bindir    = $(GITROOT)/sources/bin
problem   = $(CURDIR:$(GITROOT)/tests/%=%)
label     = $(subst /,_,$(problem))
cpp_flags = -P -DGITROOT=$(GITROOT) -imacros config.h

#########################
#  Include ssh targets  #
#########################
include $(GITROOT)/sources/ssh.mk


###################################
#  Include problem configuration  #
###################################
config.mk : config.h
	cpp $(cpp_flags) $(GITROOT)/sources/defaults.mk > $@

include config.mk


######################
#  Files to process  #
######################

geometry.geo : $(geometry) config.h
	cpp $(cpp_flags) $(geometry) > $@

solver.pde : $(solver) config.h
	cpp -C -w $(cpp_flags) $(solver) > $@

view.geo : $(view) config.h
	cpp $(cpp_flags) $(view) > $@

rebuild :
	rm -f geometry.geo solver.pde view.geo
	make geometry.geo solver.pde view.geo


###############################
#  Create mesh from geometry  #
###############################
mesh : output/mesh.msh

output/mesh.msh : geometry.geo
	gmsh $< -$(dimension) -o $@ | tee logs/gmsh.log


###################
#  Run FreeFem++  #
###################

run : solver.pde
	$(ff_command) solver.pde $(ff_flags) | tee logs/freefem.log


##############
#  Graphics  #
##############
plots :
ifeq ($(dimension), 3)
	gmsh -display :0 $(VIEW) -setnumber video 1
else
	python $(bindir)/python/plot.py $(plot_flags) $(label)
endif

view : view.geo
	gmsh \
	    -v 1000 \
		-setstring field $(view_field) \
		-setnumber step $(view_step) \
		-setnumber startAt $(view_startat) \
		view.geo

video :
	find pictures -mindepth 1 -type d -printf '%P\n' | while read l; \
		do mencoder "mf://pictures/$${l}/*.png" -mf fps=$(video_fps):type=png -o pictures/$${l}.avi \
		-ovc copy -oac copy; done
		# -ovc lavc -lavcopts vcodec=mpeg4:vhq; done

##################################
#  Graphs of mass, energy, etc.  #
##################################
graphs :
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
	python $(bindir)/python/graphs.py $(label)


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
		do pdfunite $$(ls -v pictures/$${l}/*.pdf) report-$(label)-$${l}.pdf; \
		done

status :
	@echo "Problem $(problem) reporting for duty"; \
	echo "  Number of iterations calculated: $$(ls output/done/done-*.txt 2>/dev/null | wc -l)"; \
	echo ""
