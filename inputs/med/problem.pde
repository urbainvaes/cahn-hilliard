func phi0 = (y < 0.2 ? 1 : -1);
func mu0  = 0;
[phi, mu] = [phi0, mu0];

// Define boundary conditions
varf varPhiBoundary([phi1,mu1], [phi2,mu2]) =
  on (1, phi1 = 1) + on (3, phi1 = -1)
;

varf varUBoundary(u, test) = on(2,4, u = 0);
varf varVBoundary(v, test) = int1d(Th,1,3) (0*test);
varf varPBoundary(p, test) = on(1, p = 0.1) + on(3, p = 0);

// Time step
dt = 0.5e-2;

// Number of iterations
nIter = 2000;

// Capillary term
muGradPhi = 1;

// Dimensionless numbers
Re = 5;
Pe = 1;
Ca = 10;
Ch = 1e-4;
