func phi0 = (y<-0.4?1:-1); func mu0 = 0;
[phi, mu] = [phi0, mu0];

// Define boundary conditions
varf varBoundary([phi1,mu1], [phi2,mu2]) =
  int1d(Th,3) (0*mu2)
  + int1d(Th,1) (0*mu2)
  /* + int1d(Th,6) (8*phi2) */
  + on (4, phi1 = -1)
  + on (6, phi1 = 1);
;

varf varUBoundary(u, unused) = on(1,3,5,6,7, u = 0);
varf varVBoundary(v, unused) = on(1,3,5,6,7, v = 0);
varf varPBoundary(p, unused) = on(4, p = 40) + on(2, p = 0) + on(6, p = 200);

// Interface thickness
eps = 0.01;

// Time step
dt = 1e-2;
/* dt = 8.0*eps^4/M; */

// Number of iterations
nIter = 2000;

Ca = 10;
Re = 1;
