func phi0 = (z < Lz/2 ? 1 : -1);
func mu0  = 0;
[phi, mu] = [phi0, mu0];

// Define boundary conditions
varf varPhiBoundary([phi1,mu1], [phi2,mu2]) =
  on (1, phi1 = 1)
  + int2d(Th, 3, 4, 5) (wetting(pi/2)*mu2)
;

varf varUBoundary(u, test) = on(3, 4, 5, u = 0);
varf varVBoundary(v, test) = on(3, 4, 5, v = 0);
varf varWBoundary(w, test) = on(3, 4, 5, w = 0);
varf varPBoundary(p, test) = on(1, p = 200) + on(2, p = 0);

// Time step
dt = 2e-3;

// Number of iterations
nIter = 1e4;

// Capillary term
muGradPhi = 1;

// Parameters for adaptation
hmin = 0.04;
hmax = 0.2;

// Dimensionless numbers
Re = 1;
Pe = 10;
Ca = 10;
Cn = 2e-2;
