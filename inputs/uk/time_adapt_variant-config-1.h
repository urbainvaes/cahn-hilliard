#include "./config.common"
#define SOLVER_METHOD OD2
#define SOLVER_TIME_ADAPTATION
#define SOLVER_TIME_ADAPTATION_METHOD AYMARD
#define SOLVER_TIME_ADAPTATION_FACTOR sqrt(2)
#define SOLVER_TIME_ADAPTATION_TOL_MAX 4e-2
#define SOLVER_TIME_ADAPTATION_TOL_MIN 2e-2
#define SOLVER_TIME_ADAPTATION_DT_OVER_PE_MIN 1e-5/Pe
#define SOLVER_TIME_ADAPTATION_DT_OVER_PE_MAX .5/Pe