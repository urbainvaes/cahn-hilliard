real radius = 0.3;

real x1 = Lx/2;
real y1 = 0.0;
func droplet1 = ((x - x1)^2 + (y - y1)^2 < radius^2 ? 2 : 0);

real x2 = Lx/2;
real y2 = Ly;
func droplet2 = ((x - x2)^2 + (y - y2)^2 < radius^2 ? 2 : 0);

func phi0 = -1 + droplet1;
func mu0 = 0;
[phi, mu] = [phi0, mu0];

// Define boundary conditions
real theta1 = pi/3.;
real wetting1 = (sqrt(2.)/2.)*cos(theta1);

real theta2 = pi/3.;
real wetting2 = (sqrt(2.)/2.)*cos(theta2);

varf varPhiBoundary([phi1,mu1], [phi2,mu2]) =
  int1d(Th,1) (- wetting1 * phi1 * mu2)
  + int1d(Th,1) (wetting1  * mu2)
  /* + int1d(Th,3) (wetting2 * mu2) */
;

// Interface thickness
Ch = 1e-4;
Pe = 0.1;

// Time step
dt = 1e-3;

// Number of iterations
nIter = 4000;
