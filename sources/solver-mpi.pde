/// Include auxiliary files and load modules
include "aux/write-mesh.pde"
include "aux/getargs.pde"
include "aux/clock.pde"
include "includes/gmsh.pde"

load "gmsh";
load "metis";
load "iovtk";
load "isoline";
load "MPICG";

int meshAdaptation = getARGV("-adapt",0);
int plots = getARGV("-plot",0);

/// Import the mesh
mesh Th;
if (mpirank == 0)
{
    Th = gmshload("output/mesh.msh");
}
broadcast(processor(0), Th);

//  Assign region to current process
int processRegion = 1000 + mpirank + 1;

/// Declare default parameters

// Cahn-Hilliard parameters
real M = 1;
real lambda = 1;
real eps = 0.01;
real pi = 3.1415926535;
real thetas = pi/2;//range [0,pi]
real S = -1000;//sigma*cos(thetas);

// Time parameters
real dt = 8.0*eps^4/M;
real nIter = 300;

// Mesh parameters
real meshError = 1.e-2;
real hmax = 0.1;
real hmin = hmax / 100;

//Isoline
real[int,int] xy(3,1);
int[int] be(1);
real iso= 0.0 ;
real[int] viso=[iso];

/// Define functional spaces
fespace Vh(Th,P2), V2h(Th,[P2,P2]);
// /* fespace Vh(Th,P1), V2h(Th,[P1,P1]); */

Vh phiOld;
V2h [phi, mu];

/// Include problem file
include "problem.pde"

/// Calculate dependent parameters
real eps2 = eps*eps;
real invEps2 = 1./eps2;
real sigma = (2.*sqrt(2.)/3.)*lambda / eps;

/// Define variational formulation
macro Grad(u) [dx(u), dy(u)] //EOM

