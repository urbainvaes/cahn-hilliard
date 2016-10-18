###########################
#  Run on remote machine  #
###########################
gitRoot = $(shell git rev-parse --show-toplevel)
problem = $(shell realpath -s --relative-to $(gitRoot)/tests $(CURDIR))
remoteHost ?= uv113@macomp01.ma.ic.ac.uk
remoteRoot ?= /home/ma/u/uv113/cahn-hilliard

script-% :
	echo "#!/bin/bash"                       >  $@
	echo "#PBS -m ae"                        >> $@
	echo "#PBS -q standard"                  >> $@
	echo "#PBS -N $(problem)-$*"             >> $@
	echo "cd $(remoteRoot)/tests/$(problem)" >> $@
	echo "make $(subst _, ,$*)"          >> $@
	chmod +x $@

pbs-% : script-%
	ssh $(remoteHost) "cd $(remoteRoot)/tests/$(problem); qsub $^"

live-% :
	ssh $(remoteHost) "cd $(remoteRoot)/tests/$(problem); make $(subst _, ,$*)"
