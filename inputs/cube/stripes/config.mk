DIMENSION = 3
GEOMETRY = problem.geo
VIEW = view.geo

ADAPT = 1
PLOT = 0

BEFORE = 1
AFTER = 1

# MUMPS = 1
# FF_COMMAND = mpirun -np 1 FreeFem++-mpi
FF_COMMAND = FreeFem++


print :
	gnuplot print.plt
