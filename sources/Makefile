######################
#  Useful variables  #
######################

# Root of repository
git_root = $(shell git rev-parse --show-toplevel)

# Directory of configuration file
input_dir  = $(shell readlink -f config.h | xargs dirname)

# Preprocessor f lags
cpp_flags = -P -DGITROOT=$(git_root) -DHERE=$(input_dir) -imacros $(git_root)/sources/macros.h -imacros config.h

bindir    = $(git_root)/sources/bin
problem   = $(CURDIR:$(git_root)/tests/%=%)
label     = $(subst /,_,$(problem))


#########################
#  Include ssh targets  #
#########################
include $(git_root)/sources/ssh.mk


###################################
#  Include problem configuration  #
###################################
config.mk : config.h $(git_root)/sources/defaults.mk
	cpp $(cpp_flags) $(git_root)/sources/defaults.mk > $@

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
	rm -f geometry.geo solver.pde view.geo config.mk
	make config.mk geometry.geo solver.pde view.geo


###############################
#  Create mesh from geometry  #
###############################
mesh : output/mesh.msh

output/mesh.msh : geometry.geo
	gmsh $< -$(dimension) -o $@ | tee logs/gmsh.log


###################
#  Run FreeFem++  #
###################

run : solver.pde output/mesh.msh
	$(ff_command) solver.pde $(ff_flags) | tee logs/freefem.log


##############
#  Graphics  #
##############
plots :
	$(plot_exec) $(plot_program) $(plot_flags) $(label)

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
