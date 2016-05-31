// Initial condition
real radius = 15;

real x1 = 0.5*Lx;
real y1 = 0.5*Ly;
real z1 = 0.0*Lz;
func droplet1 = ((x - x1)^2 + (y - y1)^2 + (z - z1)^2 < radius^2 ? 1 : -1);

func phi0 = droplet1;
func mu0 = 0;
[phi, mu] = [phi0, mu0];

epsilon = 0.05*Lx;
dt = 8.0*eps^4/M;

// Boundary conditions
varf varBoundary([phi1,mu1], [phi2,mu2]) =
  int2d(Th,1,2,3,4) (-10*mu2)
;
