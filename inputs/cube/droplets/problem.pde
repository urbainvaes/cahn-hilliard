// Initial condition
real radius = 0.2*Lx;

real x1 = 0.5*Lx + radius*1.1;
real y1 = 0.5*Ly;
real z1 = 0.5*Lz;
func droplet1 = ((x - x1)^2 + (y - y1)^2 + (z - z1)^2 < radius^2 ? 1.5 : -0.5);

real x2 = 0.5*Lx - radius*1.1;
real y2 = 0.5*Ly;
real z2 = 0.5*Lz;
func droplet2 = ((x - x2)^2 + (y - y2)^2 + (z - z2)^2 < radius^2 ? 1.5 : -0.5);

func phi0 = droplet1 + droplet2;
func mu0 = 0;
[phi, mu] = [phi0, mu0];

// Boundary conditions
varf varBoundary([phi1,mu1], [phi2,mu2]) =
  /* int2d(Th,1) (-20*mu2) + int2d(Th,2) (-20*mu2) + int2d(Th,3) (-20*mu2) + int2d(Th,4) (-20*mu2) */
  int2d(Th,1) (-0*mu2)
;

// Value of epsilon
eps = 0.04;

// Time step and number of iterations
/* dt = 8.0*eps^4/M; */
/* dt = eps^4/M; */
dt = 1 * 1e-6;
nIter = 400;
