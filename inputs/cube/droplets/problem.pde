// Initial condition
real radius = 0.15;

real x1 = 0.5*Lx + 0.2*Lx;
real y1 = 0.5*Ly;
real z1 = 0.5*Lz;
func droplet1 = ((x - x1)^2 + (y - y1)^2 + (z - z1)^2 < radius^2 ? 1.5 : -0.5);

real x2 = 0.5*Lx - 0.2*Lx;
real y2 = 0.5*Ly;
real z2 = 0.5*Lz;
func droplet2 = ((x - x2)^2 + (y - y2)^2 + (z - z2)^2 < radius^2 ? 1.5 : -0.5);

func phi0 = droplet1 + droplet2;
func mu0 = 0;
[phi, mu] = [phi0, mu0];

// Boundary conditions
varf varBoundary([phi1,mu1], [phi2,mu2]) =
  on(1,phi1=-1) + on(2,phi1=-1) + on(3,phi1=-1) + on(4,phi1=-1)
;
