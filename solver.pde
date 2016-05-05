/// Include auxiliary files and load modules
include "aux/write-mesh.pde"
include "aux/getargs.pde"
include "aux/clock.pde"
include "includes/gmsh.pde"

load "medit"
load "gmsh"
// load "hips_FreeFem"

// Parameters for solver
string ssparams="";

// Process input parameters
int plots      = getARGV("-plot",0);
string output  = getARGV("-out","output");

/// Import the mesh
mesh3 Th;
Th = gmshload3("output/mesh.msh");

/// Declare default parameters

// Cahn-Hilliard parameters
real M       = 1;
real lambda  = 1;
real eps     = 0.01;

// Time parameters
real dt = 8.0*eps^4/M;
real nIter = 300;

/// Define functional spaces
fespace Vh(Th,P1), V2h(Th,[P1,P1]);

Vh phiOld;
V2h [phi, mu];

/// Include problem file
include "problem.pde"

/// Calculate dependent parameters
real eps2 = eps*eps;
real invEps2 = 1./eps2;

/// Define variational formulation
macro Grad(u) [dx(u), dy(u), dz(u)] //EOM

varf varCH([phi1,mu1], [phi2,mu2]) =
  int3d(Th)(
      phi1*phi2/dt
      + M*(Grad(mu1)'*Grad(phi2))
      - mu1*mu2
      + lambda*(Grad(phi1)'*Grad(mu2))
      + lambda*invEps2*0.5*3*phiOld*phiOld*phi1*mu2
      - lambda*invEps2*0.5*phi1*mu2
      )
;

varf varCHrhs([phi1,mu1], [phi2,mu2]) =
  int3d(Th)(
          phiOld*phi2/dt
          + lambda*invEps2*0.5*phiOld*phiOld*phiOld*mu2
          + lambda*invEps2*0.5*phiOld*mu2
          )
;

/// Output file
ofstream foutHeader(output + "/output.msh");

// Write header, nodes and elements
writeHeader(foutHeader);
writeNodes(foutHeader, Vh);
writeElements(foutHeader, Vh, Th);

/// Loop in time

// Open output file
ofstream file("output/thermodynamics.txt");

for(int i = 0; i <= nIter; i++)
{
    real timeStart = tic();

    // Update previous solution
    phiOld = phi;

    // Calculate macroscopic variables
    real freeEnergy  = int3d(Th)   (0.5*lambda*(Grad(phi)'*Grad(phi)) + 0.25*lambda*invEps2*(phi^2 - 1)^2);
    real massPhi     = int3d(Th)   (phi);
    real dissipation = int3d(Th)   (M*(Grad(mu)'*Grad(mu)));

    // Save data to files
    ofstream fo(output + "/output-" + i + ".msh");
    writeHeader(fo); write1dData(fo, "Cahn-Hilliard", i*dt, i, phiOld);

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
        medit("Phi",Th,phi,wait=true);
        medit("Mu",Th,mu,wait=true);
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

    cout << endl
         << "** TIME OF COMPUTATIONS **         " << endl
         << "Calculation of matrix              " << timeMatrix          << endl
         << "Calculation of the right-hand side " << timeRhs             << endl
         << "Solution  of the linear system     " << timesolution        << endl
         << "Total time spent in iteration      " << clock() - timeStart << endl;
}
