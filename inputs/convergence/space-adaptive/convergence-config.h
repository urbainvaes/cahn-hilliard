// Load options of tests
#include xstr(HERE/config.common)
#define SPACE_STEP_CONVERGENCE

// Overwrite parameters that need to be
#define SOLVER HERE/../convergence.pde
#define GEOMETRY_S 0.002

#define PLOT_PROGRAM HERE/../plot-convergence.py
#define PLOT_FLAGS -c 'space'

#define N_TESTS 10
