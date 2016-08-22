// Initial condition
real radius = 0.2;

real x1 = 0.5 + radius*1.1;
real y1 = 0.5;
func droplet1 = ((x - x1)^2 + (y - y1)^2 < radius^2 ? 1.5 : -0.5);

real x2 = 0.5 - radius*1.1;
real y2 = 0.5;
func droplet2 = ((x - x2)^2 + (y - y2)^2 < radius^2 ? 1.5 : -0.5);

func phi0 = droplet1 + droplet2;
func mu0 = 0;
[phi, mu] = [phi0, mu0];

// Boundary conditions (Hydrophobic boundaries)
varf varPhiBoundary([phi1,mu1], [phi2,mu2]) =
  int2d(Th,1,2,3,4) (-5*mu2)
;

// Value of epsilon
eps = 0.04;

// Time step
dt = 1 * 1e-6;

// Number of iterations
nIter = 400;
