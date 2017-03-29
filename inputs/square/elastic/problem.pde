dt = 1e-3;
nIter = 1e4;
// muGradPhi = 1;

hmin = 0.005;
hmax = 0.05;

Pe = 500;
Re = 500;
We = 1;
Cn = .01;

real r = 0.2;
real a = 1;
real b = 3;
func phi0 = -tanh((sqrt(a*x*x + b*y*y) - r)/Cn);
func mu0  = 0;
[phi, mu] = [phi0, mu0];

// Define boundary conditions
real theta = 5*pi/12;
func contactAngles = theta;
varf varPhiBoundary([phi1,mu1], [phi2,mu2]) =
  int1d(Th,1) (wetting(contactAngles) * mu2)
  + int1d(Th,1) (wetting(contactAngles) * phi1 * phiOld * mu2)
;

varf varUBoundary(u, test) = on(1, u = 0);
varf varVBoundary(v, test) = on(1, v = 0);
varf varPBoundary(p, test) = on(1, p = 0);
