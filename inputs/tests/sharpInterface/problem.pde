// Define initial conditions

real theta = 2*pi/3;
real r = 0.25;
real x1 = 1.;
real ellipseA = 2*r;
real ellipseB = r;
// real y1 = ellipseB*sqrt(ellipseB^2/(ellipseA^2+ellipseB^2)); // For the droplet to be on the substrate
real y1 = GEOMETRY_LY/2.;
func ellipseWithSlope1AtInterface = ((x-x1)*(x-x1)/ellipseA^2 + (y-y1)*(y-y1)/ellipseB^2 - 1)/(2*sqrt((x-x1)^2/ellipseA^4 + (y-y1)^2/ellipseB^4));
func phi0 = -tanh(ellipseWithSlope1AtInterface/(sqrt(2)*Cn));
func mu0 = 0;

[phi, mu] = [phi0, mu0];

// Define boundary conditions
func contactAngles = pi/2;
