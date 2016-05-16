# Default target
all :
	ssh uv113@macomp01.ma.ic.ac.uk "cd micro/cahn-hilliard-3d; qsub -N $(geo)-$(problem) -v geo=$(geo),problem=$(problem) run_script"

run-live :
	ssh uv113@macomp01.ma.ic.ac.uk 'cd micro/cahn-hilliard-3d; make clean; make run; make remote-video host="urbain@155.198.212.223"'

#  Run on remote machine or submit to the math complute cluster queue
host := localhost
remote-% :
	ssh  $(host) "cd micro/cahn-hilliard-3d; make $* geo=$(geo) problem=$(problem)"
