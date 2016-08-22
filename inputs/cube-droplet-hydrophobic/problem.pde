// Initial condition
real radius = 0.5*Lz;

real x1 = 0.5*Lx;
real y1 = 0.5*Ly;
real z1 = 0;
func droplet1 = ((x - x1)^2 + (y - y1)^2 + (z - z1)^2 < radius^2 ? 1 : -1);

func phi0 = droplet1;
func mu0 = 0;
[phi, mu] = [phi0, mu0];

// Boundary conditions
varf varPhiBoundary([phi1,mu1], [phi2,mu2]) =
      int2d(Th,1) (-1*mu2) + int2d(Th,2) (-1*mu2);
;

// Size of the interface
eps = 0.1;

// Time step
dt = 1 * 1e-6;

// Number of time steps
nIter = 300;
