#define OD2
#define SOLVER_ADAPT
#define DIMENSION 3

#define INIT_VIEW HERE/init_view.geo
#define VIEW      GITROOT/sources/views/3D.geo

#define CONFIG_Lx 1
#define CONFIG_Ly 1
#define CONFIG_Lz 0.5
#define CONFIG_r 0.1*CONFIG_Lx
#define CONFIG_s 0.05

#define   PROBLEM_CONF     HERE/wells.pde
#define   SOLVER_BEFORE   HERE/before.pde
#define   SOLVER_AFTER    HERE/after.pde

#define GEOMETRY GITROOT/sources/geometries/cube/cube.h
