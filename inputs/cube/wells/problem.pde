// Iteration
dt = 1e-4;
nIter = 100;

// Dimensionless numbers
Pe = 10;
Cn = 0.02;

// Parameters for adaptation
hmin = 0.02;
hmax = 0.1;

// INITIAL CONDITION
real radius = 0.2*Lx;
real x1 = 0.5*Lx;
real y1 = 0.5*Ly;
real z1 = 0;
func droplet1 = - tanh((sqrt((x - x1)^2 + (y - y1)^2 + (z - z1)^2) - radius)/Cn);
func phi0 = droplet1;

// func phi0 = 0;
func mu0 = 0;
[phi, mu] = [phi0, mu0];

// Initial mass
real massPhiInit = int3d(Th) ((phi + 1.)/2.);
real massPhi1 = massPhiInit;

// BOUNDARY CONDITIONS

// Space-dependent contact-angle
real theta0 = pi/2;
real frequencyX = 4;
real frequencyY = 4;
real amplitude = pi/6;
real biasX = 0.0;
real biasY = 0.0;
func contactAngles = theta0 + amplitude * cos(frequencyX*pi*(x - biasX)) * cos(frequencyY*pi*(y - biasY)) * ((label == 1) + (label == 2));

// Parameters for input boundary
real massInputByIteration = 0.0001;
real absMassFlux = massInputByIteration/(dt*pi*r^2);
real massFlux = absMassFlux;

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
  + int2d(Th,1) (massFlux * phi2)
;

#include "common.pde"
