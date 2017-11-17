#ifndef SOLVER_DT
#define SOLVER_DT 0.001
#endif

#ifndef SOLVER_HMIN
#define SOLVER_HMIN 0.005
#endif

#ifndef SOLVER_HMAX
#define SOLVER_HMAX 10*SOLVER_HMIN
#endif

#ifndef SOLVER_NITER
#define SOLVER_NITER 10
#endif

#ifndef SOLVER_CN
#define SOLVER_CN 5e-3
#endif

dt    = SOLVER_DT;
nIter = SOLVER_NITER;
// muGradPhi = 1;

#ifdef SOLVER_ADAPT
hmin = SOLVER_HMIN;
hmax = SOLVER_HMAX;
#endif

Pe = 500;
Cn = SOLVER_CN;

real r = 0.25;
real x1 = 0.65;
real x2 = 1.35;
func phi0 = (1-tanh((sqrt((x-x1)*(x-x1) + y*y) - r)/Cn)) +
            (1-tanh((sqrt((x-x2)*(x-x2) + y*y) - r)/Cn)) - 1;
func mu0  = 0;
[phi, mu] = [phi0, mu0];

// Define boundary conditions
real theta = pi/4;
func contactAngles = theta;
varf varPhiBoundary([phi1,mu1], [phi2,mu2]) =
  int1d(Th,1) (wetting(contactAngles) * mu2)
  + int1d(Th,1) (wetting(contactAngles) * phi1 * phiOld * mu2)
;
