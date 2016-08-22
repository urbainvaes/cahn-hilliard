// Initial condition
real radius = 0.2*Lx;

real x1 = 0.5*Lx + radius*1.1;
real y1 = 0.5*Ly;
func droplet1 = ((x - x1)^2 + (y - y1)^2 < radius^2 ? 1.5 : -0.5);

real x2 = 0.5*Lx - radius*1.1;
real y2 = 0.5*Ly;
func droplet2 = ((x - x2)^2 + (y - y2)^2 < radius^2 ? 1.5 : -0.5);

func phi0 = droplet1 + droplet2;
func mu0 = 0;
[phi, mu] = [phi0, mu0];

// Boundary conditions
varf varPhiBoundary([phi1,mu1], [phi2,mu2]) =
  int2d(Th,1) (-0*mu2)
;

varf varBoundaryU(u, unused) =
  on(1,2, u = 0);
;

varf varBoundaryV(v, unused) =
  on(1,2, v = 0);
;

// Interface thickness
eps = 0.01;

// Time step
dt = 0.5e-6;

// Number of iterations
nIter = 1000;
