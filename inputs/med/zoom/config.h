// General configuration
#define GEOMETRY GITROOT/sources/geometries/misc/i-shape.geo
#define VIEW GITROOT/sources/views/2D.geo
#define DIMENSION 2
#define NS

// General solver options
#define SOLVER_METHOD E1
#define SOLVER_AFTER HERE/after.pde
#define PROBLEM_CONF HERE/problem.pde
#define SOLVER_POLYNOMIAL_ORDER 2

// Mesh adaptation
#define SOLVER_MESH_ADAPTATION
#define SOLVER_MESH_ADAPTATION_HMIN 1e-3
#define SOLVER_MESH_ADAPTATION_HMAX .05

//- Dimensionless numbers
#define SOLVER_PE 10000
#define SOLVER_CN 5e-3
#define SOLVER_RE 1
#define SOLVER_WE 1

// Time step and number of iterations
#define SOLVER_DT 1e-4
#define SOLVER_NITER 1e5
