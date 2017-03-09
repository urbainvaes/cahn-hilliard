// Iteration
dt = 1e-4;
nIter = 1000;

// Dimensionless numbers
Pe = 10;
Cn = 0.02;

// Parameters for adaptation
hmin = 0.02;
hmax = 0.1;

// INITIAL CONDITION
real radius = 0.2*Lx;
real x1 = 0.5*Lx;
real y1 = 0.5*Ly;
real z1 = 0;
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
// real theta0 = pi/6;
real frequency = 4;
real amplitude = pi/6;
real biasX = 0.0;
real biasY = 0.0;
/* func contactAngleFunc = theta0 + amplitude * cos(frequency*pi*(x - biasX)) * cos(frequency*pi*(y - biasY)); */
func contactAngles = theta0 + amplitude * cos(frequency*pi*(x - biasX)) * ((label == 1) + (label == 2));
// func contactAngles = theta0;

// Parameters for input boundary
real massInputByIteration = 0.001;
// real massInputByIteration = 0.0000;
real absMassFlux = massInputByIteration/(dt*pi*r^2);
real massFlux = absMassFlux;

varf varPhiBoundary([phi1,mu1], [phi2,mu2]) =
  // -------------
  // Contact angle
  // -------------
  int2d(Th) (wetting(contactAngles) * mu2)
  + int2d(Th) (wetting(contactAngles) * phi1 * phiOld * mu2)
  //
  // -------------------------
  // Mass flux at the boundary
  // -------------------------
  + int2d(Th,1) (massFlux * phi2)
;

// Create gmsh view for the contact angle
mesh ThSquare; ThSquare = gmshload("square.msh");
fespace VhSquare(ThSquare,P1);
VhSquare contactAngleVh = contactAngles * 180 / pi;
{
  ofstream data("contactAngle.msh");
  writeHeader(data);
  write1dData(data, "ContactAngle", 0, 0, contactAngleVh);

  ofstream ftheta("output/contactAngle.gnuplot");
  for (int ielem=0; ielem<ThSquare.nt; ielem++) {
      for (int j=0; j <3; j++) {
          ftheta << ThSquare[ielem][j].x << " " << ThSquare[ielem][j].y << " " << contactAngleVh[][VhSquare(ielem,j)] << endl;
      }
      ftheta << ThSquare[ielem][0].x << " " << ThSquare[ielem][0].y << " " << contactAngleVh[][VhSquare(ielem,0)] << "\n\n\n";
  }
}
system("./bin/msh2pos square.msh contactAngle.msh");

// PRINT OF DROPLET
VhSquare printPlane;
system("mkdir -p" + " output/print");

{
    ofstream dummy("output/print/lengthPrint.txt");
};
