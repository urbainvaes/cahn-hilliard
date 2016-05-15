// Define initial conditions
func phi0 = 0.01;
func mu0 = 0;
[phi, mu] = [phi0, mu0];

// Define boundary conditions
varf varBoundary([phi1,mu1], [phi2,mu2]) =
  int1d(Th,1) (0*mu2)
;

// Interface thickness
eps = 0.01;

// Time step
dt = 8.0*eps^4/M;
/* dt = 1e-6; */

// Number of iterations
nIter = 2000;
