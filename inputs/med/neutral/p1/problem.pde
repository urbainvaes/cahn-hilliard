func phi0 = (y < 0.1 ? 1 : -1);
func mu0  = 0;
[phi, mu] = [phi0, mu0];

// Define boundary conditions
varf varPhiBoundary([phi1,mu1], [phi2,mu2]) =
  on (1, phi1 = 1)
  + int1d(Th, 10) (wetting(pi/2)*mu2)
;

varf varUBoundary(u, test) = on(2,4,10, u = 0);
varf varVBoundary(v, test) = on(10, v = 0);
varf varPBoundary(p, test) = on(1, p = 1) + on(3, p = 0);

// Time step
dt = 5e-3;

// Number of iterations
nIter = 1e4;

// Capillary term
muGradPhi = 1;

// Dimensionless numbers
Re = 1;
Pe = 10;
Ca = 10;
Cn = 1e-2; // Decrease
