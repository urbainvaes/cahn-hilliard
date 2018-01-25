func mu0  = 0;

#ifdef PROBLEM_NICE_INITIAL_CONDITION
// Mesh for initial condition
mesh ThInitial = gmshload(xstr(HERE) + "/../mesh_Cn=" + Cn + ".msh");
fespace VhInitial(ThInitial, P1);
VhInitial phi0;
readfreefem(xstr(HERE) + "/../phi_t=0.1_Cn=" + Cn + ".txt", phi0);
[phi, mu] = [phi0, mu0];
#else
real r = 0.25;
real x1 = 0.65;
real x2 = 1.35;
func phi0 = (1-tanh((sqrt((x-x1)*(x-x1) + y*y) - r)/(sqrt(2)*Cn))) +
            (1-tanh((sqrt((x-x2)*(x-x2) + y*y) - r)/(sqrt(2)*Cn))) - 1;
[phi, mu] = [phi0, mu0];
#endif

// Define boundary conditions
real theta = pi/4;
func contactAngles = theta;
varf varPhiBoundary([phi1,mu1], [phi2,mu2]) =
  int1d(Th,1) (wetting(contactAngles) * mu2)
  + int1d(Th,1) (wetting(contactAngles) * phi1 * phiOld * mu2)
;
