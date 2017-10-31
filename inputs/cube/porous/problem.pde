// Iteration
dt = 1e-3;
nIter = 100000;

// Dimensionless numbers
Pe = 10000;
Cn = 0.02;

// Parameters for adaptation
/* hmin = 0.005; */
hmin = 0.01;
hmax = 0.05;

// INITIAL CONDITION
real radius = 0.2;
real x1 = 0.5;
real y1 = 0.5;
real z1 = 0;
func droplet1 = - tanh((sqrt((x - x1)^2 + (y - y1)^2 + (z - z1)^2) - radius)/Cn);
func phi0 = droplet1;
func mu0  = 0;
[phi, mu] = [phi0, mu0];

// BOUNDARY CONDITIONS

// Space-dependent contact-angle
real delta = 0;
func contactAngles = pi/2 + delta * ((label == 21));

real massFlux = 10;

varf varPhiBoundary([phi1,mu1], [phi2,mu2]) =
  // -------------
  // Contact angle
  // -------------
  int2d(Th) (wetting(contactAngles) * mu2)
  + int2d(Th) (wetting(contactAngles) * phi1 * phiOld * mu2)
  //
  // -------------------------
  // Mass flux at the boundary
  // -------------------------
  + int2d(Th,11) (massFlux * phi2)
;
