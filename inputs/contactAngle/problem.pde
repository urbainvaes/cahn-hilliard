// Define initial conditions
real radius = 0.2;
real x1 = GEOMETRY_LX/2.;
real y1 = 0.0;
func droplet = -tanh((sqrt((x-x1)*(x-x1) + y*y) - radius)/(sqrt(2)*Cn));
func phi0 = droplet;
func mu0 = 0;
[phi, mu] = [phi0, mu0];

// Define boundary conditions
// !! Neutral contact angle in 90 degrees!
func contactAngles = CONTACT_ANGLE * (label == 1) + pi/2 * (label != 1);
