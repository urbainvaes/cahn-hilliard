// Define initial conditions
real radius = 0.2;
real x1 = LX/2.;
real y1 = 0.0;
func droplet = -tanh((sqrt((x-x1)*(x-x1) + y*y) - radius)/(sqrt(2)*Cn));
func phi0 = droplet;
func mu0 = 0;
[phi, mu] = [phi0, mu0];

// Define boundary conditions
func contactAngles = CONTACT_ANGLE;
varf varPhiBoundary([phi1,mu1], [phi2,mu2]) =
  int1d(Th,1) (wetting(contactAngles) * mu2)
  + int1d(Th,1) (wetting(contactAngles) * phi1 * phiOld * mu2)
;
