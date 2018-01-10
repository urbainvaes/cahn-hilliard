// Define initial conditions
real ix = GEOMETRY_LX/2;
real phiL = -2;
real phiR = -2.1;
// func phi0 = phiL + (phiR - phiL) * (tanh((x-ix)/(sqrt(2)*Cn))+1)/2;
func phi0 = -10 + 11*sin(4*y);
func mu0 = 0;
[phi, mu] = [phi0, mu0];

// Define boundary conditions
func contactAngles = pi/4 * (label == 4) + pi/2 * (label != 4);
