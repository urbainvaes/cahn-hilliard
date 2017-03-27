// Convenient functions for cpp {{{
#define xstr(s) str(s)
#define str(s) #s
// }}}
// Include auxiliary files and load modules {{{
include "freefem/write-mesh.pde"
include "freefem/writers.pde"
include "freefem/getargs.pde"
include "freefem/clock.pde"
include "freefem/match.pde"
include "geometry.pde"
//}}}
// Load modules {{{
load "gmsh"
load "isoline"

#if DIMENSION == 2
load "metis"
load "iovtk"
#endif

#if DIMENSION == 3
load "medit"
load "mshmet"
load "tetgen"
#endif

#ifdef MUMPS
load "MUMPS_FreeFem"
string ssparams="nprow=1, npcol="+mpisize;
#define SPARAMS , sparams=ssparams
#else
#define SPARAMS
#endif

// Create output directories
system("mkdir -p" + " output/done"
                  + " output/phi"
                  + " output/mu"
                  + " output/muGradPhi"
                  + " output/velocity"
                  + " output/u"
                  + " output/v"
                  + " output/w"
                  + " output/pressure"
                  + " output/iso"
                  + " output/interface "
                  + " output/mesh"
                  #ifdef ELECTRO
                  + " output/potential"
                  #endif
                 );
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
#ifdef PERIODICITY
#include xstr(PERIODICITY)
#define ARGPERIODIC ,periodic=periodicity
#else
#define ARGPERIODIC
#endif
fespace Vh(Th,P1 ARGPERIODIC);
fespace V2h(Th,[P1,P1] ARGPERIODIC);
#endif

#if DIMENSION == 3
fespace Vh(Th,P1), V2h(Th,[P1,P1]);
#endif

// Mesh on which to project solution for visualization
fespace VhOut(ThOut,P1);

// Phase field
V2h [phi, mu];
Vh phiOld, muOld;
VhOut phiOut, muOut;

// Adaptation
Vh adaptField;

#ifdef NS
Vh u = 0, v = 0, w = 0, p = 0;
Vh uOld, vOld, wOld;
VhOut uOut, vOut, wOut, pOut;
#endif

#ifdef ELECTRO
Vh theta;
#endif
//}}}
// Declare default parameters {{{

// Cahn-Hilliard parameters
real Pe = 1;
real Cn = 0.01;
func energyA = 1/Cn;
func energyB = Cn;

// Navier-Stokes parameters
#ifdef NS
real Re = 1;
real We = 100;
real muGradPhi = 1;
#endif

#ifdef GRAVITY
real rho1 = -1;
real rho2 = 1;

real gx = 1e8;
real gy = 0;
#endif

// Electric parameters
#ifdef ELECTRO
real epsilonR1 = 1;
real epsilonR2 = 2;
#endif

// Time parameters
real dt = 8.0*Pe*Cn^4;
real nIter = 300;

// Mesh parameters
int aniso = 0;
#if DIMENSION == 2
real hmax = 0.01;
real hmin = 0.001;
#endif

#if DIMENSION == 3
real hmax = 0.1;
real hmin = hmax/20;
#endif

//}}}
// Define macros {{{
macro wetting(angle) ((sqrt(2.)/2.)*cos(angle)) // EOM

#if DIMENSION == 2
macro Grad(u) [dx(u), dy(u)] //EOM
macro Div(u,v) (dx(u) + dy(v)) //EOM
macro Normal [N.x, N.y] //EOM
#define UVEC u,v
#define UOLDVEC uOld,vOld
#endif

#if DIMENSION == 3
macro Grad(u) [dx(u), dy(u), dz(u)] //EOM
macro Div(u,v,w) (dx(u) + dy(v) + dz(w)) //EOM
macro Normal [N.x, N.y, N.z] //EOM
#define UVEC u,v,w
#define UOLDVEC uOld,vOld,wOld
#endif

