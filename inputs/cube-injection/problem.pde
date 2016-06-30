// Initial condition

real radius = 0.2*Lx;
real x1 = 0.5*Lx;
real y1 = 0.5*Ly;
real z1 = 0.;
func droplet1 = ((x - x1)^2 + (y - y1)^2 + (z - z1)^2 < radius^2 ? 1 : -1);
func phi0 = droplet1;
// func phi0 = 0;
func mu0 = 0;
[phi, mu] = [phi0, mu0];

// Boundary conditions
varf varBoundary([phi1,mu1], [phi2,mu2]) =
  int2d(Th,2) (10*cos(5*pi*x)*cos(5*pi*y)*mu2)
  + on(1,phi1=1) + on(1,mu1=5000)
;

// Value of epsilon
eps = 0.03;

// Value of the time step
dt = eps^4/M;
// dt = 1e-8;

// Number of iterations
nIter = 1000;
nIter = 400;
