#define GEOMETRY GITROOT/sources/geometries/channel/channel.geo
#define VIEW GITROOT/sources/views/2D.geo
#define DIMENSION 2

// General solver paraeters
#define SOLVER_DT 0.02
#define SOLVER_NITER 1e6

#define SOLVER_MESH_ADAPTATION
#define SOLVER_MESH_ADAPTATION_HMIN 2e-3
#define SOLVER_MESH_ADAPTATION_HMAX 5e-2

#define SOLVER_NAVIER_STOKES

#define SOLVER_METHOD OD1
#define PROBLEM_CONF HERE/problem.pde

// Dimensionless numbers
#define SOLVER_PE 5e2
#define SOLVER_RE 1
#define SOLVER_CN 1e-2
#define SOLVER_WE 1

#define PLOT_FLAGS --parallel --step 10 --flow --extension "pdf"
#define CONTACT_ANGLE 2*pi/3
// #define SOLVER_PE = 100

// vim: ft=cpp

