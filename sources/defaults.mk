#ifndef SOLVER
#define SOLVER GITROOT/sources/solver.pde
#endif

#ifndef FF_COMMAND
#define FF_COMMAND FreeFem++
#endif

#ifndef FF_FLAGS
#define FF_FLAGS -ne -v 0
#endif

#ifndef PLOT_FLAGS
#define PLOT_FLAGS --parallel --extension "png"
#endif

#ifndef VIDEO_FPS
#define VIDEO_FPS 10
#endif

#ifndef VIEW_FIELD
#define VIEW_FIELD phi
#endif

#ifndef VIEW_STARTAT
#define VIEW_STARTAT 0
#endif

#ifndef VIEW_STEP
#define VIEW_STEP 1
#endif

dimension    = DIMENSION
geometry     = GEOMETRY
solver       = SOLVER
view         = VIEW

ff_command   = FF_COMMAND
ff_flags     = FF_FLAGS
plot_flags   = PLOT_FLAGS
video_fps    = VIDEO_FPS
view_field   = VIEW_FIELD
view_startat = VIEW_STARTAT
view_step    = VIEW_STEP
