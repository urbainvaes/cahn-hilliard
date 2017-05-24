// Dimensionless numbers
Pe = 10000;
Cn = 5e-3;
Re = 1;
We = 1;
hmin = 1e-3;
hmax = .05;

dt = 1e-4;
nIter = 1e5;

func phi0 = (y < 0.5 ? 1 : -1);
func mu0  = 0;
[phi, mu] = [phi0, mu0];

real theta = (180 - 40) * (pi/180);
func contactAngles = theta*(label == 4);

// Define boundary conditions
real radius = 0.1;
real DP = (2*sqrt(2)/3) * (cos(pi - theta)/radius) * (1/We);
cout << "Pressure difference: " << DP << endl;
real pInlet = DP;

varf varPhiBoundary([phi1,mu1], [phi2,mu2]) =
  int1d(Th, 4) (wetting(contactAngles) * mu2)
  + int1d(Th, 4) (wetting(contactAngles) * phi1 * phiOld * mu2)
;
varf varUBoundary(u, test) = on(4, u = 0);
varf varVBoundary(v, test) = on(4, v = 0);
varf varPBoundary(p, test) = on(1, p = 5) + on(2, p = 4) + on(3, p = 0);
