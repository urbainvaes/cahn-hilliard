dt = 1e-3;
nIter = 1e4;
// muGradPhi = 1;

hmin = 0.005;
hmax = 0.05;

Pe = 500;
Re = 1;
We = 1;
Cn = .01;

real theta = 2*pi/3;
real r = 0.3;
real a = 1;
real b = 1;
func phi0 = -tanh((sqrt(a*(x-0.5)*(x-0.5) + b*(y + cos(theta)*r)*(y + cos(theta)*r)) - r)/Cn);
func mu0  = 0;
[phi, mu] = [phi0, mu0];

// Define boundary conditions
func contactAngles = theta;
varf varPhiBoundary([phi1,mu1], [phi2,mu2]) =
  int1d(Th,1) (wetting(contactAngles) * mu2)
  + int1d(Th,1) (wetting(contactAngles) * phi1 * phiOld * mu2)
;

varf varUBoundary(u, test) = on(1, u = 0);
varf varVBoundary(v, test) = on(1, v = 0);
varf varPBoundary(p, test) = on(3, p = 0);

cout << "Expected pressure: " << 2*sqrt(2)/3/r << endl;
