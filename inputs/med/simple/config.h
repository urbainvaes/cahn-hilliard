#define GEOMETRY GITROOT/sources/geometries/med/oneSided.geo
#define VIEW GITROOT/sources/views/2D.geo
#define DIMENSION 2

// General solver paraeters
#define SOLVER_DT 0.02
#define SOLVER_NITER 1e6

#define SOLVER_MESH_ADAPTATION
#define SOLVER_MESH_ADAPTATION_HMIN 5e-2
#define SOLVER_MESH_ADAPTATION_HMAX 1e-1

#define SOLVER_NAVIER_STOKES

#define SOLVER_METHOD OD1
#define SOLVER_BEFORE HERE/before.pde
#define PROBLEM_CONF HERE/problem.pde

#define SOLVER_RE 1
#define SOLVER_WE 2
#define SOLVER_PE 1e2
#define SOLVER_CN 0.05
// #define SOLVER_PE = 100
//

#define PLOT_FLAGS -s 20 -f

// #define SOLVER_RESUME 2900
