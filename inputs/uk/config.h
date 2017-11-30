#define GEOMETRY GITROOT/sources/geometries/misc/uk.geo
#define VIEW GITROOT/sources/views/2D.geo

#define OD2
/* #define SOLVER_ADAPT */
#define SOLVER_TIMEADAPT
#define DIMENSION 2

#define SOLVER_POLYNOMIAL_ORDER 2
#define PROBLEM_CONF HERE/problem.pde
#define SOLVER_MAX_DELTA_E 0.1
#define SOLVER_MIN_DELTA_E 0.05
#define SOLVER_NITER 100e3
#define SOLVER_ANGLE pi/4
#define SOLVER_PE 1e4
#define SOLVER_CN 1e-2
#define SOLVER_DT 2*Pe*Cn^4
#define SOLVER_HMIN 0.05
#define SOLVER_HMAX 0.5

// Flags for plots
#define PLOT_FLAGS --parallel --extension "png" --step 100
