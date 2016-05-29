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
#endif
//}}}
// Process input parameters {{{
int adapt      = getARGV("-adapt",0);
int plots      = getARGV("-plot",0);
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

MESH Th;
Th = GMSHLOAD("output/mesh.msh");
//}}}
// Define functional spaces {{{
#if DIMENSION == 2
fespace Vh(Th,P2), V2h(Th,[P2,P2]);
#endif

#if DIMENSION == 3
fespace Vh(Th,P1), V2h(Th,[P1,P1]);
#endif

V2h [phi, mu];
Vh u = 0, v = 0, w = 0, p = 0, q = 0;
Vh phiOld, uOld, vOld, wOld;
Vh test;
//}}}
// Declare default parameters {{{

// Cahn-Hilliard parameters
real M       = 1;
real lambda  = 1;
real eps     = 0.01;

// Navier-Stokes parameters
real nu = 1;
real alpha = 0.01;

// Time parameters
real dt = 8.0*eps^4/M;
real nIter = 300;

// Mesh parameters
real meshError = 1.e-2;
real hmax = 0.1;
real hmin = hmax / 100;
//}}}
// Include problem file {{{
include "problem.pde"
//}}}
// Calculate dependent parameters {{{
real eps2 = eps*eps;
real invEps2 = 1./eps2;
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
    // - phi1*([UOLDVEC]'*Grad(phi2))
    - mu1*mu2
    + lambda*(Grad(phi1)'*Grad(mu2))
    + lambda*invEps2*0.5*3*phiOld*phiOld*phi1*mu2
    - lambda*invEps2*0.5*phi1*mu2
    )
;

varf varCHrhs([phi1,mu1], [phi2,mu2]) =
  INTEGRAL(DIMENSION)(INTREGION)(
    // phiOld*phi2/dt
    convect([UOLDVEC],-dt,phiOld)/dt*phi2
    + lambda*invEps2*0.5*phiOld*phiOld*phiOld*mu2
    + lambda*invEps2*0.5*phiOld*mu2
    )
;
//}}}
// // Navier-Stokes {{{
// problem pb4u(u,w,init=n,solver=CG,eps=epsu)
//     =int2d(Th)(u*w/dt +nuNS*(dx(u)*dx(w)+dy(u)*dy(w)))
//     -int2d(Th)((convect([uOld,vOld],-dt,uOld)/dt-dx(p))*w
// + alpha*mu*dx(phi)*w)
// //case: pipe/droplet
//         + on(1,u = uWall*4*y*(1-y)) + on(2,4,u = 0)
//         //+ on(1,u = uWall*4*y*(2-y)) + on(2,4,u = 0)//channel with heterogeneous substrate
// //case:MED/porous medium
//         //+ on(1,2,3,4,5,u = 0)
//     ;

// solve pb4v(v,w,init=n,solver=CG,eps=epsv)
//     = int2d(Th)(v*w/dt +nuNS*(dx(v)*dx(w)+dy(v)*dy(w)))
//     -int2d(Th)((convect([uOld,vOld],-dt,vOld)/dt-dy(p))*w
// + alpha*mu*dy(phi)*w
// - 1*w//gravity
// )
// //case: pipe/droplet
//         + on(1,2,3,4,v = 0)
// //case:MED, porous medium
//         //+ on(2,v = uWall*4*x*(5-x)) + on(1,3,5,v = 0)
// ;

// solve pb4p(q,w,solver=CG,init=n,eps=epsp) = int2d(Th)(dx(q)*dx(w)+dy(q)*dy(w))
// - int2d(Th)((dx(u)+ dy(v))*w/dt)
// //case: pipe
//     + on(3,q=0)
// //case: droplet
//     //+ on(1,3,4,q=0)
// //case: MED/porous medium
//     //+ on(4,q=0)
// ;
//}}}
//}}}
// Create output file for the mesh {{{
// This is only useful if P2 or higher elements are used.
#if DIMENSION == 3
ofstream foutHeader("output/output.msh");

// Write header, nodes and elements
writeHeader(foutHeader);
writeNodes(foutHeader, Vh);
writeElements(foutHeader, Vh, Th);
#endif
//}}}
// Loop in time {{{

// Open output file
ofstream file("output/thermodynamics.txt");

