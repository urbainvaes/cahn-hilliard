// Compulsory settings
geometry     = GEOMETRY
view         = VIEW


// Dimension of the problem
#ifndef DIMENSION
#define DIMENSION 2
#endif
dimension    = DIMENSION


// Solver configuration
#ifndef SOLVER
#define SOLVER GITROOT/sources/solver.pde
#endif

#ifndef FF_COMMAND
#define FF_COMMAND FreeFem++
#endif

#ifndef FF_FLAGS
#define FF_FLAGS -ne -v 0
#endif
solver       = SOLVER
ff_command   = FF_COMMAND
ff_flags     = FF_FLAGS


// View configuration
#ifndef VIEW_FIELD
#define VIEW_FIELD phi
#endif

#ifndef VIEW_STARTAT
#define VIEW_STARTAT 0
#endif

#ifndef VIEW_STEP
#define VIEW_STEP 1
#endif
view_field   = VIEW_FIELD
view_startat = VIEW_STARTAT
view_step    = VIEW_STEP


// Video configuration
#ifndef VIDEO_FPS
#define VIDEO_FPS 10
#endif
video_fps    = VIDEO_FPS


// Plot configuration

// Defaults
#ifndef PLOT_EXEC
	#if DIMENSION == 2
		#define PLOT_EXEC python3
		#ifndef PLOT_PROGRAM
			#define PLOT_PROGRAM GITROOT/sources/bin/python/plot.py
			#ifndef PLOT_FLAGS
				#define PLOT_FLAGS --parallel --extension "png"
			#endif
		#endif
	#endif
	#if DIMENSION == 3
		#define PLOT_EXEC gmsh
		#ifndef PLOT_PROGRAM
			#define PLOT_PROGRAM view.geo
			#ifndef PLOT_FLAGS
				#define PLOT_FLAGS -display :0 -setnumber video 1
			#endif
		#endif
	#endif
#endif

plot_exec = PLOT_EXEC

#ifndef PLOT_PROGRAM
#define PLOT_PROGRAM
#endif
plot_program = PLOT_PROGRAM

#ifndef PLOT_FLAGS
#define PLOT_FLAGS
#endif
plot_flags = PLOT_FLAGS
