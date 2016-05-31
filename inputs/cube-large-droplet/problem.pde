// Initial condition
real radius = 0.3;

real x1 = 0.5*Lx;
real y1 = 0.5*Ly;
real z1 = 0.5*Lz;
func droplet1 = ((x - x1)^2 + (y - y1)^2 + (z - z1)^2 < radius^2 ? 1 : -1);

func phi0 = droplet1;
func mu0 = 0;
[phi, mu] = [phi0, mu0];

// Boundary conditions
varf varBoundary([phi1,mu1], [phi2,mu2]) =
  int2d(Th,1,2,3,4) (-5*mu2)
;

varf varBoundaryU(u, unused) =
  on(1,2,3,4, u = 0);
;

varf varBoundaryV(v, unused) =
  on(1,2,3,4, v = 0);
;

varf varBoundaryW(w, unused) =
  on(1,2,3,4, w = 0);
;

// Value of epsiblon
eps = 0.05;

// Time step
dt = 1e-6;

// Number of iterations
nIter = 400;
