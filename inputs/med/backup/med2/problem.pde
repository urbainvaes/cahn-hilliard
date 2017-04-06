func phi0 = 1;
func mu0  = 0;
[phi, mu] = [phi0, mu0];

// Define boundary conditions
// real theta = 5*pi/12;
real theta = 0;

real amplitudeInput = 1;
real pulsePeriod = 4;
real pInlet = 20;
real pCentralOutlet = 0;
real pLateralOutlets = 0;

func contactAngles = theta*((label == 4) + (label == 5) + (label == 6));

varf varPhiBoundary([phi1,mu1], [phi2,mu2]) =
  // -------------
  // Input
  // -------------
  on (1, phi1 = amplitudeInput)
  // -------------
  // Contact angle
  // -------------
  + int1d(Th) (wetting(contactAngles) * mu2)
  + int1d(Th) (wetting(contactAngles) * phi1 * phiOld * mu2)
;

varf varUBoundary(u, test) = on(4, 5, 6, u = 0);
varf varVBoundary(v, test) = on(4, 5, 6, v = 0);
varf varPBoundary(p, test) = on(1, p = pInlet) + on(2, p = pCentralOutlet) + on(3, p = pLateralOutlets);

// Time step
dt = 1e-2;

// Number of iterations
nIter = 1e4;

// Capillary term
muGradPhi = 1;

// Parameters for adaptation
hmin = 0.05;
hmax = 0.5;

// Dimensionless numbers
Re = 1;
Pe = 200;
We = 200;
Cn = 5e-2;
