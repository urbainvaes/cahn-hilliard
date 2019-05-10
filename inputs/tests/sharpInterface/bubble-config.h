// General
#define DIMENSION 2

// View
#define VIEW GITROOT/sources/views/2D.geo

// Geometry
#define GEOMETRY_LX 2
#define GEOMETRY_LY 1
#define GEOMETRY_S 0.03
#define GEOMETRY GITROOT/sources/geometries/square/simple-square.geo

// Solver
#define PROBLEM_CONF HERE/bubble.pde
#define SOLVER_POLYNOMIAL_ORDER 1
#define SOLVER_METHOD OD1

// Boundary condition
#define SOLVER_BOUNDARY_CONDITION CUBIC

// Dimensionless numbers
#define SOLVER_PE 1e3

// Adaptation in sapce and time
#define NO_SOLVER_TIME_ADAPTATION
#define SOLVER_MESH_ADAPTATION
#define SOLVER_MESH_ADAPTATION_HMIN 0.001
#define SOLVER_MESH_ADAPTATION_HMAX 0.05

// Time step and number of iterations
#define SOLVER_NITER 1e4
#define SOLVER_CN 1e-2
#define SOLVER_DT 1e-1

// Plot
#define PLOT_FLAGS --extension "pdf" --step 10

// vim: ft=cpp
