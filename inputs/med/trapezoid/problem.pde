func phi0 = (y < 0.2 ? 1 : -1);
func mu0  = 0;
[phi, mu] = [phi0, mu0];

// Define boundary conditions
varf varPhiBoundary([phi1,mu1], [phi2,mu2]) =
  on (1, phi1 = 1)
  + int1d(Th, 10) (wetting(pi/2)*mu2)
;

// Dimensionless numbers
Re = 1;
Pe = 1e2;
Ca = 1e-2;
Cn = 1e-2;

real radius = 0.03 + Cn;
real DP = (2*sqrt(2)/3) * (1/R) * (Cn/Ca);
cout << "Pressure difference: " << DP << endl;

varf varUBoundary(u, test) = on(2,4, u = 0) + on(10, u = 0);
varf varVBoundary(v, test) = on(10, v = 0);
varf varPBoundary(p, test) = on(1, p = DP) + on(3, p = 0);

// Time step
dt = .5e-2;

// Number of iterations
nIter = 1e4;

// Capillary term
muGradPhi = 1;
