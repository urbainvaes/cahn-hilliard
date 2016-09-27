real radius = 0.3;

real x1 = Lx/2;
real y1 = 0.0;
func droplet1 = ((x - x1)^2 + (y - y1)^2 < radius^2 ? 2 : 0);

real x2 = Lx/2;
real y2 = Ly;
func droplet2 = ((x - x2)^2 + (y - y2)^2 < radius^2 ? 2 : 0);

func phi0 = -1 + droplet1 + droplet2;
func mu0 = 0;
[phi, mu] = [phi0, mu0];

// Define boundary conditions
real theta = pi/3;
varf varPhiBoundary([phi1,mu1], [phi2,mu2]) =
  int1d(Th,1) (wetting(theta) * mu2)
  + int1d(Th,1) (wetting(theta) * phi1 * phiOld * mu2)
;

// Interface thickness
Cn = 5e-3;
Pe = 1;

// Time step
dt = 1e-4;

// Number of iterations
nIter = 4000;
