real r = 0.25;
real x1 = 0.65;
real x2 = 1.35;
real initWidth = Cn;
func phi0 = (1-tanh((sqrt((x-x1)*(x-x1) + y*y) - r)/(sqrt(2)*initWidth))) +
            (1-tanh((sqrt((x-x2)*(x-x2) + y*y) - r)/(sqrt(2)*initWidth))) - 1;
func mu0  = 0;
[phi, mu] = [phi0, mu0];

// Define boundary conditions
func contactAngles = CONTACT_ANGLE * (label == 1) +  (pi/2.) * (label != 1);
