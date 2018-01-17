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
/* #define SOLVER_METHOD OD1 */
#define PROBLEM_CONF HERE/problem.pde
#define SOLVER_POLYNOMIAL_ORDER 2
/* #define SOLVER_POLYNOMIAL_ORDER 1 */

// Time step and number of iterations
#define SOLVER_NITER 1e5
#define SOLVER_DT 2*Pe*Cn^4 * 10

// Dimensionless numbers
#define SOLVER_PE 1e4
/* #define SOLVER_CN 0.01 */
#define SOLVER_CN 0.05

// Mesh adaptation
#define SOLVER_ADAPT
/* #define SOLVER_HMIN 0.001 */
#define SOLVER_HMIN 0.005
#define SOLVER_HMAX 0.05

// Time adatpation
#define SOLVER_TIMEADAPT
#define SOLVER_TIME_ADAPTATION_METHOD AYMARD
#define SOLVER_TIME_ADAPTATION_FACTOR 2

#if SOLVER_TIME_ADAPTATION_METHOD == GUILLEN
#define SOLVER_TIME_ADAPTATION_TOL_MIN 1
#define SOLVER_TIME_ADAPTATION_TOL_MAX 100
#endif

#if SOLVER_TIME_ADAPTATION_METHOD == AYMARD
#define SOLVER_TIME_ADAPTATION_TOL_MIN 1e-5
#define SOLVER_TIME_ADAPTATION_TOL_MAX 1e-4
#endif

#define SOLVER_TIME_ADAPTATION_DT_OVER_PE_MIN 0
#define SOLVER_TIME_ADAPTATION_DT_OVER_PE_MAX (SOLVER_DT/Pe)

/***********
*  Plots  *
***********/
#define PLOT_FLAGS -T -e png -p -s 1 -C
