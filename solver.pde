/// Include helper files and modules
include "aux/write-mesh.edp"
include "aux/getargs.pde"
include "includes/gmsh.pde"

load "medit"
load "gmsh"
// load "hips_FreeFem"

// Parameters for solver
string ssparams="";

// Process input parameters
int plots = getARGV("-plot",0);
string output = getARGV("-out","output");

// Read variables from .geo file

/// Create and import mesh
mesh3 Th;

if (mpirank == 0)
{
    Th = gmshload3("mesh/mesh.msh");
}
broadcast(processor(0), Th);

// Labels defined in GMSH
// DISK            = 1;
// DISK_COMPLEMENT = 2;
// LATERAL_FACES   = 3;
// OPPOSITE_FACE   = 4;

///  Assign region to current process
int processRegion = mpirank + 1;

/// Specify physical parameters

// Cahn-Hilliard parameters:
real M       = 1;
real lambda  = 1;
real eps     = 0.1;
real eps2    = eps*eps;
real invEps2 = 1./eps2;

//Navier-Stokes parameters
real nuNS  = 1;
real alpha = 10;//range [1:10000]

//Time parameters
int n   = 10;
real dt = 0.5e-6;
real T  = n*dt;

/// Define functional spaces
fespace Vh(Th,P1), V2h(Th,[P1,P1]);

V2h [phi, mu];
V2h [phi2, mu2];
Vh phiOld;

// Initial and boundary conditions
include "problem.pde";


if (mpirank == 0 && plots)
    medit("Phi",Th,phi,wait=0);

/// Define CH problem
// problem CH([phi,mu], [psi,nu]) =

//     // Assemble mass matrix
//     int3d(Th)(
//             phi*psi/dt
//             + M*(dx(mu)*dx(psi) + dy(mu)*dy(psi) + dz(mu)*dz(psi))
//             - eps2*mu*nu
//             + lambda*eps2*(dx(phi)*dx(nu) + dy(phi)*dy(nu) + dz(phi)*dz(nu))
//             + lambda*0.5*3*phiOld*phiOld*phi*nu
//             - lambda*0.5*phi*nu
//             )

//     // Assemble right-hand side
//     + int3d(Th)(
//             - phiOld*psi/dt
//             - lambda*0.5*phiOld*phiOld*phiOld*nu
//             - lambda*0.5*phiOld*nu
//             )

//     // - int2d(Th,1)(-0.5*nu)
//     // - int2d(Th,2)(-20*nu)
//     // - int2d(Th,3)(-20*nu)
//     // - int2d(Th,4)(-20*nu)
//     // Boundary conditions
//       + on(1, phi = 1)
//       + on(1, mu = 5e3)
//     ;

macro Grad(u) [dx(u), dy(u), dz(u)] //EOM

