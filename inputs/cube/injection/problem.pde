// Iteration
dt = 1e-4;
nIter = 1000;

// Dimensionless numbers
Pe = 1;
Cn = 1.5e-2;

// Parameters for adaptation
hmin = 0.1;
hmax = 0.1;


// INITIAL CONDITION
real radius = 0.2*Lx;
real x1 = 0.5*Lx;
real y1 = 0.5*Ly;
real z1 = 0.;
// func droplet1 = ((x - x1)^2 + (y - y1)^2 + (z - z1)^2 < radius^2 ? 1 : -1);
func droplet1 = - tanh((sqrt((x - x1)^2 + (y - y1)^2 + (z - z1)^2) - radius)/Cn);
func phi0 = droplet1;

// func phi0 = 0;
func mu0 = 0;
[phi, mu] = [phi0, mu0];


// Initial mass
real massPhiInit = int3d(Th) ((phi + 1.)/2.);  
real massPhi1 = massPhiInit;

// BOUNDARY CONDITIONS
// Space-dependent contact-angle
real theta0 = pi/2;
real frequency = 4;
real amplitude = pi/6;
real biasX = 0.0;
real biasY = 0.0;
/* func contactAngleFunc = theta0 + amplitude * cos(frequency*pi*(x - biasX)) * cos(frequency*pi*(y - biasY)); */
func contactAngleFunc = theta0 + amplitude * cos(frequency*pi*(x - biasX));

// Parameters for input boundary
real massInputByIteration = 0.0001;
real absMassFlux = massInputByIteration/(dt*pi*r^2);
real massFlux = absMassFlux; 

varf varPhiBoundary([phi1,mu1], [phi2,mu2]) =
  // -------------
  // Contact angle
  // -------------
  int2d(Th,1,2) (wetting(contactAngleFunc) * mu2)
  + int2d(Th,1,2) (wetting(contactAngleFunc) * phi1 * phiOld * mu2)
  //
  // -------------------------
  // Mass flux at the boundary
  // -------------------------
  + int2d(Th,1) (massFlux * phi2)
;

// Create gmsh view for the contact angle
mesh ThSquare; ThSquare = gmshload("square.msh");
fespace VhSquare(ThSquare,P1);
VhSquare contactAngleVh = contactAngleFunc * 180 / pi;
{
  ofstream data("contactAngle.msh");
  writeHeader(data);
  write1dData(data, "ContactAngle", 0, 0, contactAngleVh);
}
system("./bin/msh2pos square.msh contactAngle.msh");
