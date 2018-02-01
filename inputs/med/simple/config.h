#define GEOMETRY GITROOT/sources/geometries/med/oneSided.geo
#define VIEW GITROOT/sources/views/2D.geo
#define DIMENSION 2

#define SOLVER_MESH_ADAPTATION
#define SOLVER_NAVIER_STOKES

#define SOLVER_METHOD OD1
#define SOLVER_BEFORE HERE/before.pde
#define PROBLEM_CONF HERE/problem.pde
