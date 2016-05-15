/// Include auxiliary files and load modules
include "freefem/write-mesh.pde"
include "freefem/getargs.pde"
include "freefem/clock.pde"
include "geometry.pde"

load "gmsh"

#if DIMENSION == 2
load "metis";
load "iovtk";
#endif

#if DIMENSION == 3
load "medit"
#endif

// Parameters for solver
string ssparams="";

// Process input parameters
int adapt      = getARGV("-adapt",0);
int plots      = getARGV("-plot",0);

/// Import the mesh
#if DIMENSION == 2
mesh Th;
Th = gmshload("output/mesh.msh");
#endif

#if DIMENSION == 3
mesh3 Th;
Th = gmshload3("output/mesh.msh");
#endif

/// Declare default parameters

// Cahn-Hilliard parameters
real M       = 1;
real lambda  = 1;
real eps     = 0.01;

// Time parameters
real dt = 8.0*eps^4/M;
real nIter = 300;

// Mesh parameters
real meshError = 1.e-2;
real hmax = 0.1;
real hmin = hmax / 100;

/// Define functional spaces
#if DIMENSION == 2
    fespace Vh(Th,P2), V2h(Th,[P2,P2]);
#endif

#if DIMENSION == 3
fespace Vh(Th,P1), V2h(Th,[P1,P1]);
#endif

Vh phiOld;
V2h [phi, mu];

/// Include problem file
include "problem.pde"

/// Calculate dependent parameters
real eps2 = eps*eps;
real invEps2 = 1./eps2;

// Define variational formulation

#if DIMENSION == 2
macro Grad(u) [dx(u), dy(u)] //EOM
#endif

#if DIMENSION == 3
macro Grad(u) [dx(u), dy(u), dz(u)] //EOM
#endif

#define AUX_INTEGRAL(dim) int ## dim ## d
#define INTEGRAL(dim) AUX_INTEGRAL(dim)
varf varCH([phi1,mu1], [phi2,mu2]) =
  INTEGRAL(DIMENSION)(Th)(
    phi1*phi2/dt
    + M*(Grad(mu1)'*Grad(phi2))
    - mu1*mu2
    + lambda*(Grad(phi1)'*Grad(mu2))
    + lambda*invEps2*0.5*3*phiOld*phiOld*phi1*mu2
    - lambda*invEps2*0.5*phi1*mu2
    )
;

varf varCHrhs([phi1,mu1], [phi2,mu2]) =
  INTEGRAL(DIMENSION)(Th)(
    phiOld*phi2/dt
    + lambda*invEps2*0.5*phiOld*phiOld*phiOld*mu2
    + lambda*invEps2*0.5*phiOld*mu2
    )
;

#if DIMENISON == 3
/// Output file
ofstream foutHeader("output/output.msh");

// Write header, nodes and elements
writeHeader(foutHeader);
writeNodes(foutHeader, Vh);
writeElements(foutHeader, Vh, Th);
#endif

/// Loop in time

// Open output file
ofstream file("output/thermodynamics.txt");

for(int i = 0; i <= nIter; i++)
{
  real timeStart = tic();

  // Update previous solution
  phiOld = phi;

  // Calculate macroscopic variables
  real freeEnergy  = INTEGRAL(DIMENSION)(Th)   (0.5*lambda*(Grad(phi)'*Grad(phi)) + 0.25*lambda*invEps2*(phi^2 - 1)^2);
  real massPhi     = INTEGRAL(DIMENSION)(Th)   (phi);
  real dissipation = INTEGRAL(DIMENSION)(Th)   (M*(Grad(mu)'*Grad(mu)));

  // Save data to files
  #if DIMENSION == 2
  savevtk("output/phi."+i+".vtk", Th, phi, dataname="PhaseField");
  savevtk("output/mu."+i+".vtk",  Th, mu,  dataname="ChemicalPotential");
  #endif
  #if DIMENSION == 3
  ofstream fo("output/output-" + i + ".msh");
  writeHeader(fo); write1dData(fo, "Cahn-Hilliard", i*dt, i, phiOld);
  #endif

  file << i*dt           << "    "
    << freeEnergy     << "    "
    << massPhi        << "    "
    << dt*dissipation << "    " << endl;

  // Print variables at current iteration
  cout << endl
    << "** ITERATION **"      << endl
    << "Time = "              << i*dt                        << endl
    << "Iteration = "         << i                           << endl
    << "Mass = "              << massPhi                     << endl
    << "Free energy bulk = "  << freeEnergy                  << endl;

  // Visualize solution at current time step
  if (plots)
  {
    #if DIMENSION == 2
    plot(phi, wait=true, fill=true);
    plot(Th, wait=true);
    #endif
    #if DIMENSION == 3
    medit("Phi",Th,phi,wait=true);
    medit("Mu",Th,mu,wait=true);
    #endif
  }

  // Exit if required
  if (i == nIter) break;

  // Calculate of the matrix
  matrix matVolume = varCH(V2h, V2h);
  matrix matBoundary = varBoundary(V2h, V2h);
  matrix matCH = matVolume + matBoundary;
  real timeMatrix = tic();

  // Calculate the right-hand side
  real[int] rhsVolume = varCHrhs(0, V2h);
  real[int] rhsBoundary = varBoundary(0, V2h);
  real[int] rhsCH = rhsVolume + rhsBoundary;
  real timeRhs = tic();

  // Set solver for linear system
  set(matCH,solver=sparsesolver);
  real timeSetSolver = tic();

  // Calculate the solution
  phi[] = matCH^-1*rhsCH;
  real timesolution = tic();

  #if DIMENSION == 2
  if (adapt)
  {
    Th = adaptmesh(Th, phi, mu, err = meshError, hmax = hmax, hmin = hmin);
    [phi, mu] = [phi, mu];
  }
  #endif

  cout << endl
    << "** TIME OF COMPUTATIONS **         " << endl
    << "Calculation of matrix              " << timeMatrix          << endl
    << "Calculation of the right-hand side " << timeRhs             << endl
    << "Solution  of the linear system     " << timesolution        << endl
    << "Total time spent in iteration      " << clock() - timeStart << endl;
}
