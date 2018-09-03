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
#define SOLVER_TIME_ADAPTATION
#define SOLVER_TIME_ADAPTATION_METHOD AYMARD
#define SOLVER_TIME_ADAPTATION_FACTOR sqrt(2)
#define SOLVER_TIME_ADAPTATION_TOL_MAX 2e-2
#define SOLVER_TIME_ADAPTATION_TOL_MIN 1e-2
#define SOLVER_TIME_ADAPTATION_DT_OVER_PE_MIN 0
#define SOLVER_TIME_ADAPTATION_DT_OVER_PE_MAX 2.*(energyB/energyA^2)

// Mesh adaptation
#define NO_SOLVER_MESH_ADAPTATION
#define SOLVER_MESH_ADAPTATION_HMIN 0.05
#define SOLVER_MESH_ADAPTATION_HMAX 0.5

// Boundary
#define SOLVER_ANGLE pi/4

// Dimensionless numbers
#define SOLVER_PE 1e4
#define SOLVER_CN 1e-2

#define SOLVER_NITER 100e3
#define SOLVER_DT 2*Pe*(energyB/energyA^2)

// Flags for plots
#define PLOT_FLAGS --nocolorbar --extension "png" --step 1000
