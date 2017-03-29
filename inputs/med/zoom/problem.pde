// Dimensionless numbers
Pe = 500;
Cn = 5e-3;
Re = 1;
We = 1;
hmin = 1e-3;
hmax = .05;

dt = 1e-3;
nIter = 1e4;

func phi0 = (y < 0.4 ? 1 : -1);
func mu0  = 0;
[phi, mu] = [phi0, mu0];

real theta = 30 * (pi/180);
func contactAngles = theta*(label == 10);
real pInlet = 20;

// Define boundary conditions
real radius = 0.5 * (Lx/nPores - topWidth);
real DP = (2*sqrt(2)/3) * (1/radius) * (1/We);
cout << "Pressure difference: " << DP << endl;

varf varPhiBoundary([phi1,mu1], [phi2,mu2]) =
  on (1, phi1 = 1)
  + int1d(Th, 10) (wetting(contactAngles) * mu2)
  + int1d(Th, 10) (wetting(contactAngles) * phi1 * phiOld * mu2)
;
varf varUBoundary(u, test) = on(2,4, u = 0) + on(10, u = 0);
varf varVBoundary(v, test) = on(10, v = 0);
varf varPBoundary(p, test) = on(1, p = pInlet) + on(3, p = 0);
