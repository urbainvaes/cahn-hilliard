real r = 0.25;
real x1 = 0.65;
real x2 = 1.35;
func phi0 = (1-tanh((sqrt((x-x1)*(x-x1) + y*y) - r)/Cn)) +
            (1-tanh((sqrt((x-x2)*(x-x2) + y*y) - r)/Cn)) - 1;
func mu0  = 0;
[phi, mu] = [phi0, mu0];

// Define boundary conditions
real theta = pi/4;
func contactAngles = theta;
varf varPhiBoundary([phi1,mu1], [phi2,mu2]) =
  int1d(Th,1) (wetting(contactAngles) * mu2)
  + int1d(Th,1) (wetting(contactAngles) * phi1 * phiOld * mu2)
;
