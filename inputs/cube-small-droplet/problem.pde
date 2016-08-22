// Initial condition
real radius = 0.1;

real x1 = 0.5*Lx;
real y1 = 0.5*Ly;
real z1 = 0.5*Lz;
func droplet1 = ((x - x1)^2 + (y - y1)^2 + (z - z1)^2 < radius^2 ? 1 : -1);

func phi0 = droplet1;
func mu0 = 0;
[phi, mu] = [phi0, mu0];

// Boundary conditions
varf varPhiBoundary([phi1,mu1], [phi2,mu2]) =
  on(1,phi1=-1) + on(2,phi1=-1) + on(3, phi1=-1) + on(4,phi1 = -1)
;
