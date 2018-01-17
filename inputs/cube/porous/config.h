// General
#define DIMENSION 3

// View
#define INIT_VIEW HERE/init_view.geo
#define VIEW GITROOT/sources/views/3D.geo

// Geometry
#define GEOMETRY_S 0.01
#define GEOMETRY GITROOT/sources/geometries/cube/cube-array.h

/************
*  SOLVER  *
************/
#define SOLVER_METHOD OD2
#define PROBLEM_CONF HERE/problem.pde
#define SOLVER_POLYNOMIAL_ORDER 1
#define SOLVER_BOUNDARY_CONDITION MANUAL

// Dimensionless numbers
#define SOLVER_PE 10000
#define SOLVER_CN 0.02

// Mesh adaptation
#define NO_SOLVER_ADAPT
#define SOLVER_ADAPT
#define SOLVER_HMIN 0.01
#define SOLVER_HMAX 0.1
#define SOLVER_DT 1e-3
#define SOLVER_NITER 1000

// Time adaptation
#define SOLVER_NOTIMEADAPT
