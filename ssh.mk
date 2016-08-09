# Default target
all :
	ssh uv113@macomp01.ma.ic.ac.uk 'cd cahn-hilliard; \
	qsub -N $(problem) -v problem=$(problem) run_script'

run-live :
	ssh uv113@macomp01.ma.ic.ac.uk 'cd cahn-hilliard; \
		make clean; \
		make remote-mesh host="urbain@155.198.212.221"; \
		make run; \
		make remote-video host="urbain@155.198.212.221";'

#  Run on remote machine
host ?= localhost
remote-% :
	ssh  $(host) "cd cahn-hilliard; make $* problem=$(problem)"