varf varCH([phi1,mu1], [phi2,mu2]) =
  int2d(Th, processRegion)(
      phi1*phi2/dt
      + M*(Grad(mu1)'*Grad(phi2))
      - mu1*mu2
      + lambda*(Grad(phi1)'*Grad(mu2))
      + lambda*invEps2*0.5*3*phiOld*phiOld*phi1*mu2
      - lambda*invEps2*0.5*phi1*mu2
      )
;


varf varCHrhs([phi1,mu1], [phi2,mu2]) =
  int2d(Th, processRegion)(
          phiOld*phi2/dt
          + lambda*invEps2*0.5*phiOld*phiOld*phiOld*mu2
          + lambda*invEps2*0.5*phiOld*mu2
          )
;


/// Loop in time

// Open output file
ofstream file("output/thermodynamics.txt");

// Local and global extensive physical variables
real freeEnergyReg, massPhiReg, dissipationReg;
real freeEnergy, massPhi, dissipation;

real timeStart,
     timeMacro,
     timeMatrixRegion,
     timeMatrixTotal,
     timeMatrixSum,
     timeMatrixBc,
     timeRhsRegion,
     timeRhsTotal,
     timeRhsSum,
     timeRhsBc,
     timeFactorization,
     timeSolution;

for(int i = 0; i <= nIter; i++)
{
    timeStart = tic();
    mpiBarrier(mpiCommWorld);

    // Update previous solution
    phiOld = phi;

    // Calculate macroscopic variables
    freeEnergyReg  = int2d(Th,processRegion)   (0.5*lambda*(Grad(phi)'*Grad(phi)) + 0.25*lambda*invEps2*(phi^2 - 1)^2);
    massPhiReg     = int2d(Th,processRegion)   (phi);
    dissipationReg = int2d(Th,processRegion)   (M*(Grad(mu)'*Grad(mu)));

    // Sum contributions of all regions
    mpiAllReduce(freeEnergyReg,  freeEnergy,  mpiCommWorld, mpiSUM);
    mpiAllReduce(massPhiReg,     massPhi,     mpiCommWorld, mpiSUM);
    mpiAllReduce(dissipationReg, dissipation, mpiCommWorld, mpiSUM);
    mpiBarrier(mpiCommWorld);

    real timeMacro = tic();

    if (mpirank == 0)
    {
        // Save data to files
        savevtk("output/phi."+i+".vtk", Th, phi, dataname="PhaseField");
        savevtk("output/mu."+i+".vtk",  Th, mu,  dataname="ChemicalPotential");

        file << i*dt           << "    "
             << freeEnergy     << "    "
             << massPhi        << "    "
             << dt*dissipation << "    " << "    " << endl << endl;

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
            plot(phi, wait=true, fill=true);
            plot(Th, wait=true);
        }
    }

    // Exit if required
    if (i == nIter) break;
    mpiBarrier(mpiCommWorld);

    // Create matrix corresponding to region
    matrix matRegion = varCH(V2h, V2h), matVolume;
    timeMatrixRegion = tic();
    cout << "Time for region: " << timeMatrixRegion << endl;
    mpiBarrier(mpiCommWorld);

    // Sum contributions of all regions
    mpiAllReduce(matRegion,matVolume,mpiCommWorld,mpiSUM);
    timeMatrixSum = tic();
    mpiAllReduce(timeMatrixRegion,timeMatrixTotal,mpiCommWorld,mpiSUM);
    mpiBarrier(mpiCommWorld);

    // Apply boundary conditions
    matrix matBoundary;
    if (mpirank == 0)
    {
        matBoundary = varBoundary(V2h, V2h);
        timeMatrixBc = tic();
    }

    // Add both matrices
    if (mpirank == 0)
    {
        matVolume = matVolume + matBoundary;
    }

    // Set solver for linear system
    if (mpirank == 0)
    {
        set(matVolume,solver=sparsesolver);
        timeFactorization = tic();
    }

    // Calculate right-hand side corresponding to region
    real[int] rhsRegion = varCHrhs(0, V2h), rhsVolume(rhsRegion.n);
    real timeRhsRegion = tic();

    // Add contributions of all regions
    mpiAllReduce(rhsRegion,rhsVolume,mpiCommWorld,mpiSUM);
    real timeRhsSum = tic(), timeRhsTotal;
    mpiAllReduce(timeRhsRegion,timeRhsTotal,mpiCommWorld,mpiSUM);

    // Add contributions of boundary conditions
    if (mpirank == 0)
    {
        real[int] rhsBoundary = varBoundary(0, V2h);
        rhsVolume = rhsVolume + rhsBoundary;
        timeRhsBc = tic();
    }

    // Calculate the solution of the system of equations
    if (mpirank == 0)
        phi[] = matVolume^-1*rhsVolume;

    // Broadcast solution from process zero to all others
    broadcast(processor(0), phi[]);
    timeSolution = tic();

    if (meshAdaptation)
    {
        if (mpirank == 0)
        {
            Th = adaptmesh(Th, phi, mu, err = meshError, hmax = hmax, hmin = hmin);
            [phi, mu] = [phi, mu];
        }
        broadcast(processor(0), Th);
        broadcast(processor(0), phi[]);
    }

    if (mpirank == 0)
    {
        cout << endl
            << "** TIME OF COMPUTATIONS **           " << endl
            << "Matrix: computation of volume terms  " << timeMatrixTotal     << endl
            << "Matrix: sum of contributions         " << timeMatrixSum       << endl
            << "Matrix: boundary conditions          " << timeMatrixBc        << endl
            << "Matrix: factorization                " << timeFactorization   << endl
            << "RHS: computation of volume terms     " << timeRhsTotal        << endl
            << "RHS: assembly                        " << timeRhsSum          << endl
            << "RHS: boundary conditions             " << timeRhsBc           << endl
            << "Solution                             " << timeSolution        << endl
            << "Calculation of physical quantities   " << timeMacro           << endl
            << "Total time spent in process 0        " << clock() - timeStart << endl;
    }

    mpiBarrier(mpiCommWorld);
}
