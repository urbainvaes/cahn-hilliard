// Initial condition
real radius = 0.2*Lx;

real x1 = 0.5*Lx + radius*1.1;
real y1 = 0.5*Ly;
real z1 = 0.5*Lz;
/* real z1 = 0.; */
func droplet1 = ((x - x1)^2 + (y - y1)^2 + (z - z1)^2 < radius^2 ? 1.5 : -0.5);

real x2 = 0.5*Lx - radius*1.1;
real y2 = 0.5*Ly;
real z2 = 0.5*Lz;
/* real z2 = 0.; */
func droplet2 = ((x - x2)^2 + (y - y2)^2 + (z - z2)^2 < radius^2 ? 1.5 : -0.5);

func phi0 = droplet1 + droplet2;
func mu0 = 0;
[phi, mu] = [phi0, mu0];

// Boundary conditions
varf varPhiBoundary([phi1,mu1], [phi2,mu2]) =
  int2d(Th,1) (0*mu2)
;

// Time step and number of iterations
dt = 1e-3;
nIter = 1000;

// Parameters for adaptation
hmin = 0.02;
hmax = 0.2;

// Dimensionless numbers
Pe = 1;
Cn = 2e-2;
