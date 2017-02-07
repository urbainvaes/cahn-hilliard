func phi0 = (y < 1 ? 1 : -1);
func mu0  = 0;
[phi, mu] = [phi0, mu0];

// Define boundary conditions
real theta = pi/3;
varf varPhiBoundary([phi1,mu1], [phi2,mu2]) =
  on (1, phi1 = 0)
  + int1d(Th,5,4) (wetting(theta)*mu2)
  + int1d(Th,5,4) (wetting(theta) * phi1 * phiOld * mu2)
;

varf varUBoundary(u, test) = on(4, 5, 6, u = 0);
varf varVBoundary(v, test) = on(4, 5, 6, v = 0);
varf varPBoundary(p, test) = on(1, p = 10) + on(2, p = -2) + on(3, p = 0);

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
Pe = 200;
We = 200;
Cn = 5e-2;
