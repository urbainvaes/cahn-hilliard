func phi0 = -1;
func mu0  = 0;
[phi, mu] = [phi0, mu0];

// Define boundary conditions
varf varPhiBoundary([phi1,mu1], [phi2,mu2]) =
  on (1, phi1 = 1)
;

varf varUBoundary(u, test) = on(2,4, u = 0);
varf varVBoundary(v, test) = int1d(Th,1,3) (0*test);
varf varPBoundary(p, test) = on(1, p = 0.1) + on(3, p = 0);

// Time step
dt = 2e-4;

// Number of iterations
nIter = 4000;

// Capillary term
muGradPhi = 1;

// Dimensionless numbers
Re = 1;
Pe = 10;
We = 1;
Cn = 1e-2;
