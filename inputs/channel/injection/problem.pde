func phi0 = -1;
func mu0  = 0;
[phi, mu] = [phi0, mu0];

real pInlet = 100;
real pOutlet = 0;
func contactAngles = pi/2;

// Define boundary conditions
varf varPhiBoundary([phi1,mu1], [phi2,mu2]) =
  on (4, phi1 = -1) + on (6, phi1 = 1)
  + int1d(Th) (wetting(contactAngles) * mu2)
  + int1d(Th) (wetting(contactAngles) * phi1 * phiOld * mu2)
;

varf varUBoundary(u, unused) = on(1,3,5,7, u = 0);
varf varVBoundary(v, unused) = on(1,3,5,7, v = 0);
varf varPBoundary(p, unused) = on(6, p = pInlet) + on(4, p = pInlet) + on(2, p = pOutlet);
