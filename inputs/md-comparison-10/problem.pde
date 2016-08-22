// Initial condition
real radius = 15.0/70.0*Lx;

real x1 = 0.5*Lx;
real y1 = 0.5*Ly;
real z1 = 0.0*Lz;
func droplet1 = ((x - x1)^2 + (y - y1)^2 + (z - z1)^2 < radius^2 ? 1 : -1);

func phi0 = droplet1;
func mu0 = 0;
[phi, mu] = [phi0, mu0];

eps = 0.03;
dt = 1e-6;

// Boundary conditions
varf varPhiBoundary([phi1,mu1], [phi2,mu2]) =
  int2d(Th,1) (10*mu2)
;
