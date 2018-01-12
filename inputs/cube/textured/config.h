// General
#define DIMENSION 3

// View
#define INIT_VIEW HERE/init_view.geo
#define VIEW GITROOT/sources/views/3D.geo

// Geometry
#define GEOMETRY_LX 1
#define GEOMETRY_LY 1
#define GEOMETRY_LZ 0.5
#define GEOMETRY_R 0.1*GEOMETRY_LX
#define GEOMETRY_S 0.05
#define GEOMETRY GITROOT/sources/geometries/cube/cube.h


/************
*  SOLVER  *
************/
#define SOLVER_METHOD OD2
#define SOLVER_POLYNOMIAL_ORDER 1
#define SOLVER_BOUNDARY_CONDITION CUBIC

// Auxiliary files
#define PROBLEM_CONF HERE/wells.pde
#define SOLVER_AFTER HERE/after.pde

// Dimensionless numbers
#define SOLVER_PE 10000
#define SOLVER_CN 0.02

// Mesh adaptation
#define NO_SOLVER_ADAPT
#define SOLVER_ADAPT
#define SOLVER_HMIN 0.01
#define SOLVER_HMAX 0.05
#define SOLVER_DT 0.0008
#define SOLVER_NITER 1000

// Time adaptation
#define SOLVER_NOTIMEADAPT
