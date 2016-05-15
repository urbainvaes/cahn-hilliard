###############################
#  Create mesh from geometry  #
###############################
mesh : output/mesh.msh

output/mesh.msh : geometry.geo problem.geo
	gmsh $< -2 -part 4 -o $@ | tee logs/gmsh.log

###################
#  Run FreeFem++  #
###################
run : output/thermodynamics.txt

includes/gmsh.pde : geometry.geo problem.geo
	grep -h 'export' $^ | sed 's/^/real /' > $@;

output/thermodynamics.txt : solver.pde problem.pde output/mesh.msh includes/gmsh.pde
	mpirun -np 4 FreeFem++-mpi -ne solver.pde -plot 0 -adapt 0 | tee logs/freefem.log


##############
#  Graphics  #
##############
VIDEO = pictures/video.ogv
video : $(VIDEO)

$(VIDEO) : view.py output/thermodynamics.txt
	DISPLAY=:0 pvpython view.py --input phi --video $(VIDEO)

visualization : view.py output/thermodynamics.txt
	DISPLAY=:0 pvpython view.py --input phi
	DISPLAY=:0 pvpython view.py --input mu

view : $(VIDEO)
	DISPLAY=:0 vlc -f $(VIDEO)

plots :
	gnuplot gnuplot/thermo.plt


###################
#  Clean outputs  #
###################
clean :
	rm -rf  pictures/* output/* includes/* logs/*
