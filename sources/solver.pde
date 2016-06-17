/* TODO: Add boundary condition for pressure correction (urbain, Fri 17 Jun 2016 12:08:06 PM BST) */

// Include auxiliary files and load modules {{{
include "freefem/write-mesh.pde"
include "freefem/getargs.pde"
include "freefem/clock.pde"
include "geometry.pde"
//}}}
// Load modules {{{
load "gmsh"

#if DIMENSION == 2
load "metis";
load "iovtk";
#endif

#if DIMENSION == 3
load "medit"
load "mshmet"
load "tetgen"
#endif
//}}}
// Process input parameters {{{
int adapt = getARGV("-adapt",0);
int plot = getARGV("-plot",0);
//}}}
// Import the mesh {{{
#if DIMENSION == 2
#define MESH mesh
#define GMSHLOAD gmshload
#endif

#if DIMENSION == 3
#define MESH mesh3
#define GMSHLOAD gmshload3
#endif

MESH Th; Th = GMSHLOAD("output/mesh.msh");
MESH ThOut; ThOut = GMSHLOAD("output/mesh.msh");
//}}}
// Define functional spaces {{{
#if DIMENSION == 2
fespace Vh(Th,P1), V2h(Th,[P1,P1]);
#endif

#if DIMENSION == 3
fespace Vh(Th,P1), V2h(Th,[P1,P1]);
#endif

// Mesh on which to project solution for visualization
fespace VhOut(ThOut,P1);

// Phase field
V2h [phi, mu];
Vh phiOld;
VhOut phiOut, muOut;

// Adaptation
Vh adaptField;

#ifdef NS
Vh u = 0, v = 0, w = 0, p = 0, q = 0;
Vh uOld, vOld, wOld;
VhOut uOut, vOut, wOut;
#endif

#ifdef ELECTRO
Vh theta;
#endif
//}}}
// Declare default parameters {{{

// Cahn-Hilliard parameters
real M       = 1;
real lambda  = 1;
real eps     = 0.01;

// Navier-Stokes parameters
#ifdef NS
real Re = 0.1;
real Ca = 100;
#endif

#ifdef GRAVITY
real rho1 = -1;
real rho2 = 1;
#endif

// Electric parameters
#ifdef ELECTRO
real epsilonR1 = 1;
real epsilonR2 = 2;
#endif

// Time parameters
real dt = 8.0*eps^4/M;
real nIter = 300;

// Mesh parameters
real meshError = 1.e-2;

#if DIMENSION == 2
real hmax = 0.05;
real hmin = hmax / 64;
#endif

#if DIMENSION == 3
real hmax = 0.1;
real hmin = hmax/5;
#endif
//}}}
// Include problem file {{{
#define xstr(s) str(s)
#define str(s) #s
#include xstr(PROBLEM)
//}}}
// Calculate dependent parameters {{{
real eps2 = eps*eps;
real invEps2 = 1./eps2;

#ifdef GRAVITY
Vh rho = 0.5*(rho1*(1 - phi) + rho2*(1 + phi));
#endif
//}}}
// Define variational formulations {{{

// Macros {{{
#ifdef MPI
int processRegion = 1000 + mpirank + 1;
#endif

#if DIMENSION == 2
macro Grad(u) [dx(u), dy(u)] //EOM
macro Div(u,v) dx(u) + dy(v) //EOM
#define UVEC u, v
#define UOLDVEC uOld, vOld
#endif

#if DIMENSION == 3
macro Grad(u) [dx(u), dy(u), dz(u)] //EOM
macro Div(u,v,w) dx(u) + dy(v) + dz(w) //EOM
#define UVEC u, v, w
#define UOLDVEC uOld, vOld, wOld
#endif

#define AUX_INTEGRAL(dim) int ## dim ## d
#define INTEGRAL(dim) AUX_INTEGRAL(dim)

