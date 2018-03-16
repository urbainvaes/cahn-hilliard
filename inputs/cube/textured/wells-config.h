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
#define SOLVER_METHOD OD1
#define SOLVER_OD2MOD_THETA dt
#define SOLVER_POLYNOMIAL_ORDER 1
#define SOLVER_BOUNDARY_CONDITION CUBIC

// Auxiliary files
#define PROBLEM_CONF HERE/wells.pde
#define SOLVER_AFTER HERE/after.pde

// Dimensionless numbers
#define SOLVER_PE 1e4
#define SOLVER_CN 0.05

// Mesh adaptation
#define SOLVER_MESH_ADAPTATION
#define SOLVER_MESH_ADAPTATION_HMIN 0.01
#define SOLVER_MESH_ADAPTATION_HMAX 0.1

// Time step and number of iterations
#define SOLVER_DT 0.01 * (2*Pe*energyB/energyA^2)
#define SOLVER_NITER 1e4

// Time adaptation
#define SOLVER_TIME_ADAPTATION

#define SOLVER_TIME_ADAPTATION_METHOD AYMARD
#define SOLVER_TIME_ADAPTATION_FACTOR sqrt(2)

#if SOLVER_TIME_ADAPTATION_METHOD == AYMARD
#define SOLVER_TIME_ADAPTATION_TOL_MIN 1e-5
#define SOLVER_TIME_ADAPTATION_TOL_MAX 1e-4
#endif

#define SOLVER_TIME_ADAPTATION_DT_OVER_PE_MIN 0
#define SOLVER_TIME_ADAPTATION_DT_OVER_PE_MAX (SOLVER_DT/Pe)*SOLVER_TIME_ADAPTATION_FACTOR^8
