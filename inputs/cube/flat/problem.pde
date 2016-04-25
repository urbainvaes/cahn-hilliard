// Initial condition
func phi0 = (z > Lz/2 ? -1 : 1);
func mu0 = 0;
[phi, mu] = [phi0, mu0];

// Boundary conditions
varf varBoundary([phi1,mu1], [phi2,mu2]) =
  int2d(Th,3)(-20*mu2) 
;

varf varBoundaryRHS([phi1,mu1], [phi2,mu2]) =
  on(1,phi1=-1)
;
