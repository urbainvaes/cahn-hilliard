func mu0  = 0;

#ifdef PROBLEM_INITIAL_CONDITION_NICE
// Mesh for initial condition
mesh ThInitial = gmshload(xstr(HERE) + "/../mesh_Cn=" + Cn + ".msh");
fespace VhInitial(ThInitial, P1);
VhInitial phi0;
readfreefem(xstr(HERE) + "/../phi_t=0.1_Cn=" + Cn + ".txt", phi0);
[phi, mu] = [phi0, mu0];
real theta = pi/4;
#else
#ifdef PROBLEM_INITIAL_CONDITION_ELLIPSE
real theta = 2*pi/3;
real r = 0.25;
real x1 = 1.;
real ellipseA = 2*r;
real ellipseB = r;
real y1 = ellipseB*sqrt(ellipseB^2/(ellipseA^2+ellipseB^2));
// ellipseA = r;
// y1 = 0;
//                 vvv-- quadratic form                                      vvv--- ||Gradient||
func ellipseWithSlope1AtInterface = ((x-x1)*(x-x1)/ellipseA^2 + (y-y1)*(y-y1)/ellipseB^2 - 1)/(2*sqrt((x-x1)^2/ellipseA^4 + (y-y1)^2/ellipseB^4));
func phi0 = -tanh(ellipseWithSlope1AtInterface/(sqrt(2)*Cn));
[phi, mu] = [phi0, mu0];
#else
real theta = pi/4;
real r = 0.25;
real x1 = 0.65;
real x2 = 1.35;
func phi0 = (1-tanh((sqrt((x-x1)*(x-x1) + y*y) - r)/(sqrt(2)*Cn))) +
            (1-tanh((sqrt((x-x2)*(x-x2) + y*y) - r)/(sqrt(2)*Cn))) - 1;
[phi, mu] = [phi0, mu0];
#endif
#endif

// Define boundary conditions
func contactAngles = theta * (label == 1) + (pi/2.) * (label != 1);
