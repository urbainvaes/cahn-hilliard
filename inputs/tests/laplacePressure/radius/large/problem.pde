// Define initial conditions

real x1 = 0.5;
real y1 = 0.5;
real radius = 0.4;

func droplet = ((x - x1)^2 + (y - y1)^2 < radius^2 ? 1 : -1);

func phi0 = droplet;
func mu0 = 0;
[phi, mu] = [phi0, mu0];

// Define boundary conditions
varf varPhiBoundary([phi1,mu1], [phi2,mu2]) =
  int1d(Th,1,2) (-0*mu2)
;

varf varUBoundary(u, unused) = on(1,2,3,4, u = 0);
varf varVBoundary(v, unused) = on(1,2,3,4, v = 0);
varf varPBoundary(p, unused) = int1d(Th)(0*unused);

// Time step
dt = 1e-2;

// Number of iterations
nIter = 100;

muGradPhi = 1;
We = 1;
Re = 1;
Pe = 1;
Cn = 5e-3;
