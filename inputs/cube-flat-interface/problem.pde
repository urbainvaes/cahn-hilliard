// Initial condition
func phi0 = (z > Lz/2 ? -1 : 1);
func mu0 = 0;
[phi, mu] = [phi0, mu0];

// Boundary conditions
varf varBoundary([phi1,mu1], [phi2,mu2]) =
  int2d(Th,3)(-2*mu2) 
;

// Number of iterations and time step
eps = 0.1;
/* dt = 8.0*eps^4/M; */
dt = 1 * 1e-6;
nIter = 300;
