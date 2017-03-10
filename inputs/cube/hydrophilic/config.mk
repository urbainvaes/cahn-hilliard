DIMENSION = 3
ADAPT = 1
PLOT = 0
AFTER = 1

# MUMPS = 1
# FF_COMMAND = mpirun -np 1 FreeFem++-mpi
FF_COMMAND = FreeFem++


print :
	gnuplot print.plt
