// Initial condition
real radius = 0.4*Lx;

real x1 = 0.5*Lx;
/* real y1 = yd; */
/* func droplet1 = ((x - x1)^2 + (y - y1)^2 < radius^2 && y > 0.1 ? 1 : -1); */
real y1 = 0;
func droplet1 = ((x - x1)^2 + (y - y1)^2 < radius^2 ? 1 : -1);
func phi0 = droplet1;
func mu0 = 0;
[phi, mu] = [phi0, mu0];

// Boundary conditions (Hydrophobic boundaries)
varf varPhiBoundary([phi1,mu1], [phi2,mu2]) =
  int1d(Th,1) (0*mu2)
  + int1d(Th,4) (0*mu2)
;

varf varBoundaryU(u, unused) =
  on(1,2,3,4, u = 0)
;

varf varBoundaryV(v, unused) =
  on(1,2,3,4, v = 0)
;

varf varBoundaryW(w, unused) =
  on(1,2,3,4, w = 0)
;

varf varBoundaryPotential(theta, unused) =
  on(1,theta=0) + on(4,theta=-10)
;

// Value of epsilon
eps = 0.01;

// Time step 
/* dt = 8 * eps^4; */
/* dt = 1e-6; */
dt = 0.5e-6;

// Number of iterations
nIter = 800;
