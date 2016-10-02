###########################
#  Run on remote machine  #
###########################
gitRoot = $(shell git rev-parse --show-toplevel)
problem = $(shell realpath -s --relative-to $(gitRoot)/tests $(CURDIR))
remoteHost ?= localhost
remoteRoot ?= ${HOME}/cahn-hilliard

script-% :
	echo "#!/bin/bash"                       >  $@
	echo "#PBS -m abe"                       >> $@
	echo "#PBS -q standard"                  >> $@
	echo "#PBS -N $(problem)"                >> $@
	echo "cd $(remoteRoot)/tests/$(problem)" >> $@
	echo "make $*"                           >> $@
	chmod +x $@

pbs-% : script-%
	ssh $(remoteHost) "cd $(remoteRoot)/tests/$(problem); qsub $^"

live-% :
	ssh $(remoteHost) "cd $(remoteRoot)/tests/$(problem); make $*"

#############################
#  Targets for convenience  #
#############################
run-live :
	ssh uv113@macomp01.ma.ic.ac.uk 'cd cahn-hilliard; \
		make clean; \
		make remote-mesh host="urbain@155.198.212.221"; \
		make run; \
		make remote-video host="urbain@155.198.212.221";'
