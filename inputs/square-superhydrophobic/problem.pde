// Initial condition
real radius = 0.25*Ly;

real x1 = radius*1.5;
real y1 = radius + yd;
/* func droplet1 = ((x - x1)^2 + (y - y1)^2 < radius^2 && y > 0.1 ? 1 : -1); */
func droplet1 = ((x - x1)^2 + (y - y1)^2 < radius^2 ? 1 : -1);
func phi0 = droplet1;
func mu0 = 0;
[phi, mu] = [phi0, mu0];

// Boundary conditions (Hydrophobic boundaries)
varf varBoundary([phi1,mu1], [phi2,mu2]) =
  int1d(Th,1) (-10*mu2)
;

varf varBoundaryU(u, unused) =
  on(2, u = 2000000*y*(Ly-y)) +  on(1,3,4, u = 0)
;

varf varBoundaryV(v, unused) =
  on(1,2,3,4, v = 0)
;

// Value of epsilon
eps = 0.01;

// Time step 
dt = 8 * eps^4;
/* dt = 1e-6; */
// dt = 0.5e-6;

// Number of iterations
nIter = 2000;
