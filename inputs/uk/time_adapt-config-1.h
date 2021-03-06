#include "./config.common"
#define SOLVER_METHOD OD2
#define SOLVER_TIME_ADAPTATION
#define SOLVER_TIME_ADAPTATION_METHOD AYMARD
#define SOLVER_TIME_ADAPTATION_FACTOR sqrt(2)
#define SOLVER_TIME_ADAPTATION_TOL_MAX 4e-2
#define SOLVER_TIME_ADAPTATION_TOL_MIN 2e-2
#define SOLVER_TIME_ADAPTATION_DT_OVER_PE_MIN 0
#define SOLVER_TIME_ADAPTATION_DT_OVER_PE_MAX (SOLVER_DT/Pe)*SOLVER_TIME_ADAPTATION_FACTOR^16*0.99
