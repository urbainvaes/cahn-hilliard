// Define initial conditions
real ix = GEOMETRY_LX/2;
real phiL = -2;
real phiR = -2.1;
func phi0 = phiL + (phiR - phiL) * (tanh((x-ix)/(sqrt(2)*Cn))+1)/2;
func mu0 = 0;
[phi, mu] = [phi0, mu0];

// Define boundary conditions

/* FIXME: Can't impose boundary condition only on one label (urbain, Wed 20 Dec 2017 10:39:56 PM CET) */
func contactAngles = pi/3;
