func phi0 = (y < -0.4 ? 1 : -1);
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
varf varPBoundary(p, unused) = on(4, p = 40) + on(2, p = 0) + on(6, p = 200);

// Time step
dt = 1e-2;

// Number of iterations
nIter = 2000;

// Dimensionless numbers
Pe  = 5;
Re1 = 5;
Re2 = 5;
Ch  = 1e-4;
Ca  = .1;
