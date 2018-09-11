// General
#define DIMENSION 2

// View
#define VIEW GITROOT/sources/views/2D.geo

// Geometry
#define GEOMETRY_LX 2
#define GEOMETRY_LY 0.5
#define GEOMETRY GITROOT/sources/geometries/square/simple-square.geo

/************
*  Solver  *
************/

#define SOLVER_METHOD OD2
#define PROBLEM_CONF HERE/problem.pde
#define SOLVER_POLYNOMIAL_ORDER 2
#define SOLVER_BOUNDARY_CONDITION MODIFIED

// Time step and number of iterations
#define SOLVER_NITER 1e6
#define SOLVER_TMAX 400
#define SOLVER_DT 2*Pe*(energyB/energyA^2)

// Dimensionless numbers
#define SOLVER_PE 1e4
#define SOLVER_CN 0.02

// Mesh adaptation
#define SOLVER_MESH_ADAPTATION
#define SOLVER_MESH_ADAPTATION_HMIN 0.002
#define SOLVER_MESH_ADAPTATION_HMAX 0.02

/***********
*  Plots  *
***********/
#define PLOT_FLAGS -e png -p -s 100 -C

// vim: ft=cpp
