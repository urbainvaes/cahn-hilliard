// General parameters
#define DIMENSION 2

// Geometry
#define GEOMETRY GITROOT/sources/geometries/misc/uk.geo

// View
#define VIEW GITROOT/sources/views/2D.geo

/************
*  SOLVER  *
************/
#define PROBLEM_CONF HERE/problem.pde

#define SOLVER_METHOD OD2
#define SOLVER_POLYNOMIAL_ORDER 2

// Time adaptation
#define SOLVER_TIMEADAPT
#define SOLVER_TIME_ADAPTATION_TOL_MAX 0.1
#define SOLVER_TIME_ADAPTATION_TOL_MIN 0.05

// Mesh adaptation
#define SOLVER_ADAPT
#define SOLVER_HMIN 0.05
#define SOLVER_HMAX 0.5

// Boundary
#define SOLVER_ANGLE pi/4

// Dimensionless numbers
#define SOLVER_PE 1e4
#define SOLVER_CN 1e-2

#define SOLVER_NITER 100e3
#define SOLVER_DT 2*Pe*Cn^4

// Flags for plots
#define PLOT_FLAGS --parallel --extension "png" --step 100
