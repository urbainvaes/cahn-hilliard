// General
#define DIMENSION 2

// View
#define VIEW GITROOT/sources/views/2D.geo

// Geometry
#define GEOMETRY_LX 1
#define GEOMETRY_LY 0.5
#define GEOMETRY_S 0.03
#define GEOMETRY GITROOT/sources/geometries/square/simple-square.geo

// Solver
#define PROBLEM_CONF HERE/problem.pde
#define SOLVER_POLYNOMIAL_ORDER 1
#define SOLVER_METHOD OD1
#define SOLVER_NAVIER_STOKES

// Boundary condition
#define SOLVER_BOUNDARY_CONDITION CUBIC

// Dimensionless numbers
#define SOLVER_CN 5e-3;
#define SOLVER_PE 1;
#define SOLVER_RE 1;
#define SOLVER_WE 1;

// Adaptation in sapce and time
#define NO_SOLVER_TIME_ADAPTATION
#define SOLVER_MESH_ADAPTATION
#define SOLVER_MESH_ADAPTATION_HMIN 0.001
#define SOLVER_MESH_ADAPTATION_HMAX 0.05

// Time step and number of iterations
#define SOLVER_NITER 1e4
// #define SOLVER_DT Pe*(energyB/energyA^2)

// vim: ft=cpp