#define AUX_INTEGRAL(dim) int ## dim ## d
#define INTEGRAL(dim) AUX_INTEGRAL(dim)
#define AUX_SAVEGMSHVEC(dim) savegmsh ## dim
#define SAVEGMSHVEC(dim) AUX_SAVEGMSHVEC(dim)
//}}}
// Include problem file {{{
#include xstr(PROBLEM)
//}}}
// Calculate dependent parameters {{{
// real Re1 = 1;
// real Re2 = 1;
// #ifdef NS
// Vh Re = 0.5*(Re1*(1 - phi) + Re2*(1 + phi));
// #endif
#ifdef GRAVITY
Vh rho = 0.5*(rho1*(1 - phi) + rho2*(1 + phi));
#endif
//}}}
// Define variational formulations {{{
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
// Cahn-Hilliard {{{
varf varPhi([phi1,mu1], [phi2,mu2]) =
  // Bilinear form
  INTEGRAL(DIMENSION)(Th)(
    phi1*phi2/dt
    + (1/Pe)*(Grad(mu1)'*Grad(phi2))
    - mu1*mu2
    + energyB * (Grad(phi1)'*Grad(mu2))
    + energyA * 0.5*3*phiOld*phiOld*phi1*mu2
    - energyA *0.5*phi1*mu2
    )
  // Right-hand side
  + INTEGRAL(DIMENSION)(Th)(
    #ifdef NS
    convect([UOLDVEC],-dt,phiOld)/dt*phi2
    #else
    phiOld*phi2/dt
    #endif
    + energyA * 0.5*phiOld*phiOld*phiOld*mu2
    + energyA * 0.5*phiOld*mu2
    #ifdef ELECTRO
    + 0.25 * (epsilonR2 - epsilonR1) * (Grad(theta)'*Grad(theta)) * mu2
    #endif
    )
;
//}}}
// Navier-Stokes {{{
#ifdef NS
varf varU(u,test) =
    // Bilinear form
    INTEGRAL(DIMENSION)(Th)(u*test/dt + (1/Re)*(Grad(u)'*Grad(test)))
    // Right-hand side
    + INTEGRAL(DIMENSION)(Th)(
        (convect([UOLDVEC],-dt,uOld)/dt)*test
        + muGradPhi     * (1/We)*mu*dx(phi)*test
        - (1-muGradPhi) * (1/We)*phi*dx(mu)*test
        #ifdef GRAVITY
        + gx*phi*test
        #endif
        )
;
varf varV(v,test) =
    // Bilinear form
    INTEGRAL(DIMENSION)(Th)(v*test/dt + (1/Re)*(Grad(v)'*Grad(test)))
    // Right-hand side
    + INTEGRAL(DIMENSION)(Th)(
        (convect([UOLDVEC],-dt,vOld)/dt)*test
        + muGradPhi     * (1/We)*mu*dy(phi)*test
        - (1-muGradPhi) * (1/We)*phi*dy(mu)*test
        #ifdef GRAVITY
        + gy*phi*test
        #endif
        )
;
#if DIMENSION == 3
varf varW(w,test) =
    // Bilinear form
    INTEGRAL(DIMENSION)(Th)(w*test/dt + (1/Re)*(Grad(w)'*Grad(test)))
    // Right-hand side
    + INTEGRAL(DIMENSION)(Th)(
      (convect([UOLDVEC],-dt,wOld)/dt)*test
      + muGradPhi     * (1/We)*mu*dz(phi)*test
      - (1-muGradPhi) * (1/We)*mu*dz(phi)*test
      #ifdef GRAVITY
      + gz*phi*test
      #endif
    )
;
#endif
varf varP(p,test) =
    // Bilinear form
    INTEGRAL(DIMENSION)(Th)( Grad(p)'*Grad(test) )
    // Right-hand side
    + INTEGRAL(DIMENSION)(Th)( -Div(UVEC)*test/dt )
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
#ifdef ADAPT
  #if DIMENSION == 2
  for(int i = 0; i < 3; i++)
  {
      Th = adaptmesh(anisomax = aniso, Th, phi, hmax = hmax, hmin = hmin, nbvx = 1e6 ARGPERIODIC);
      [phi, mu] = [phi0, mu0];
  }
  #endif
  #if DIMENSION == 3
  system("cp output/mesh.msh output/mesh/mesh-init-0.msh");
  for(int i = 0; i < 2; i++)
  {
      Vh metricField;
      metricField[] = mshmet(Th, phi, aniso = aniso, hmin = hmin, hmax = hmax, nbregul = 1, verbosity = 0);
      Th=tetgreconstruction(Th,switch="raAQ",sizeofvolume=metricField*metricField*metricField/6.);
      [phi, mu] = [phi0, mu0];

      #ifdef PLOT
          medit("Phi", Th, phi, wait = false);
      #endif
  }
  #endif
  #ifdef NS
  u = u;
  v = v;
  p = p;
  #if DIMENSION == 3
  w = w;
  #endif
  #endif
#endif
//}}}
// Loop in time {{{

// CLear and create output file
{
    ofstream file("output/thermodynamics.txt");
    ofstream params("parameters.txt");
};

// Declare macroscopic variables {{{
real massPhi, freeEnergy, kineticEnergy;

real intDiffusiveFluxMass = 0;
#ifdef NS
real intConvectiveFluxMass = 0;
#endif

real intDissipationFreeEnergy = 0;
real intDiffusiveFluxFreeEnergy = 0;
#ifdef NS
real intTransferEnergy = 0;
real intConvectiveFluxFreeEnergy = 0;
#endif

#ifdef NS
real intDissipationKineticEnergy = 0;
real intDiffusiveFluxKineticEnergy = 0;
real intConvectiveFluxKineticEnergy = 0;
real intPressureFluxKineticEnergy = 0;
#endif
// }}}

for(int i = 0; i <= nIter; i++)
{
  // Update previous solution {{{
  phiOld = phi;
  muOld = mu;
  #ifdef NS
  uOld = u;
  vOld = v;
  #if DIMENSION == 3
  wOld = w;
  #endif
  #endif
  //}}}
  // Calculate macroscopic variables {{{

  // Dimension of the boundary
  #if DIMENSION == 2
  #define BOUNDARYDIM 1
  #endif
  #if DIMENSION == 3
  #define BOUNDARYDIM 2
  #endif

  // Mass {{{
  real massPhiOld = massPhi;
  massPhi = INTEGRAL(DIMENSION)(Th) (phi);
  real deltaMassPhi = massPhi - massPhiOld;

  // Mass fluxes outside of domain
  real diffusiveFluxMass = - INTEGRAL(BOUNDARYDIM)(Th) ((1/Pe) * Normal'*Grad(mu));
  real totalFluxMass = diffusiveFluxMass;
  #ifdef NS
  real convectiveFluxMass = INTEGRAL(BOUNDARYDIM)(Th) (phi * [UVEC]'*Normal);
  totalFluxMass = totalFluxMass + convectiveFluxMass;
  #endif
  //}}}
  // Free energy {{{
  real bulkFreeEnergy  = INTEGRAL(DIMENSION)(Th) (
      Cn * 0.5 * (Grad(phi)'*Grad(phi))
      + (1/Cn) * 0.25 * (phi^2 - 1)^2
      #ifdef ELECTRO
      - 0.25 * (epsilonR1*(1 - phi) + epsilonR2*(1 + phi)) * Grad(theta)'*Grad(theta)
      #endif
      );
  real wallFreeEnergy = INTEGRAL(BOUNDARYDIM)(Th,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20) (wetting(contactAngles) * (phi - phi^3/3));
  real freeEnergyOld = freeEnergy;
  freeEnergy = bulkFreeEnergy + wallFreeEnergy;
  real deltaFreeEnergy = freeEnergy - freeEnergyOld;
  real dissipationFreeEnergy = INTEGRAL(DIMENSION)(Th) ((1/Pe)*(Grad(mu)'*Grad(mu)));
  real diffusiveFluxFreeEnergy = - INTEGRAL(BOUNDARYDIM)(Th) ((1/Pe) * mu * Normal'*Grad(mu));
  real totalContributionsFreeEnergy = diffusiveFluxFreeEnergy + dissipationFreeEnergy;
  #ifdef NS
  real transferEnergy = INTEGRAL(DIMENSION)(Th) (phi*[UVEC]'*Grad(mu));
  real convectiveFluxFreeEnergy = INTEGRAL(BOUNDARYDIM)(Th) (mu * phi* [UVEC]'*Normal);
  totalContributionsFreeEnergy += convectiveFluxFreeEnergy + transferEnergy;
  #endif
  // }}}
  // Kinetic energy {{{
  #ifdef NS
  real kineticEnergyOld = kineticEnergy;
  kineticEnergy = INTEGRAL(DIMENSION)(Th) (u*u/2);
  real deltaKineticEnergy = kineticEnergy - kineticEnergyOld;
  real dissipationKineticEnergy = INTEGRAL(DIMENSION)(Th) ((1/Re) * (Grad(u)'*Grad(u) + Grad(v)'*Grad(v)
      #if DIMENSION == 3
      + Grad(w)'*Grad(w)
      #endif
      ));
  real diffusiveFluxKineticEnergy = - INTEGRAL(BOUNDARYDIM)(Th) ((1/Re) * (
      u*(Normal'*Grad(u)) + v*(Normal'*Grad(v))
      #if DIMENSION == 3
      + w*(Normal'*Grad(w))
      #endif
      )); // check!
  real convectiveFluxKineticEnergy = INTEGRAL(BOUNDARYDIM)(Th) (([UVEC]'* // splitting required for correct macro expansion
      [UVEC]/2) * [UVEC]'*Normal);
  real pressureFluxKineticEnergy = INTEGRAL(BOUNDARYDIM)(Th) (p * [UVEC]'*Normal);
  real totalContributionsKineticEnergy = diffusiveFluxKineticEnergy + convectiveFluxKineticEnergy + pressureFluxKineticEnergy - transferEnergy;
  #endif
  // }}}

  // Update integrated quantities {{{
  intDiffusiveFluxMass += dt*diffusiveFluxMass;
  #ifdef NS
  intConvectiveFluxMass += dt*convectiveFluxMass;
  #endif

  intDissipationFreeEnergy += dt*dissipationFreeEnergy;
  intDiffusiveFluxFreeEnergy += dt*diffusiveFluxFreeEnergy;
  #ifdef NS
  intTransferEnergy += dt*transferEnergy;
  intConvectiveFluxFreeEnergy += dt*convectiveFluxFreeEnergy;
  #endif

  #ifdef NS
  intDissipationKineticEnergy += dt*dissipationKineticEnergy;
  intDiffusiveFluxKineticEnergy += dt*diffusiveFluxKineticEnergy;
  intConvectiveFluxKineticEnergy += dt*convectiveFluxKineticEnergy;
  intPressureFluxKineticEnergy += dt*pressureFluxKineticEnergy;
  #endif
  // }}}

  // {
  //     ofstream file("output/thermodynamics.txt", append);
  //     file << i*dt           << "    "
  //         << bulkFreeEnergy     << "    "
  //         << massPhi        << "    " << endl;
  // };

  // Print to stdout {{{
  cout << endl
       << "** ITERATION **" << endl
       << "Iteration: "     << i    << endl
       << "Time:      "     << i*dt << endl
       << endl
       << "** Mass **"                        << endl
       << "Mass:                       "      << massPhi              << endl
       << "Diffusive mass flux:        "      << dt*diffusiveFluxMass << endl
       << "Integrated diffusive mass flux:  " << intDiffusiveFluxMass << endl
       #ifdef NS
       << "Convective mass flux:       "            << dt*convectiveFluxMass << endl
       << "Integrated convective mass flux:       " << intConvectiveFluxMass << endl
       << "Total outgoing mass flux:   "            << dt*totalFluxMass      << endl
       #endif
       << "Increase in mass:           "                   << deltaMassPhi                    << endl
       << "Mass balance (must be = 0): "                   << deltaMassPhi + dt*totalFluxMass << endl
       << endl
       << "** Free energy **"                              << endl
       << "Bulk free energy:                  "            << bulkFreeEnergy                  << endl
       << "Wall free energy:                  "            << wallFreeEnergy                  << endl
       << "Free energy dissipations:          "            << dt*dissipationFreeEnergy        << endl
       << "Integrated free energy dissipations:          " << intDissipationFreeEnergy        << endl
       << "Diffusive free energy flux:        "            << dt*diffusiveFluxFreeEnergy      << endl
       << "Integrated diffusive free energy flux:        " << intDiffusiveFluxFreeEnergy      << endl
       #ifdef NS
       << "Convective free energy flux:       "            << dt*convectiveFluxFreeEnergy     << endl
       << "Integrated convective free energy flux:       " << intConvectiveFluxFreeEnergy     << endl
       << "Transfer to kinetic energy:        "            << dt*transferEnergy               << endl
       << "Integrated transfer to kinetic energy:        " << intTransferEnergy               << endl
       << "Sum of all contributions:          "            << dt*totalContributionsFreeEnergy << endl
       #endif
       << "Increase in free energy:           " << deltaFreeEnergy                                   << endl
       << "Free energy balance (must be = 0): " << deltaFreeEnergy + dt*totalContributionsFreeEnergy << endl
       #ifdef NS
       << endl
       << "** Kinetic energy **"                              << endl
       << "Kinetic energy:                       "            << kineticEnergy                                           << endl
       << "Kinetic energy dissipations:          "            << dt* dissipationKineticEnergy                            << endl
       << "Integrated kinetic energy dissipations:          " << intDissipationKineticEnergy                             << endl
       << "Diffusive kinetic energy flux:        "            << dt* diffusiveFluxKineticEnergy                          << endl
       << "Integrated diffusive kinetic energy flux:        " << intDiffusiveFluxKineticEnergy                           << endl
       << "Convective kinetic energy flux:       "            << dt* convectiveFluxKineticEnergy                         << endl
       << "Integrated convective kinetic energy flux:       " << intConvectiveFluxKineticEnergy                          << endl
       << "Pressure-induced kinetic energy flux: "            << dt* pressureFluxKineticEnergy                           << endl
       << "Integrated pressure-induced kinetic energy flux: " << intPressureFluxKineticEnergy                            << endl
       << "Sum of all contributions:             "            << dt* totalContributionsKineticEnergy                     << endl
       << "Increase in kinetic energy:           "            << deltaKineticEnergy                                      << endl
       << "Kinetic energy balance (must be = 0): "            << deltaKineticEnergy + dt*totalContributionsKineticEnergy << endl
       #endif
       << endl
       << "** Parameters **" << endl
       << "dt = "            << dt   << endl
       << "Pe = "            << Pe   << endl
       << "Cn = "            << Cn   << endl
       #ifdef ADAPT
       << "hmin = "          << hmin << endl
       << "hmax = "          << hmax << endl
       #endif
       #ifdef NS
       << "Re = "            << Re   << endl
       << "We = "            << We   << endl
       #endif
       << endl;
  // }}}
  // }}}
  // Save data to files and stdout {{{
  #if DIMENSION == 2
      // Isoline
      real[int,int] xy(3,1);
      isoline(Th, phi, xy, close=false, iso=0.0, smoothing=0.1, file="output/iso/contactLine"+i+".dat");
      // vtk (paraview format)
      #if SAVEVTK == 1
          savevtk("output/phi/phi."+i+".vtk", Th, phi, dataname="Phase");
          savevtk("output/mu/mu."+i+".vtk",  Th, mu,  dataname="ChemicalPotential");
          #ifdef NS
          savevtk("output/velocity/velocity."+i+".vtk", Th, [u,v,0], dataname="Velocity");
          savevtk("output/pressure/pressure."+i+".vtk", Th, p, dataname="Pressure");
          #endif
          #ifdef ELECTRO
          savevtk("output/potential/potential."+i+".vtk",Th,theta, dataname="Potential");
          #endif
      #endif
      // gmsh
      savegmsh("output/phi/phi-" + i + ".msh", "Cahn-Hilliard", i*dt, i, phiOld);
      savegmsh("output/mu/mu-" + i + ".msh", "Chemical potential", i*dt, i, muOld);
      #ifdef NS
      savegmsh("output/pressure/pressure-" + i + ".msh", "Pressure", i*dt, i, p);
      SAVEGMSHVEC(DIMENSION)("output/velocity/velocity-" + i + ".msh", "Velocity field", i*dt, i, UVEC);
      #endif
      #ifdef ADAPT
      savemesh("output/mesh/mesh-" + i + ".msh", Vh, Th);
      system("./bin/msh2pos output/mesh/mesh-" + i + ".msh output/phi/phi-" + i + ".msh");
      system("./bin/msh2pos output/mesh/mesh-" + i + ".msh output/mu/mu-" + i + ".msh");
      #ifdef NS
      system("./bin/msh2pos output/mesh/mesh-" + i + ".msh output/pressure/pressure-" + i + ".msh");
      system("./bin/msh2pos output/mesh/mesh-" + i + ".msh output/velocity/velocity-" + i + ".msh");
      #endif
      #endif
      // gnuplot
      savegnuplot("output/phi/phi."+i+".gnuplot", Th, phiOld);
      savegnuplot("output/mu/mu."+i+".gnuplot", Th, muOld);
      Vh muGradPhi = sqrt(mu*mu*Grad(phi)'*Grad(phi));
      savegnuplot("output/muGradPhi/muGradPhi."+i+".gnuplot", Th, muGradPhi);
      #ifdef NS
      savegnuplot("output/pressure/pressure."+i+".gnuplot", Th, p);
      savegnuplot("output/u/u."+i+".gnuplot", Th, u);
      savegnuplot("output/v/v."+i+".gnuplot", Th, v);
      savegnuplot2("output/velocity/velocity."+i+".gnuplot", Th, Vh, u, v);
      #endif
  #endif

  #if DIMENSION == 3
  {
      #ifdef ADAPT
      ofstream currentMesh("output/mesh/mesh-" + i + ".msh");
      writeHeader(currentMesh);
      writeNodes(currentMesh, Vh);
      writeElements(currentMesh, Vh, Th);
      #endif
      ofstream data("output/phi/phi-" + i + ".msh");
      writeHeader(data);
      write1dData(data, "Cahn-Hilliard", i*dt, i, phiOld);
  }
  #ifdef ADAPT
  system("./bin/msh2pos output/mesh/mesh-" + i + ".msh output/phi/phi-" + i + ".msh");
  #endif
  // ! phi[]
  #endif

  //}}}
  // Visualize solution at current time step {{{
  #ifdef PLOT
      #if DIMENSION == 2
      plot(phi, fill=true, WindowIndex = 0);
      #ifdef NS
      plot(u, fill=true, WindowIndex = 1);
      plot(p, fill=true, WindowIndex = 2);
      #endif
      #endif

      #if DIMENSION == 3
      medit("Phi",Th,phi,wait = false);
      #endif
  #endif
  //}}}
  // After iteration {{{
  #ifdef AFTER
      #include "after.pde"
  #endif
  /// }}}
  // Exit if required {{{
  if (i == nIter) break;
  //}}}
  // Before iteration {{{
  #ifdef BEFORE
      #include "before.pde"
  #endif

  if(i == 0) {
      ofstream file("parameters.txt",append);
      file << "dt = " << dt << endl;
      file << "Pe = " << Pe << endl;
      file << "Cn = " << Cn << endl;
      #ifdef ADAPT
      file << "hmin = " << hmin << endl;
      file << "hmax = " << hmax << endl;
      #endif
      #ifdef NS
      file << "Re = " << Re << endl;
      file << "We = " << We << endl;
      #endif
  }
  else {
      if (doesMatch("parameters.txt","dt")) dt = getMatch("parameters.txt","dt =");
      if (doesMatch("parameters.txt","Pe")) Pe = getMatch("parameters.txt","Pe =");
      if (doesMatch("parameters.txt","Cn")) Cn = getMatch("parameters.txt","Cn =");
      #ifdef ADAPT
      if (doesMatch("parameters.txt","hmin")) hmin = getMatch("parameters.txt","hmin =");
      if (doesMatch("parameters.txt","hmax")) hmax = getMatch("parameters.txt","hmax =");
      #endif
      #ifdef NS
      if (doesMatch("parameters.txt","Re")) Re = getMatch("parameters.txt","Re =");
      if (doesMatch("parameters.txt","We")) We = getMatch("parameters.txt","We =");
      #endif
  }


  {
      ofstream fdone("output/done/done-"+i+".txt");
      fdone << "done" << endl;
  }
  // }}}
  // Poisson for electric potential {{{
  #ifdef ELECTRO
  matrix matPotentialBulk = varPotential(Vh, Vh);
  matrix matPotentialBoundary = varBoundaryPotential(Vh, Vh);
  matrix matPotential = matPotentialBulk + matPotentialBoundary;
  real[int] rhsPotential = varBoundaryPotential(0, Vh);
  set(matPotential,solver=sparsesolver SPARAMS);
  theta[] = matPotential^-1*rhsPotential;
  #endif
  //}}}
  // Cahn-Hilliard equation {{{
  matrix matPhiBulk = varPhi(V2h, V2h);
  matrix matPhiBoundary = varPhiBoundary(V2h, V2h);
  matrix matPhi = matPhiBulk + matPhiBoundary;
  real[int] rhsPhiBulk = varPhi(0, V2h);
  real[int] rhsPhiBoundary = varPhiBoundary(0, V2h);
  real[int] rhsPhi = rhsPhiBulk + rhsPhiBoundary;
  set(matPhi,solver=sparsesolver SPARAMS);
  phi[] = matPhi^-1*rhsPhi;
  //}}}
  // Navier stokes {{{
  #ifdef NS
  Vh uOld = u, vOld = v, pold=p;
  #if DIMENSION == 3
  Vh wOld = w;
  #endif
  matrix matUBulk = varU(Vh, Vh);
  matrix matUBoundary = varUBoundary(Vh, Vh);
  matrix matU = matUBulk + matUBoundary;
  real[int] rhsUBulk = varU(0, Vh);
  real[int] rhsUBoundary = varUBoundary(0, Vh);
  real[int] rhsU = rhsUBulk + rhsUBoundary;
  set(matU,solver=sparsesolver SPARAMS);
  u[] = matU^-1*rhsU;

  matrix matVBulk = varV(Vh, Vh);
  matrix matVBoundary = varVBoundary(Vh, Vh);
  matrix matV = matVBulk + matVBoundary;
  real[int] rhsVBulk = varV(0, Vh);
  real[int] rhsVBoundary = varVBoundary(0, Vh);
  real[int] rhsV = rhsVBulk + rhsVBoundary;
  set(matV,solver=sparsesolver SPARAMS);
  v[] = matV^-1*rhsV;

  #if DIMENSION == 3
  matrix matWBulk = varW(Vh, Vh);
  matrix matWBoundary = varWBoundary(Vh, Vh);
  matrix matW = matWBulk + matWBoundary;
  real[int] rhsWBulk = varW(0, Vh);
  real[int] rhsWBoundary = varWBoundary(0, Vh);
  real[int] rhsW = rhsWBulk + rhsWBoundary;
  set(matW,solver=sparsesolver SPARAMS);
  w[] = matW^-1*rhsW;
  #endif

  matrix matPBulk = varP(Vh, Vh);
  matrix matPBoundary = varPBoundary(Vh, Vh);
  matrix matP = matPBulk + matPBoundary;
  real[int] rhsPBulk = varP(0, Vh);
  real[int] rhsPBoundary = varPBoundary(0, Vh);
  real[int] rhsP = rhsPBulk + rhsPBoundary;
  set(matP,solver=sparsesolver SPARAMS);
  p[] = matP^-1*rhsP;

  u = u - dx(p)*dt;
  v = v - dy(p)*dt;
  #if DIMENSION == 3
  w = w - dz(p)*dt;
  #endif
  #endif
  //}}}
  // Adapt mesh {{{
  #ifdef ADAPT
    #if DIMENSION == 2
    Th = adaptmesh(anisomax = aniso, Th, phi, hmax = hmax, hmin = hmin, nbvx = 1e6 ARGPERIODIC);
    #endif

    #if DIMENSION == 3
    Vh metricField;
    metricField[] = mshmet(Th, phi, aniso = aniso, hmin = hmin, hmax = hmax, nbregul = 1, verbosity = 0);
    Th=tetgreconstruction(Th,switch="raAQ",sizeofvolume=metricField*metricField*metricField/6.);
    #endif
    [phi, mu] = [phi, mu];

    #ifdef NS
    u = u;
    v = v;
    p = p;
    #if DIMENSION == 3
    w = w;
    #endif
    #endif

    #ifdef ELECTRO
    theta = theta;
    #endif
  #endif
  // }}}
}
//}}}
