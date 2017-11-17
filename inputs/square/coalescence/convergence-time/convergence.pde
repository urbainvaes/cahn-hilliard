#define xstr(s) str(s)
#define str(s) #s
#include xstr(GITROOT/sources/freefem/writers.pde)

// Load package
load "gmsh"
load "isoline"

// Load fine mesh
mesh Th;

#ifdef SOLVER_ADAPT
Th = gmshload("output/mesh.msh");
#else
Th = gmshload("../0/output/mesh.msh");
#endif

// Meshes for each of the meshsizes
#ifdef SOLVER_ADAPT
mesh Th0  = gmshload("output/mesh.msh");
mesh Th1  = gmshload("output/mesh.msh");
mesh Th2  = gmshload("output/mesh.msh");
mesh Th3  = gmshload("output/mesh.msh");
mesh Th4  = gmshload("output/mesh.msh");
mesh Th5  = gmshload("output/mesh.msh");
#endif

// Define functional spaces on fine mesh
fespace Vh(Th,P1);

#ifdef SOLVER_ADAPT
fespace Vh0  (Th0,  P1);
fespace Vh1  (Th1,  P1);
fespace Vh2  (Th2,  P1);
fespace Vh3  (Th3,  P1);
fespace Vh4  (Th4,  P1);
fespace Vh5  (Th5,  P1);
#endif

// Define fields
#ifdef SOLVER_ADAPT
Vh0 phi0; Vh1 phi1; Vh2 phi2; Vh3 phi3; Vh4 phi4; Vh5 phi5;
#else
Vh phi0, phi1, phi2, phi3, phi4, phi5;
#endif
Vh error1, error2, error3, error4, error5; 



// Parametes used in the simulation
real Pe = 500;
real Cn = 5e-3;


macro Grad(u) [dx(u), dy(u)] //EOM
macro Div(u,v) (dx(u) + dy(v)) //EOM
macro Normal [N.x, N.y] //EOM

int nIndex = N_ITERATIONS_COARSE;
int nSteps = 6;

// Empty output files
for (int j = 0; j < nSteps; j++)
{
    ofstream errorFile("output/error-" + j + ".txt");
}

for(int index = 0; index <= nIndex; index++)
{
    cout << "Calculating errors for iteration " + index + " on the coarsest mesh." << endl;

    #ifdef SOLVER_ADAPT
    Th0  = gmshload("../0/output/mesh/mesh-" + index * (2^5) + ".msh"); phi0 = phi0;
    Th1  = gmshload("../1/output/mesh/mesh-" + index * (2^4) + ".msh"); phi1 = phi1;
    Th2  = gmshload("../2/output/mesh/mesh-" + index * (2^3) + ".msh"); phi2 = phi2;
    Th3  = gmshload("../3/output/mesh/mesh-" + index * (2^2) + ".msh"); phi3 = phi3;
    Th4  = gmshload("../4/output/mesh/mesh-" + index * (2^1) + ".msh"); phi4 = phi4;
    Th5  = gmshload("../5/output/mesh/mesh-" + index * (2^0) + ".msh"); phi5 = phi5;
    #endif

    readfreefem("../0/output/phi/phi-" + index * (2^5) + ".txt", phi0);
    readfreefem("../1/output/phi/phi-" + index * (2^4) + ".txt", phi1);
    readfreefem("../2/output/phi/phi-" + index * (2^3) + ".txt", phi2);
    readfreefem("../3/output/phi/phi-" + index * (2^2) + ".txt", phi3);
    readfreefem("../4/output/phi/phi-" + index * (2^1) + ".txt", phi4);
    readfreefem("../5/output/phi/phi-" + index * (2^0) + ".txt", phi5);

    Vh error1  = phi1 - phi0;
    Vh error2  = phi2 - phi0;
    Vh error3  = phi3 - phi0;
    Vh error4  = phi4 - phi0;
    Vh error5  = phi5 - phi0;

    real[int] errorNormL2(nSteps);
    errorNormL2[0] = 0;
    errorNormL2[1] = sqrt(int2d(Th) (error1  * error1));
    errorNormL2[2] = sqrt(int2d(Th) (error2  * error2));
    errorNormL2[3] = sqrt(int2d(Th) (error3  * error3));
    errorNormL2[4] = sqrt(int2d(Th) (error4  * error4));
    errorNormL2[5] = sqrt(int2d(Th) (error5  * error5));

    for (int j = 0; j < nSteps; j++)
    {
        ofstream errorFile("output/error-" + j + ".txt", append);
        errorFile << errorNormL2[j] << endl;
    }
}
