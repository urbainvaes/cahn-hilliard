func phi0 = (y < 0.3 ? 1 : -1);
func mu0  = 0;
[phi, mu] = [phi0, mu0];

// Define boundary conditions
real theta = pi/3;
varf varPhiBoundary([phi1,mu1], [phi2,mu2]) =
  on (1, phi1 = 0)
  + int1d(Th, 4) (wetting(theta)*mu2)
  + int1d(Th,1) (wetting(theta) * phi1 * phiOld * mu2)
;

varf varUBoundary(u, test) = on(3, 4, 5, u = 0);
varf varVBoundary(v, test) = on(3, 4, 5, v = 0);
varf varWBoundary(w, test) = on(3, 4, 5, w = 0);
varf varPBoundary(p, test) = on(1, p = 500) + on(2, p = 0) + on(3, p = 0);

// Time step
dt = 1e-1;

// Number of iterations
nIter = 1e4;

// Capillary term
muGradPhi = 1;

// Parameters for adaptation
hmin = 0.05;
hmax = 0.5;

// Dimensionless numbers
Re = 1;
Pe = 10;
We = 10;
Cn = 5e-2;
