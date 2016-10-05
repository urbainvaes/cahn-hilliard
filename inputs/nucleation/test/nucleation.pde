// Initial condition
func phi0 = 0.1;
func mu0 = 0;
[phi, mu] = [phi0, mu0];

// Boundary conditions (Hydrophobic boundaries)
varf varPhiBoundary([phi1,mu1], [phi2,mu2]) =
  int1d(Th,1,3) (0*mu2)
;

// Time step
dt = 1e-2;

// Number of iterations
nIter = 4000;

Pe = 1;
Cn = 5e-2;
