// Load options of tests
#include xstr(HERE/config.common)
#define TIME_STEP_CONVERGENCE

#define SOLVER HERE/../convergence.pde
#define PLOT_PROGRAM HERE/../plot-convergence-time.py

#define N_ITERATIONS_COARSE 100
#define N_TESTS 6

// Mesh size to compare solutions on different meshes
#define GEOMETRY_S 0.002
