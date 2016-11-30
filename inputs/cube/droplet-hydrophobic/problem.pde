// Contact angle
real thetaInit = 2*pi/3;
real thetaFinal = pi/3;

// Initial condition
real radius = 0.5*Lz;

real x1 = 0.5*Lx;
real y1 = 0.5*Ly;
real z1 = - radius*cos(thetaInit);
func droplet1 = ((x - x1)^2 + (y - y1)^2 + (z - z1)^2 < radius^2 ? 1 : -1);

func phi0 = droplet1;
func mu0 = 0;
[phi, mu] = [phi0, mu0];

// Boundary conditions
varf varPhiBoundary([phi1,mu1], [phi2,mu2]) =
    int2d(Th,1,2) (wetting(thetaFinal) * mu2)
    + int2d(Th,1,2) (wetting(thetaFinal) * phi1 * phiOld * mu2)
;

// varf varUBoundary(u, unused) = on(1,2,3,4, u = 0);
// varf varVBoundary(v, unused) = on(1,2,3,4, v = 0);
// varf varWBoundary(w, unused) = on(1,2,3,4, w = 0);
// varf varPBoundary(p, unused) = int2d(Th)(0*unused);

// Time step
dt = 0.2 * 1e-3;

// Number of time steps
nIter = 400;

// Parameters for adaptation
hmin = 0.02;
hmax = 0.2;

// Size of the interface
Cn = 0.04;
Pe = 1;
// Re = 1;
// Ca = 1;
