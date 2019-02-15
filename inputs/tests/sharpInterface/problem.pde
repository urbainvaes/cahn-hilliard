// Define initial conditions

// real ellipseA = 2*r;
// real ellipseB = r;
// real y1 = ellipseB*sqrt(ellipseB^2/(ellipseA^2+ellipseB^2)); // For the droplet to be on the substrate
// func ellipseWithSlope1AtInterface = ((x-x1)*(x-x1)/ellipseA^2 + (y-y1)*(y-y1)/ellipseB^2 - 1)/(2*sqrt((x-x1)^2/ellipseA^4 + (y-y1)^2/ellipseB^4));
// func phi0 = -tanh(ellipseWithSlope1AtInterface/(sqrt(2)*Cn));
real r = 0.25;
real x1 = 0.76;
real x2 = 1.26;
real y1 = GEOMETRY_LY/2.;
func phi0 = (1-tanh((sqrt((x-x1)*(x-x1) + (y-y1)*(y-y1)) - r)/(sqrt(2)*Cn))) +
            (1-tanh((sqrt((x-x2)*(x-x2) + (y-y1)*(y-y1)) - r)/(sqrt(2)*Cn))) - 1;
func mu0 = 0;

[phi, mu] = [phi0, mu0];

// Define boundary conditions
func contactAngles = pi/2;