#ifdef MPI
#define INTREGION Th, processRegion
#else
#define INTREGION Th
#endif
//}}}
// Cahn-Hilliard {{{
varf varCH([phi1,mu1], [phi2,mu2]) =
  INTEGRAL(DIMENSION)(INTREGION)(
    phi1*phi2/dt
    + M*(Grad(mu1)'*Grad(phi2))
    - mu1*mu2
    + lambda*(Grad(phi1)'*Grad(mu2))
    + lambda*invEps2*0.5*3*phiOld*phiOld*phi1*mu2
    - lambda*invEps2*0.5*phi1*mu2
    )
;

varf varCHrhs([phi1,mu1], [phi2,mu2]) =
  INTEGRAL(DIMENSION)(INTREGION)(
    #ifdef NS
    convect([UOLDVEC],-dt,phiOld)/dt*phi2
    #else
    phiOld*phi2/dt
    #endif
    + lambda*invEps2*0.5*phiOld*phiOld*phiOld*mu2
    + lambda*invEps2*0.5*phiOld*mu2
    #ifdef ELECTRO
    + 0.25 * (epsilonR2 - epsilonR1) * (Grad(theta)'*Grad(theta)) * mu2
    #endif
    )
;
//}}}
// Navier-Stokes {{{
#ifdef NS
varf varU(u,test) =
  INTEGRAL(DIMENSION)(Th)(
    u*test/dt + (1/Re)*(Grad(u)'*Grad(test))
    );
varf varUrhs(u,test) =
  INTEGRAL(DIMENSION)(Th)(
    (convect([UOLDVEC],-dt,uOld)/dt-dx(p))*test
    + (1/Ca)*mu*dx(phi)*test
    #ifdef GRAVITY
    + gx*phi*test
    #endif
    );
varf varV(v,test) =
  INTEGRAL(DIMENSION)(Th)(
    v*test/dt + (1/Re)*(Grad(v)'*Grad(test))
    );
varf varVrhs(v,test) =
  INTEGRAL(DIMENSION)(Th)(
    (convect([UOLDVEC],-dt,vOld)/dt-dy(p))*test
    + (1/Ca)*mu*dy(phi)*test
    #ifdef GRAVITY
    + gy*phi*test
    #endif
    );
#if DIMENSION == 3
varf varW(w,test) =
  INTEGRAL(DIMENSION)(Th)(
    w*test/dt +(1/Re)*(Grad(w)'*Grad(test))
    );
varf varWrhs(w,test) =
  INTEGRAL(DIMENSION)(Th)(
    (convect([UOLDVEC],-dt,wOld)/dt-dz(p))*test
    + (1/Ca)*mu*dz(phi)*test
    #ifdef GRAVITY
    + gz*phi*test
    #endif
    );
#endif
#endif
//}}}
// Poisson for electric potential {{{
#ifdef ELECTRO
varf varPotential(theta,test) =
  INTEGRAL(DIMENSION)(Th)(
    0.5*(epsilonR1*(1 - phi) + epsilonR2*(1 + phi))
    * Grad(theta)'*Grad(test)
    )
  ;
#endif
//}}}
//}}}
// Create output file for the mesh {{{
// This is only useful if P2 or higher elements are used.
#if DIMENSION == 3
#endif
//}}}
// Adapt mesh before starting computation {{{
if (adapt)
{
  #if DIMENSION == 3
  system("cp output/mesh.msh output/mesh-init-0.msh");
  for(int i = 0; i < 3; i++)
  {
      {
        Vh metricField;
        metricField[] = mshmet(Th, phi, aniso = 0, hmin = hmin, hmax = hmax, nbregul = 1);
        ofstream bgm("output/mshmet-init-"+i+".msh");
        writeHeader(bgm); write1dData(bgm, "Size field", i*dt, i, metricField);
      }
      system("./bin/msh2pos output/mesh-init-"+i+".msh output/mshmet-init-"+i+".msh");
      system("gmsh -v 0 " + xstr(GEOMETRY) + " -3 -bgm 'output/mshmet-init-"+i+".pos' -o 'output/mesh-init-" + (i + 1) + ".msh'");
      Th = gmshload3("output/mesh-init-" + (i + 1) + ".msh");
      [phi, mu] = [phi0, mu0];

      if(plot)
      {
          medit("Phi", Th, phi, wait = false);
      }
  }
  #endif
}

//}}}
// Loop in time {{{

// Open output file
ofstream file("output/thermodynamics.txt");

// Declare extensive physical variables {{{
real freeEnergy,
     massPhi,
     dissipation;

real timeStart,
     timeMacro,
     timeMatrixBulk,
     timeMatrixBc,
     timeMatrix,
     timeRhsBulk,
     timeRhsBc,
     timeRhs,
     timeFactorization,
     timeSolution;

#ifdef MPI
real freeEnergyReg,
     massPhiReg,
     dissipationReg;

real timeMatrixRegion,
     timeMatrixTotal,
     timeRhsRegion,
     timeRhsTotal;
#endif
//}}}
for(int i = 0; i <= nIter; i++)
{
  // Update previous solution {{{
  timeStart = clock(); tic();
  phiOld = phi;
#ifdef NS
  uOld = u;
  vOld = v;
#if DIMENSION == 3
  wOld = w;
#endif
#endif
  //}}}

  ofstream interface("output/interface."+ i +".xyz");
  for (int j = 0; j<Th.nv ;j++)
  {
      if (abs(phiOld[][j]) < 0.2)
      {
          #if DIMENSION == 2
          interface << "1 " << Th(j).x << " " << Th(j).y << endl;
          #endif

          #if DIMENSION == 3
          interface << "1 " << Th(j).x << " " << Th(j).y << " " << Th(j).z << endl;
          #endif
      }
  }

  // Calculate macroscopic variables {{{
#ifdef MPI
  freeEnergyReg  = INTEGRAL(DIMENSION)(Th, processRegion) (0.5*lambda*(Grad(phi)'*Grad(phi)) + 0.25*lambda*invEps2*(phi^2 - 1)^2);
  massPhiReg     = INTEGRAL(DIMENSION)(Th, processRegion) (phi);
  dissipationReg = INTEGRAL(DIMENSION)(Th, processRegion) (M*(Grad(mu)'*Grad(mu)));

  mpiAllReduce(freeEnergyReg,  freeEnergy,  mpiCommWorld, mpiSUM);
  mpiAllReduce(massPhiReg,     massPhi,     mpiCommWorld, mpiSUM);
  mpiAllReduce(dissipationReg, dissipation, mpiCommWorld, mpiSUM);
#endif

#ifndef MPI
  freeEnergy  = INTEGRAL(DIMENSION)(Th) (
      0.5*lambda*(Grad(phi)'*Grad(phi))
      + 0.25*lambda*invEps2*(phi^2 - 1)^2
#ifdef ELECTRO
      - 0.25 * (epsilonR1*(1 - phi) + epsilonR2*(1 + phi)) * Grad(theta)'*Grad(theta)
#endif
      );
  massPhi     = INTEGRAL(DIMENSION)(Th) (phi);
  dissipation = INTEGRAL(DIMENSION)(Th) (M*(Grad(mu)'*Grad(mu)));
#endif

  timeMacro = tic();
  //}}}
  // Save data to files and stdout {{{
#ifdef MPI
  if (mpirank == 0)
#endif
  {
#if DIMENSION == 2

    savevtk("output/phi."+i+".vtk", Th, phi, dataname="Phase");
    savevtk("output/mu."+i+".vtk",  Th, mu,  dataname="ChemicalPotential");

#ifdef NS
    savevtk("output/velocity."+i+".vtk",Th,[u,v], dataname="Velocity");
#endif

#ifdef ELECTRO
    savevtk("output/potential."+i+".vtk",Th,theta, dataname="Potential");
#endif

#endif

#if DIMENSION == 3
    {
    ofstream currentMesh("output/mesh-" + i + ".msh");
    ofstream data("output/phase-" + i + ".msh");

    if(adapt)
    {
      phiOut = phi;
      muOut  = mu;
#ifdef NS
      uOut = u;
      vOut = v;
      wOut = w;
#endif
      writeHeader(currentMesh);
      writeNodes(currentMesh, Vh);
      writeElements(currentMesh, Vh, Th);

      writeHeader(data);
      write1dData(data, "Cahn-Hilliard", i*dt, i, phiOld);

    }
    else
    {
      writeHeader(data); write1dData(data, "Cahn-Hilliard", i*dt, i, phiOld);
    }
    }
      system("./bin/msh2pos output/mesh-" + i + ".msh output/phase-" + i + ".msh");
    // ! phi[]
#endif

    file << i*dt           << "    "
         << freeEnergy     << "    "
         << massPhi        << "    "
         << dt*dissipation << "    " << endl;

    // Print variables at current iteration
    cout << endl
      << "** ITERATION **"      << endl
      << "Time = "              << i*dt          << endl
      << "Iteration = "         << i             << endl
      << "Mass = "              << massPhi       << endl
      << "Free energy bulk = "  << freeEnergy    << endl;
  }
  //}}}
  // Visualize solution at current time step {{{
  #ifdef MPI
  if (mpirank == 0)
  #endif
  {
    if (plot)
    {
      #if DIMENSION == 2
      plot(phi, fill=true);
      #endif

      #if DIMENSION == 3
      medit("Phi",Th,phi,wait = false);
      #endif
    }
  }
  //}}}
  // Exit if required {{{
  if (i == nIter) break;

  #ifdef MPI
  mpiBarrier(mpiCommWorld);
  #endif

  tic();
  //}}}
  // Poisson for electric potential {{{
#ifdef ELECTRO
  matrix matPotentialBulk = varPotential(Vh, Vh);
  matrix matPotentialBoundary = varBoundaryPotential(Vh, Vh);
  matrix matPotential = matPotentialBulk + matPotentialBoundary;
  real[int] rhsPotential = varBoundaryPotential(0, Vh);
  set(matPotential,solver=sparsesolver);
  theta[] = matPotential^-1*rhsPotential;
#endif
  //}}}
  // Calculate the matrix {{{
  #ifdef MPI
  matrix matRegion = varCH(V2h, V2h);
  timeMatrixRegion = tic();

  matrix matBulk;
  mpiAllReduce(matRegion,matBulk,mpiCommWorld,mpiSUM);
  timeMatrixBulk = timeMatrixRegion + tic();
  mpiAllReduce(timeMatrixBulk,timeMatrixTotal,mpiCommWorld,mpiSUM);

  matrix matCH;
  if (mpirank == 0)
  {
    matrix matBoundary = varBoundary(V2h, V2h);
    timeMatrixBc = tic();

    matCH = matBulk + matBoundary;
    timeMatrix =  timeMatrixBulk + timeMatrixBc + tic();
  }

  // Parameters for solver
  string ssparams="";

  // set(matCH,solver=sparsesolver);
  set(matCH,solver=sparsesolver,sparams=ssparams);
  timeFactorization = tic();
  #endif

  #ifndef MPI
  matrix matBulk = varCH(V2h, V2h);
  timeMatrixBulk = tic();

  matrix matBoundary = varBoundary(V2h, V2h);
  timeMatrixBc = tic();

  matrix matCH = matBulk + matBoundary;
  timeMatrix = timeMatrixBulk + timeMatrixBc + tic();

  set(matCH,solver=sparsesolver);
  timeFactorization = tic();
  #endif
  //}}}
  // Calculate the right-hand side {{{
  #ifdef MPI
  real[int] rhsRegion = varCHrhs(0, V2h);
  timeRhsRegion = tic();

  real[int] rhsBulk(rhsRegion.n);
  mpiAllReduce(rhsRegion,rhsBulk,mpiCommWorld,mpiSUM);
  timeRhsBulk = timeRhsRegion + tic();
  mpiAllReduce(timeRhsBulk,timeRhsTotal,mpiCommWorld,mpiSUM);

  real[int] rhsCH(rhsRegion.n);
  if (mpirank == 0)
  {
    real[int] rhsBoundary = varBoundary(0, V2h);
    timeRhsBc = tic();

    rhsCH = rhsBulk + rhsBoundary;
    timeRhs = timeRhsBulk + timeRhsBc + tic();
  }
  #endif

  #ifndef MPI
  real[int] rhsBulk = varCHrhs(0, V2h);
  timeRhsBulk = tic();

  real[int] rhsBoundary = varBoundary(0, V2h);
  timeRhsBc  = tic();

  real[int] rhsCH = rhsBulk + rhsBoundary;
  timeRhs = timeRhsBulk + timeRhsBc + tic();
  #endif
  //}}}
  // Solve the linear system//{{{
  #ifdef MPI
  if (mpirank == 0)
  #endif
  {
    phi[] = matCH^-1*rhsCH;
    timeSolution = tic();
  }
  #ifdef MPI
  broadcast(processor(0), phi[]);
  #endif
  //}}}
  // Navier stokes {{{
  #ifdef NS
  Vh uOld = u, vOld = v, pold=p;
  #if DIMENSION == 3
  Vh wOld = w;
  #endif
  real vol = INTEGRAL(DIMENSION)(Th)(1.);

  matrix matUBulk = varU(Vh, Vh);
  matrix matUBoundary = varBoundaryU(Vh, Vh);
  matrix matU = matUBulk + matUBoundary;
  real[int] rhsUBulk = varUrhs(0, Vh);
  real[int] rhsUBoundary = varBoundaryU(0, Vh);
  real[int] rhsU = rhsUBulk + rhsUBoundary;
  set(matU,solver=sparsesolver);
  u[] = matU^-1*rhsU;

  matrix matVBulk = varV(Vh, Vh);
  matrix matVBoundary = varBoundaryV(Vh, Vh);
  matrix matV = matVBulk + matVBoundary;
  real[int] rhsVBulk = varVrhs(0, Vh);
  real[int] rhsVBoundary = varBoundaryV(0, Vh);
  real[int] rhsV = rhsVBulk + rhsVBoundary;
  set(matV,solver=sparsesolver);
  v[] = matV^-1*rhsV;

  #if DIMENSION == 3
  matrix matWBulk = varW(Vh, Vh);
  matrix matWBoundary = varBoundaryW(Vh, Vh);
  matrix matW = matWBulk + matWBoundary;
  real[int] rhsWBulk = varWrhs(0, Vh);
  real[int] rhsWBoundary = varBoundaryW(0, Vh);
  real[int] rhsW = rhsWBulk + rhsWBoundary;
  set(matW,solver=sparsesolver);
  w[] = matW^-1*rhsW;
  #endif
  real meandiv = INTEGRAL(DIMENSION)(Th)(Div(UVEC))/vol;
  varf varP(q,test) =
    INTEGRAL(DIMENSION)(Th)(
        Grad(q)'*Grad(test)
        )
    + on(5, q = 0);
  varf varPrhs(q,test) =
    INTEGRAL(DIMENSION)(Th)(
        (Div(UVEC)-meandiv)*test/dt
        )
    + on(5, q = 0);
  matrix matP = varP(Vh, Vh);
  real[int] rhsP = varPrhs(0, Vh);
  set(matP,solver=sparsesolver);
  q[] = matP^-1*rhsP;
  // solve pb4p(q,test,solver=LU)= int2d(Th)(Grad(q)'*Grad(test))
  //     - INTEGRAL(DIMENSION)(Th)((Div(UVEC)-meandiv)*test/dt);
  real meanpq = INTEGRAL(DIMENSION)(Th)(pold - q)/vol;
  p = pold-q-meanpq;
  u = u + dx(q)*dt;
  v = v + dy(q)*dt;
  #if DIMENSION == 3
  w = w + dz(q)*dt;
  #endif
  #endif
  //}}}
  // Adapt mesh {{{
  if (adapt)
  {
    #ifdef MPI
    if (mpirank == 0)
    #endif
    #if DIMENSION == 2
    {
      Th = adaptmesh(Th, phi, mu, err = meshError, hmax = hmax, hmin = hmin);
    }
    #endif

    #if DIMENSION == 3
    {
      {
        Vh metricField;
        metricField[] = mshmet(Th, phi, aniso = 0, hmin = hmin, hmax = hmax, nbregul = 1);
        ofstream bgm("output/mshmet-" + i + ".msh");
        writeHeader(bgm); write1dData(bgm, "Size field", i*dt, i, metricField);
      }
      system("./bin/msh2pos output/mesh-"+i+".msh output/mshmet-"+i+".msh");
      system("gmsh -v 0 " + xstr(GEOMETRY) + " -3 -bgm 'output/mshmet-"+i+".pos' -o 'output/mesh-" + (i + 1) + ".msh'");
      Th = gmshload3("output/mesh-" + (i + 1) + ".msh");
    }
    #endif
    [phi, mu] = [phi, mu];

    #ifdef NS
    u = u;
    v = v;
    p = p;
    q = q;
    #if DIMENSION == 3
    w = w;
    #endif
    #endif

    #ifdef ELECTRO
    theta = theta;
    #endif

    #ifdef MPI
    broadcast(processor(0), Th);
    broadcast(processor(0), phi[]);
    #endif
  }
  //}}}
  // Print the times to stdout {{{
  #ifdef MPI
  if (mpirank == 0)
  #endif
  {
    cout << endl
         << "** TIME OF COMPUTATIONS **    " << endl
         << "Matrix: assembly (master)     " << timeMatrix          << endl
         << "Matrix: volume terms          " << timeMatrixBulk      << endl
         << "Matrix: boundary conditions   " << timeMatrixBc        << endl
         << "Matrix: factorization         " << timeFactorization   << endl;
    #ifdef MPI
    cout << "Matrix: volume terms (total)  " << timeMatrixTotal     << endl;
    #endif
  }
  #ifdef MPI
  mpiBarrier(mpiCommWorld);
  cout   << "... Time for region " << mpirank << ": " << timeMatrixRegion << "  (Including broadcast: " << timeMatrixBulk << ")" << endl;
  mpiBarrier(mpiCommWorld);
  #endif

  #ifdef MPI
  if (mpirank == 0)
  #endif
  {
    cout << endl
         << "Rhs: assembly (master)       " << timeRhs             << endl
         << "Rhs: volume terms            " << timeRhsBulk         << endl
         << "Rhs: boundary conditions     " << timeRhsBc           << endl;
    #ifdef MPI
    cout << "Rhs: volume terms (total)    " << timeRhsTotal        << endl;
    #endif
  }
  #ifdef MPI
  mpiBarrier(mpiCommWorld);
  cout   << "... Time for region " << mpirank << ": " << timeRhsRegion << "  (Including broadcast: " << timeRhsBulk << ")" << endl;
  mpiBarrier(mpiCommWorld);
  #endif

  #ifdef MPI
  if (mpirank == 0)
  #endif
  {
    cout << endl
         << "Solution  of the linear system       " << timeSolution        << endl
         << "Total time spent in process 0        " << clock() - timeStart << endl;
  }
  //}}}
}
//}}}
