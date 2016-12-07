func phi0 = (y > 0 ? 1 : -1);
func mu0  = 0;
[phi, mu] = [phi0, mu0];

// Define boundary conditions
varf varPhiBoundary([phi1,mu1], [phi2,mu2]) =
  int1d(Th,3) (0*mu2)
  + int1d(Th,1) (0*mu2)
  + on (4, phi1 = -1)
  + on (6, phi1 = 1);
;

varf varUBoundary(u, unused) = on(1,3,5,7, u = 0);
varf varVBoundary(v, unused) = on(1,3,5,7, v = 0);
varf varPBoundary(p, unused) = on(6, p = 900) + on(4, p = 80) + on(2, p = 0);

// Time step
dt = 1e-2;

// Number of iterations
nIter = 2000;

// Discretization of the capillary term
muGradPhi = 1;

// Dimensionless numbers
Re = 1;
Pe = .25;
We = 0.001;
Cn = 1e-2;

// Mesh
hmax = 0.2;
hmin = 0.02;
