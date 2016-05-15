// Define initial conditions
// func phi0 = y > 0.1 ? -1 : 1;
func phi0 = -1;
func mu0 = 0;
[phi, mu] = [phi0, mu0];

// Define boundary conditions
varf varBoundary([phi1,mu1], [phi2,mu2]) =
  // int1d(Th,1) (0*mu2)
  on(1,phi1=1) + on(1,mu1=50)
;

// Number of iterations
nIter = 5000;

// Width of the interface
eps = 0.1;

// Time step
dt = eps^4/M;
// dt = 1e-6;
