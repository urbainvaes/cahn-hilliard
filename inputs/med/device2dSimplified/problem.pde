func phi0 = (x > 5.71 && x < 6.51 ? -1 : 1);
func mu0  = 0;
[phi, mu] = [phi0, mu0];

// Define boundary conditions
real theta = 5*pi/12;
// real theta = 0;

real amplitudeInput = 1;
real pulsePeriod = 2;

varf varPhiBoundary([phi1,mu1], [phi2,mu2]) =
  on (1, phi1 = amplitudeInput)
  + int1d(Th,4,5,6) (wetting(theta) * mu2)
  + int1d(Th,4,5,6) (wetting(theta) * phi1 * phiOld * mu2)
;

varf varUBoundary(u, test) = on(4, 5, 6, u = 0);
varf varVBoundary(v, test) = on(4, 5, 6, v = 0);
varf varPBoundary(p, test) = on(1, p = 100) + on(2, p = 0) + on(3, p = 0);

// Time step
dt = 1e-1;

// Number of iterations
nIter = 1e4;

// Capillary term
muGradPhi = 1;

// Parameters for adaptation
// hmin = 0.001;
hmin = 0.05;
hmax = 0.5;

// Dimensionless numbers
Re = 1;
Pe = 200;
We = 200;
// Cn = 0.01;
Cn = 0.05;
