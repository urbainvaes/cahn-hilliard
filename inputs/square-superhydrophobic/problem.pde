// Initial condition
real radius = 0.3*Ly;

real x1 = radius*1.5;
real y1 = radius + yd;
/* func droplet1 = ((x - x1)^2 + (y - y1)^2 < radius^2 && y > 0.1 ? 1 : -1); */
func droplet1 = ((x - x1)^2 + (y - y1)^2 < radius^2 ? 1 : -1);
func phi0 = droplet1;
func mu0 = 0;
[phi, mu] = [phi0, mu0];

// Boundary conditions (Hydrophobic boundaries)
varf varPhiBoundary([phi1,mu1], [phi2,mu2]) = int1d(Th,1) (-0.2*mu2);// + on(2, phi1 = -1);
varf varUBoundary(u, unused) = on(1,3,4, u = 0);
varf varVBoundary(v, unused) = on(1,3,4, v = 0);
varf varPBoundary(p, unused) = on(2, p = 100) + on(5, p = 0);

// Time step 
dt = 1e-5;

// Number of iterations
nIter = 2000;

// Dimensionless parameters
Ch = 1e-4;
Pe  = 1e-2;
