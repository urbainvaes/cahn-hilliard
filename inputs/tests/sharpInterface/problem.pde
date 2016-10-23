// Define initial conditions
real radius = 0.3;

real x1 = Lx/2 - radius;
real y1 = Ly/2;
func droplet1 = ((x - x1)^2 + (y - y1)^2 < radius^2 ? 2 : 0);

real x2 = Lx/2 + radius;
real y2 = Ly/2;
func droplet2 = ((x - x2)^2 + (y - y2)^2 < radius^2 ? 2 : 0);

func phi0 = -1 + droplet1 + droplet2;
func mu0 = 0;
[phi, mu] = [phi0, mu0];

// Define boundary conditions
real theta = pi/2;
varf varPhiBoundary([phi1,mu1], [phi2,mu2]) =
  int1d(Th,1) (wetting(theta) * mu2)
  + int1d(Th,1) (wetting(theta) * phi1 * phiOld * mu2)
;

varf varUBoundary(u, unused) = on(1,2,3,4, u = 0);
varf varVBoundary(v, unused) = on(1,2,3,4, v = 0);
varf varPBoundary(p, unused) = int1d(Th)(0*unused);

// Dimensionless numbers
Ca = 1;
Re = 1;
Pe = 1;
Cn = CAHN;

// Time step
dt = 1e-4;

// Number of iterations
nIter = 5e3 * (1e-2 / Cn);
