// Time step
// dt = .2e-1;
// dt = 0.05;
dt = .1;

// Number of iterations
nIter = 1e4;

// Capillary term
muGradPhi = 1;

// Parameters for adaptation
hmin = 0.005;
hmax = 0.1;

// Dimensionless numbers
Re = 1;
Pe = 1000;
We = 10;
Cn = 0.02;

// INITIAL CONDITIONS
// func phi0 = 1;
func phi0 = (x > 5.71 && x < 6.51 ? -1 : 1);
func mu0  = 0;
[phi, mu] = [phi0, mu0];

// BOUNDARY CONDITIONS
// real theta = 5*pi/12;
real theta = 30 * pi/180;
real amplitudeInput = 1;
real pulsePeriod = 2;
real pInlet = 10;
real pCentralOutlet = -5;
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