// Declare extensive physical variables//{{{
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
  // Update previous solution//{{{
  timeStart = clock(); tic();
  phiOld = phi;
  uOld = u;
  vOld = v;
  #if DIMENSION == 3
  wOld = w;
  #endif
  //}}}
  // Calculate macroscopic variables//{{{
  #ifdef MPI
  freeEnergyReg  = INTEGRAL(DIMENSION)(Th, processRegion) (0.5*lambda*(Grad(phi)'*Grad(phi)) + 0.25*lambda*invEps2*(phi^2 - 1)^2);
  massPhiReg     = INTEGRAL(DIMENSION)(Th, processRegion) (phi);
  dissipationReg = INTEGRAL(DIMENSION)(Th, processRegion) (M*(Grad(mu)'*Grad(mu)));

  mpiAllReduce(freeEnergyReg,  freeEnergy,  mpiCommWorld, mpiSUM);
  mpiAllReduce(massPhiReg,     massPhi,     mpiCommWorld, mpiSUM);
  mpiAllReduce(dissipationReg, dissipation, mpiCommWorld, mpiSUM);
  #endif

  #ifndef MPI
  freeEnergy  = INTEGRAL(DIMENSION)(Th)   (0.5*lambda*(Grad(phi)'*Grad(phi)) + 0.25*lambda*invEps2*(phi^2 - 1)^2);
  massPhi     = INTEGRAL(DIMENSION)(Th)   (phi);
  dissipation = INTEGRAL(DIMENSION)(Th)   (M*(Grad(mu)'*Grad(mu)));
  #endif

  timeMacro = tic();
  //}}}
  // Save data to files and stdout//{{{
  #ifdef MPI
  if (mpirank == 0)
  #endif
  {
    #if DIMENSION == 2
    savevtk("output/phi."+i+".vtk", Th, phi, dataname="PhaseField");
    savevtk("output/mu."+i+".vtk",  Th, mu,  dataname="ChemicalPotential");
    savevtk("output/velocity"+i+".vtk",Th,[u,v]);
    #endif

    #if DIMENSION == 3
    ofstream fo("output/phase-" + i + ".msh");
    writeHeader(fo); write1dData(fo, "Cahn-Hilliard", i*dt, i, phiOld);
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
  // Visualize solution at current time step//{{{
  #ifdef MPI
  if (mpirank == 0)
  #endif
  {
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
  }
  //}}}
  // Exit if required//{{{
  if (i == nIter) break;

  #ifdef MPI
  mpiBarrier(mpiCommWorld);
  #endif

  tic();
  //}}}
  // Calculate the matrix//{{{
  #ifdef MPI
  matrix matRegion = varCH(V2h, V2h);
  timeMatrixRegion = tic();

  matrix matBulk;
  mpiAllReduce(matRegion,matBulk,mpiCommWorld,mpiSUM);
  mpiAllReduce(timeMatrixRegion,timeMatrixTotal,mpiCommWorld,mpiSUM);
  timeMatrixBulk = timeMatrixRegion + tic();

  // Parameters for solver
  string ssparams="";

  matrix matCH;
  if (mpirank == 0)
  {
      matrix matBoundary = varBoundary(V2h, V2h);
      timeMatrixBc = tic();

      matCH = matBulk + matBoundary;
      timeMatrix = tic() + timeMatrixBulk + timeMatrixBc;

      set(matCH,solver=sparsesolver);
      timeFactorization = tic();
  }
  #endif

  #ifndef MPI
  matrix matBulk = varCH(V2h, V2h);
  timeMatrixBulk = tic();

  matrix matBoundary = varBoundary(V2h, V2h);
  timeMatrixBc = tic();

  matrix matCH = matBulk + matBoundary;
  timeMatrix = tic() + timeMatrixBulk + timeMatrixBc;

  set(matCH,solver=sparsesolver);
  timeFactorization = tic();
  #endif
  //}}}
  // Calculate the right-hand side//{{{
  #ifdef MPI
  real[int] rhsRegion = varCHrhs(0, V2h);
  timeRhsRegion = tic();

  real[int] rhsBulk(rhsRegion.n);
  mpiAllReduce(rhsRegion,rhsBulk,mpiCommWorld,mpiSUM);
  mpiAllReduce(timeRhsRegion,timeRhsTotal,mpiCommWorld,mpiSUM);
  timeRhsBulk = tic() + timeRhsRegion;

  real[int] rhsCH(rhsRegion.n);
  if (mpirank == 0)
  {
      real[int] rhsBoundary = varBoundary(0, V2h);
      timeRhsBc = tic();

      rhsCH = rhsBulk + rhsBoundary;
      timeRhs = tic() + timeRhsBulk + timeRhsBc;
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
    ofstream fout("matrix.txt");
    fout << matCH;
    ofstream foutrhs("rhs.txt");
    fout << rhsCH;
    phi[] = matCH^-1*rhsCH;
    timeSolution = tic();
  }
  #ifdef MPI
  broadcast(processor(0), phi[]);
  #endif
  //}}}
  // Navier stokes {{{
  Vh uOld = u, vOld = v, pold=p;
  #if DIMENSION == 3
  Vh wOld = w;
  #endif
  real vol = INTEGRAL(DIMENSION)(Th)(1.);
  solve pb4u(u,test,solver=LU)
      = INTEGRAL(DIMENSION)(Th)(u*test/dt +nu*(Grad(u)'*Grad(test)))
      - INTEGRAL(DIMENSION)(Th)(
          (convect([UOLDVEC],-dt,uOld)/dt-dx(p))*test
          + alpha*mu*dx(phi)*test
          )
      + on(1,2, u = 0);
  solve pb4v(v,test,solver=LU)
      = INTEGRAL(DIMENSION)(Th)(
          v*test/dt +nu*(Grad(v)'*Grad(test))
          )
      - INTEGRAL(DIMENSION)(Th)(
          (convect([UOLDVEC],-dt,vOld)/dt-dy(p))*test
          + alpha*mu*dy(phi)*test
          // + 1e3*phi*test
          )
      + on(1,2, v = 0);
  #if DIMENSION == 3
  solve pb4w(w,test,solver=LU)
      = INTEGRAL(DIMENSION)(Th)(w*test/dt +nu*(Grad(w)'*Grad(test)))
      -INTEGRAL(DIMENSION)(Th)(
          (convect([UOLDVEC],-dt,wOld)/dt-dz(p))*test
          + alpha*mu*dz(phi)*test
          )
      + on(1,2, w = 0);
  #endif
  real meandiv = INTEGRAL(DIMENSION)(Th)(Div(UVEC))/vol;
  solve pb4p(q,test,solver=LU)= int2d(Th)(Grad(q)'*Grad(test))
      - INTEGRAL(DIMENSION)(Th)((Div(UVEC)-meandiv)*test/dt);
  real meanpq = INTEGRAL(DIMENSION)(Th)(pold - q)/vol;
  p = pold-q-meanpq;
  u = u + dx(q)*dt;
  v = v + dy(q)*dt;
  #if DIMENSION == 3
  w = w + dz(q)*dt;
  #endif
  //}}}
  // Adapt mesh//{{{
  #if DIMENSION == 2
  if (adapt)
  {
    #ifdef MPI
    if (mpirank == 0)
    #endif
    {
      Th = adaptmesh(Th, phi, mu, err = meshError, hmax = hmax, hmin = hmin);
      [phi, mu] = [phi, mu];
    }
    #ifdef MPI
    broadcast(processor(0), Th);
    broadcast(processor(0), phi[]);
    #endif
  }
  #endif
  //}}}
  // Print the times to stdout//{{{
  #ifdef MPI
  if (mpirank == 0)
  #endif
  {
    cout << endl
         << "** TIME OF COMPUTATIONS **           " << endl
         << "Matrix: total time of computations   " << timeMatrix          << endl;
    #ifdef MPI
    cout << "Matrix: computation of volume terms  " << timeMatrixTotal     << endl
         << "Matrix: time spent in process 0      " << timeMatrixBulk      << endl
         << "Matrix: boundary conditions          " << timeMatrixBc        << endl;
    #endif
  }
  #ifdef MPI
  mpiBarrier(mpiCommWorld);
  cout   << "... Time for region " << mpirank << ": " << timeMatrixRegion << endl;
  mpiBarrier(mpiCommWorld);
  #endif

  #ifdef MPI
  if (mpirank == 0)
  #endif
  {
    cout << endl
         << "Rhs: total time of computations      " << timeRhs             << endl;
    #ifdef MPI
    cout << "Rhs: computation of volume terms     " << timeRhsTotal        << endl
         << "Rhs: time spent in process 0         " << timeRhsBulk         << endl
         << "Rhs: boundary conditions             " << timeRhsBc           << endl;
    #endif
  }
  #ifdef MPI
  mpiBarrier(mpiCommWorld);
  cout   << "... Time for region " << mpirank << ": " << timeRhsRegion << endl;
  mpiBarrier(mpiCommWorld);
  #endif

  #ifdef MPI
  if (mpirank == 0)
  #endif
  {
    cout << endl
         << "Factorization of the matrix          " << timeFactorization   << endl
         << "Solution  of the linear system       " << timeSolution        << endl
         << "Total time spent in process 0        " << clock() - timeStart << endl;
  }
  //}}}
}
//}}}
