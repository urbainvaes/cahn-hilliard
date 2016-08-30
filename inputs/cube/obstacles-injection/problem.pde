// Initial condition
func phi0 = -1;
func mu0 = 0;
[phi, mu] = [phi0, mu0];

// Boundary conditions
varf varPhiBoundary([phi1,mu1], [phi2,mu2]) =
  on(11,phi1=1)
  + on(11,mu1=50)
  + int2d(Th,21) (5*mu2)
  + int2d(Th,22) (-5*mu2)
;

// Value of epsilon
eps = 0.1;

// Value of the time step
dt = 0.3*eps^4/M;
/* dt = 1 * 1e-5; */

// Number of iterations
nIter = 1000;
