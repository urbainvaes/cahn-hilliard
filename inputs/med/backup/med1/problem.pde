func phi0 = 1;
func mu0  = 0;
[phi, mu] = [phi0, mu0];

// Define boundary conditions
// real theta = 5*pi/12;
real theta = pi/2;

real amplitudeInput = 1;
real pulsePeriod = 2;

func contactAngles = pi/2;
varf varPhiBoundary([phi1,mu1], [phi2,mu2]) =
  on (1, phi1 = amplitudeInput)
  + int1d(Th,4,5,6) (wetting(contactAngles) * mu2)
  + int1d(Th,4,5,6) (wetting(contactAngles) * phi1 * phiOld * mu2)
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
hmin = 0.05;
hmax = 0.5;

// Dimensionless numbers
Re = 1;
Pe = 2000;
We = 200;
Cn = 5e-2;
