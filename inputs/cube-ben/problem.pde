// Initial condition

real x1 = 0.5*Lx;
real y1 = 0.5*Ly;
real z1 = 1*Lz;
real radius = 0.4*Lx;
func droplet = ((x - x1)^2 + (y - y1)^2 + (z - z1)^2 < radius^2 ? 1 : -1);

func phi0 = droplet;
func mu0 = 0;
[phi, mu] = [phi0, mu0];

// Boundary conditions
varf varBoundary([phi1,mu1], [phi2,mu2]) =
  int2d(Th,12) (30*mu2) + int2d(Th,6) (-50*mu2) + int2d(Th,1,2,3,4,5) (-5*mu2)
;

// Value of epsilon
eps = 0.03;
lambda = 2;

// Value of the time step
/* dt = 0.3*eps^4/M; */
dt = 0.5*eps^4/M;
/* dt =  2e-5; */

// Number of iterations
nIter = 100;
