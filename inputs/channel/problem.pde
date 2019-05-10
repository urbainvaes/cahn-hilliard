func phi0 = y > 0 ? 1 : -1;
func mu0  = 0;
[phi, mu] = [phi0, mu0];

real pInlet0 = 2;
real pInlet1 = 4;
real pOutlet = 0;

// func contactAngles = (label == 1 || label == 3) * (pi/3) + (label != 1 && label != 3) * (pi/2)
func contactAngles = CONTACT_ANGLE;

// Define boundary conditions
varf varPhiBoundary([phi1,mu1], [phi2,mu2]) =
  on (4, phi1 = -1) + on (6, phi1 = 1)
  + int1d(Th, 1, 3) (wetting(contactAngles) * mu2)
  + int1d(Th, 1, 3) (wetting(contactAngles) * phi1 * phiOld * mu2)
;

varf varUBoundary(u, unused) = on(1,3,5,7, u = 0);
varf varVBoundary(v, unused) = on(1,3,5,7, v = 0);
varf varPBoundary(p, unused) = on(6, p = pInlet1) + on(4, p = pInlet0) + on(2, p = pOutlet);
