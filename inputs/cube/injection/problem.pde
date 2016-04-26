// Initial condition
func phi0 = -1;
func mu0 = 0;
[phi, mu] = [phi0, mu0];

// Boundary conditions
varf varBoundary([phi1,mu1], [phi2,mu2]) =
  on(1,phi1=1) + on(1,mu1=5000)
;

// Value of epsilon
eps = 0.02;

// Value of the time step
dt = 8*eps^4/M;

// Number of iterations
nIter = 1000;
