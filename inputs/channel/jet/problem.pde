func phi0 = -1;
func mu0  = 0;
[phi, mu] = [phi0, mu0];

// Define boundary conditions
varf varPhiBoundary([phi1,mu1], [phi2,mu2]) =
  on (1, phi1 = -1) + on (6, phi1 = 1);
;

varf varUBoundary(u, unused) = on(2,4,5,7, u = 0);
varf varVBoundary(v, unused) = on(2,4,5,7, v = 0);
varf varPBoundary(p, unused) = on(6, p = 100) + on(1, p = 100) + on(3, p = 0);

// Time step
dt = 1e-2;

// Number of iterations
nIter = 2000;

// Dimensionless numbers
Pe = 100;
Re = 1;
Cn = 5e-2;
We = 10;

hmax = 0.2;
hmin = 0.1;
