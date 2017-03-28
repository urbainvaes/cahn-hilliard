// Dimensionless numbers
Pe = 100;
Cn = 1e-2;
Re = 1;
We = 100;
hmin = .01;
hmax = .1;

dt = 1e-2;
nIter = 1e4;

func phi0 = (y < 0.4 ? 1 : -1);
func mu0  = 0;
[phi, mu] = [phi0, mu0];

real theta = 2*pi/3;
func contactAngles = theta*(label == 10);
real pInlet = 20;

// Define boundary conditions
// real radius = 0.5 * (Lx/nPores - topWidth);
// real DP = (2*sqrt(2)/3) * (1/radius) * (Cn/We);
// cout << "Pressure difference: " << DP << endl;

varf varPhiBoundary([phi1,mu1], [phi2,mu2]) =
  on (1, phi1 = 1)
  + int1d(Th, 10) (wetting(contactAngles) * mu2)
  + int1d(Th, 10) (wetting(contactAngles) * phi1 * phiOld * mu2)
;
varf varUBoundary(u, test) = on(2,4, u = 0) + on(10, u = 0);
varf varVBoundary(v, test) = on(10, v = 0);
varf varPBoundary(p, test) = on(1, p = pInlet) + on(3, p = 0);
