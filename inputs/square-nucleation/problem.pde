// Define initial conditions
/* func flat = (y < 0.4*Ly ? 1 : -1); */
/* func flat = (y < 0.5*Ly + 0.01*Ly*cos(20*pi*x) ? 1 : -1); */
/* func phi0 = 0.01; */

real radius = 0.45*Lx;
real xd = 0.5*Lx;
real yd = 1.4*Ly;
func droplet = ((x - xd)^2 + (y - yd)^2 < radius^2 ? 1 : -1);

func phi0 = droplet;
func mu0 = 0;
[phi, mu] = [phi0, mu0];

// Define boundary conditions
varf varBoundary([phi1,mu1], [phi2,mu2]) =
  int1d(Th,3) (20*mu2) + 
  int1d(Th,1) (-20*mu2)
;

varf varBoundaryPotential(theta, unused) =
  on(1,theta=0) + on(3,theta=0)
;

// Interface thickness
eps = 0.01;

// Time step
dt = 1e-6;
/* dt = 8.0*eps^4/M; */

// Number of iterations
nIter = 2000;