varf varCH([phi1,mu1], [phi2,mu2]) =

  int3d(Th, processRegion)(
      phi1*phi2/dt
      + M*(Grad(mu1)'*Grad(phi2))
      - mu1*mu2
      + lambda*(Grad(phi1)'*Grad(mu2))
      + lambda*invEps2*0.5*3*phiOld*phiOld*phi1*mu2
      - lambda*invEps2*0.5*phi1*mu2
      )
;

varf varCHrhs([phi1,mu1], [phi2,mu2]) =
  int3d(Th, processRegion)(
          phiOld*phi2/dt
          + lambda*invEps2*0.5*phiOld*phiOld*phiOld*mu2
          + lambda*invEps2*0.5*phiOld*mu2
          )
;

real oldclock = 0;
func real tic()
{
    real newclock = clock();
    real deltat = newclock - oldclock;
    oldclock = newclock;
    return deltat;
}

if (mpirank == 0) {
  /// Output file
  ofstream foutHeader(output + "/output.msh");

  // Write header, nodes and elements
  writeHeader(foutHeader);
  writeNodes(foutHeader, Vh);
  writeElements(foutHeader, Vh, Th);
}

ofstream fout(output + "/thermodynamics.txt");

// Local and global extensive physical variables
real massPhiReg, freeEnergyReg, kineticEnergyReg, dissipationReg, freeEnergyWallReg;
real massPhi, freeEnergy, kineticEnergy, dissipation, freeEnergyWall;

for(int i = 0; i < 300; i += 1)
{
    phiOld = phi;

    // Write data to file
    if (mpirank == 0) {
      ofstream fo(output + "/output-" + i + ".msh");
      writeHeader(fo);
      write1dData(fo, "Cahn-Hilliard equation in a cube", i*dt, i, phiOld);
    }

    /* ofstream fo1("phi.txt"); */
    /* fo1 << phi[]; */
    /* ofstream fo2("phiOld.txt"); */
    /* fo2 << phiOld[]; */

    // Update previous solution
    real timeStart = clock();
    phiOld = phi;

    // Create matrix corresponding to region
    matrix matRegionCH = varCH(V2h, V2h);
    real timeMatrixRegion = tic();

    // Sum contributions of all regions
    matrix matCH;
    mpiAllReduce(matRegionCH,matCH,mpiCommWorld,mpiSUM);
    real timeMatrixSum = tic(), timeTotal;
    mpiAllReduce(timeMatrixRegion,timeTotal,mpiCommWorld,mpiSUM);

    // Apply boundary conditions
    if (mpirank == 0)
        matrix matBoundary = varBoundary(V2h, V2h);

    real timeMatrixBc = tic();

    // Add both matrices
    if (mpirank == 0)
        matCH = matCH + matBoundary;
    real timeMatrixAddBC = tic();

    // Set solver for linear system
    if (mpirank == 0)
        set(matCH,solver=sparsesolver,sparams=ssparams);
    real timeSetSolver = tic();

    // matrix fullMatCH = varCHFull(V2h,V2h,solver=sparsesolver);
    // cout << "Time of direct computation of full matrix: " << tic() << endl;;

    // Calculate right-hand side corresponding to region
    real[int] rhsRegionCH = varCHrhs(0, V2h);
    real timeRhsRegion = tic();

    // Add contributions of all regions
    real[int] rhsCH(rhsRegionCH.n);
    mpiAllReduce(rhsRegionCH,rhsCH,mpiCommWorld,mpiSUM);
    real timeRhsSum = tic();

    // Add contributions of boundary conditions
    if (mpirank == 0)
    {
        real[int] rhsBoundary = varBoundary(0, V2h);
        rhsCH = rhsCH + rhsBoundary;
    }
    real timeRhsBc = tic();

    // Calculate the solution fo the system of equations
    if (mpirank == 0)
        phi[] = matCH^-1*rhsCH;

    // Broadcast solution from process zero to all others
    broadcast(processor(0), phi[]);
    real timesolution = tic();

    // Calculate macroscopic variables for each region
    freeEnergyReg     = int3d(Th,processRegion)   (0.5*lambda*(Grad(phi)'*Grad(phi)) + 0.25*lambda*invEps2*(phi^2 - 1)^2);
    massPhiReg        = int3d(Th,processRegion)   (phi);
    dissipationReg    = int3d(Th,processRegion)   (M*(Grad(mu)'*Grad(mu)));

    // Sum contributions of all regions
    mpiAllReduce(freeEnergyReg    , freeEnergy    , mpiCommWorld , mpiSUM);
    mpiAllReduce(massPhiReg       , massPhi       , mpiCommWorld , mpiSUM);
    mpiAllReduce(dissipationReg   , dissipation   , mpiCommWorld , mpiSUM);

    real timemacro = tic();

    if(mpirank == 0)
    {
        // freeEnergyWall = int1d(Th,1) (-fS*phiOld); // To be corrected

        fout << i*dt           << "    "
             << freeEnergy     << "    "
             << massPhi        << "    "
             << dt*dissipation << "    "
             << freeEnergyWall << endl << endl;

        cout << endl
             << "** ITERATION **"      << endl
             << "Time = "              << i*dt                        << endl
             << "Iteration = "         << i                           << endl
             << "Mass = "              << massPhi                     << endl
             << "Free energy bulk = "  << freeEnergy                  << endl
             << "Wall free energy = "  << freeEnergyWall              << endl
             << "Total free energy = " << freeEnergy + freeEnergyWall << endl;

    }
    real timesave = tic();

    mpiBarrier(mpiCommWorld);

    real timeadapt = tic();

    if (mpirank == 0)
    {
        cout << endl
             << "** TIME OF COMPUTATIONS **         " << endl
             << "Matrix: average time for region    " << timeMatrixRegion    << endl
             << "Matrix: total time                 " << timeTotal           << endl
             << "Matrix: assembly                   " << timeMatrixSum       << endl
             << "Matrix: boundary conditions        " << timeMatrixBc        << endl
             << "Matrix: addition                   " << timeMatrixAddBC     << endl
             << "Matrix: factorization              " << timeSetSolver       << endl
             << "RHS: local                         " << timeRhsRegion       << endl
             << "RHS: assembly                      " << timeRhsSum          << endl
             << "RHS: boundary conditions           " << timeRhsBc           << endl
             << "Solution                           " << timesolution        << endl
             << "Log to files                       " << timesave            << endl
             << "Calculation of physical quantities " << timemacro           << endl
             << "Mesh adaptation                    " << timeadapt           << endl
             << "Total time spent in process 0      " << clock() - timeStart << endl;
    }

    if (mpirank == 0 && plots)
        medit("Phi",Th,phi,wait=0);

    mpiBarrier(mpiCommWorld);
}
