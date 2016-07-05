// Define initial conditions
real xMiddle = 0.5*Lx;
real yMiddle = Ly;
real thicknessX = 0.4*Lx;
real thicknessY = 0.4*Ly;

func bottom = (y > yMiddle - 0.5*thicknessY ? 1 : 0);
func top    = (y < yMiddle + 0.5*thicknessY ? 1 : 0);
func left   = (x > xMiddle - 0.5*thicknessX ? 1 : 0);
func right  = (x < xMiddle + 0.5*thicknessX ? 1 : 0);

real x1 = 0.5*Lx;
real y1 = 0.5*Ly;
real radius = 0.2*Lx;

func droplet = ((x - x1)^2 + (y - y1)^2 < radius^2 ? 1 : -1);

/* func phi0 = 2 * bottom * top * left * right - 1; */
func phi0 = droplet;
func mu0 = 0;
[phi, mu] = [phi0, mu0];

// Define boundary conditions
varf varBoundary([phi1,mu1], [phi2,mu2]) =
  int1d(Th,1,2) (-0*mu2)
;

varf varBoundaryU(u, unused) =
  on(1,2, u = 0);
;

varf varBoundaryV(v, unused) =
  on(1,2, v = 0);
;

// Interface thickness
eps = 0.1;
/* eps = 0.2; */

// Time step
dt = 1e-6;

// Number of iterations
nIter = 4000;
