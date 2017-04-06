// Time step dt = .2e-1;
// dt = 0.05;
dt = 1e-2;

// Number of iterations
nIter = 1e5;

// Capillary term
muGradPhi = 1;

// Parameters for adaptation
hmin = 5e-3;
hmax = 1e-1;

// Dimensionless numbers
Re = 1;
We = 1;
Pe = 200;
Cn = 0.01;

// INITIAL CONDITIONS
// func phi0 = 1;
func phi0 = (x > 5.71 && x < 6.51 && y > 16 ? -1 : 1);
func mu0  = 0;
[phi, mu] = [phi0, mu0];

// BOUNDARY CONDITIONS
// real theta = 5*pi/12;
real theta = 40 * pi/180;
real amplitudeInput = 1;
real pulsePeriod = 100000;
real pInlet = 8;
real pCentralOutlet = 0;
real pLateralOutlets = 2;

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
