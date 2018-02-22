// Contact angle
real thetaInit = 2*pi/3;
real thetaFinal = pi/3;

// Define initial conditions
real radius = 0.2;
real x1 = GEOMETRY_LX/2.;
real y1 = - radius*cos(thetaInit);
func phi0 = -tanh((sqrt((x - x1)^2 + (y - y1)^2) - radius)/(sqrt(2)*Cn));
func mu0 = 0;
[phi, mu] = [phi0, mu0];

// Contact angle
func contactAngles = thetaFinal*(label == 1) + (pi/2)*(label != 1);
varf varUBoundary(u, unused) = on(1,2,3,4, u = 0);
varf varVBoundary(v, unused) = on(1,2,3,4, v = 0);
varf varPBoundary(p, unused) = int1d(Th)(0*unused);
