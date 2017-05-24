// dt        = 1e-3;
// nIter     = 1e5;
// muGradPhi = 0;
// hmin      = 1e-2;
// hmax      = 1e-1;
// Re        = 1;
// We        = 1e-1;
// Pe        = 200;
// Cn        = 1e-2;

dt        = 1e-3;
nIter     = 1e4;
muGradPhi = 0;
hmin      = 5e-3;
hmax      = 5e-2;
Re        = 1;
We        = .1;
Pe        = 500;
Cn        = 1e-2;

// INITIAL CONDITIONS
func phi0 = 1;
func mu0  = 0;
[phi, mu] = [phi0, mu0];

// BOUNDARY CONDITIONS
real theta          = 40 * pi/180;
real signInput      = 1;
real amplitudeInput = 1;
real pulsePeriod    = 4;
real pInlet         = 50;
real pOutlet        = 0;

func contactAngles = theta*((label == 1) + (label == 3));

real a = 1;
real b = 1;
real r = 0.3;

varf varPhiBoundary([phi1,mu1], [phi2,mu2]) =
  // -------------
  // Input
  // -------------
  on (4, phi1 = signInput*amplitudeInput)
  // -------------
  // Contact angle
  // -------------
  + int1d(Th) (wetting(contactAngles) * mu2)
  + int1d(Th) (wetting(contactAngles) * phi1 * phiOld * mu2)
;

varf varUBoundary(u, test) = on(1, 3, u = 0);
varf varVBoundary(v, test) = on(1, 3, v = 0);
varf varPBoundary(p, test) = on(4, p = pInlet) + on(2, p = pOutlet);
