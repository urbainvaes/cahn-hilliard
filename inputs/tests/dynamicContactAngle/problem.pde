// Contact angle
real thetaInit = 2*pi/3;
real thetaFinal = pi/3;

// Define initial conditions
real radius = 0.2;
real x1 = Lx/2;
real y1 = - radius*cos(thetaInit);
func droplet = ((x - x1)^2 + (y - y1)^2 < radius^2 ? 2 : 0);

func phi0 = -1 + droplet;
func mu0 = 0;
[phi, mu] = [phi0, mu0];

func contactAngles = thetaFinal*(label == 1);

// Define boundary conditions
varf varPhiBoundary([phi1,mu1], [phi2,mu2]) =
  int1d(Th,1) (wetting(contactAngles) * mu2)
  + int1d(Th,1) (wetting(contactAngles) * phi1 * phiOld * mu2)
  /* - int1d(Th,1) (1/Dw*Cn*phi1*phi2/dt) */
  /* - int1d(Th,1) (1/Dw*Cn*convect([UOLDVEC],-dt,phiOld)*phi2/dt) */
;

varf varUBoundary(u, unused) = on(1,2,3,4, u = 0);
varf varVBoundary(v, unused) = on(1,2,3,4, v = 0);
varf varPBoundary(p, unused) = int1d(Th)(0*unused);


// Change values of hmin and hmax

// Time step
dt = 1e-3;

// Number of iterations
nIter = 3000;

// Dimensionless numbers
muGradPhi = 1;
We = 1;
Re = 1;
Pe = 1;
Cn = 5e-3;
