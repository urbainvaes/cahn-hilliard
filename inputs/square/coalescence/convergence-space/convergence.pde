#define xstr(s) str(s)
#define str(s) #s
#include xstr(GITROOT/sources/freefem/writers.pde)

// Load package
load "gmsh"
load "isoline"

// Load fine mesh
mesh Th;
Th = gmshload("output/mesh.msh");

// Meshes for each of the meshsizes
mesh Th0  = gmshload("output/mesh.msh");
mesh Th1  = gmshload("output/mesh.msh");
mesh Th2  = gmshload("output/mesh.msh");
mesh Th3  = gmshload("output/mesh.msh");
mesh Th4  = gmshload("output/mesh.msh");
mesh Th5  = gmshload("output/mesh.msh");
mesh Th6  = gmshload("output/mesh.msh");
mesh Th7  = gmshload("output/mesh.msh");
mesh Th8  = gmshload("output/mesh.msh");
mesh Th9  = gmshload("output/mesh.msh");
mesh Th10 = gmshload("output/mesh.msh");
mesh Th11 = gmshload("output/mesh.msh");

// Define functional spaces on fine mesh
fespace Vh(Th,P1);
fespace Vh0  (Th0,  P1);
fespace Vh1  (Th1,  P1);
fespace Vh2  (Th2,  P1);
fespace Vh3  (Th3,  P1);
fespace Vh4  (Th4,  P1);
fespace Vh5  (Th5,  P1);
fespace Vh6  (Th6,  P1);
fespace Vh7  (Th7,  P1);
fespace Vh8  (Th8,  P1);
fespace Vh9  (Th9,  P1);
fespace Vh10 (Th10, P1);
fespace Vh11 (Th11, P1);

// Define fields
Vh0  phi0  = 0;
Vh1  phi1  = 0; Vh error1  = 0;
Vh2  phi2  = 0; Vh error2  = 0;
Vh3  phi3  = 0; Vh error3  = 0;
Vh4  phi4  = 0; Vh error4  = 0;
Vh5  phi5  = 0; Vh error5  = 0;
Vh6  phi6  = 0; Vh error6  = 0;
Vh7  phi7  = 0; Vh error7  = 0;
Vh8  phi8  = 0; Vh error8  = 0;
Vh9  phi9  = 0; Vh error9  = 0;
Vh10 phi10 = 0; Vh error10 = 0;
Vh11 phi11 = 0; Vh error11 = 0;


// Parametes used in the simulation
real Pe = 500;
real Cn = 5e-3;

macro Grad(u) [dx(u), dy(u)] //EOM
macro Div(u,v) (dx(u) + dy(v)) //EOM
macro Normal [N.x, N.y] //EOM

int nIter = 10;
int nPowers = 6;

for(int iteration = 0; iteration <= nIter; iteration++)
{
    Th0  = gmshload("../0/output/mesh/mesh-"  + iteration + ".msh"); phi0  = phi0;
    Th1  = gmshload("../1/output/mesh/mesh-"  + iteration + ".msh"); phi1  = phi1;
    Th2  = gmshload("../2/output/mesh/mesh-"  + iteration + ".msh"); phi2  = phi2;
    Th3  = gmshload("../3/output/mesh/mesh-"  + iteration + ".msh"); phi3  = phi3;
    Th4  = gmshload("../4/output/mesh/mesh-"  + iteration + ".msh"); phi4  = phi4;
    Th5  = gmshload("../5/output/mesh/mesh-"  + iteration + ".msh"); phi5  = phi5;
    Th6  = gmshload("../6/output/mesh/mesh-"  + iteration + ".msh"); phi6  = phi6;
    Th7  = gmshload("../7/output/mesh/mesh-"  + iteration + ".msh"); phi7  = phi7;
    Th8  = gmshload("../8/output/mesh/mesh-"  + iteration + ".msh"); phi8  = phi8;
    Th9  = gmshload("../9/output/mesh/mesh-"  + iteration + ".msh"); phi9  = phi9;
    Th10 = gmshload("../10/output/mesh/mesh-" + iteration + ".msh"); phi10 = phi10;
    Th11 = gmshload("../11/output/mesh/mesh-" + iteration + ".msh"); phi11 = phi11;

    readfreefem("../0/output/phi/phi-"  + iteration + ".txt", phi0);
    readfreefem("../1/output/phi/phi-"  + iteration + ".txt", phi1);
    readfreefem("../2/output/phi/phi-"  + iteration + ".txt", phi2);
    readfreefem("../3/output/phi/phi-"  + iteration + ".txt", phi3);
    readfreefem("../4/output/phi/phi-"  + iteration + ".txt", phi4);
    readfreefem("../5/output/phi/phi-"  + iteration + ".txt", phi5);
    readfreefem("../6/output/phi/phi-"  + iteration + ".txt", phi6);
    readfreefem("../7/output/phi/phi-"  + iteration + ".txt", phi7);
    readfreefem("../8/output/phi/phi-"  + iteration + ".txt", phi8);
    readfreefem("../9/output/phi/phi-"  + iteration + ".txt", phi9);
    readfreefem("../10/output/phi/phi-" + iteration + ".txt", phi10);
    readfreefem("../11/output/phi/phi-" + iteration + ".txt", phi11);

    Vh error1  = phi1  - phi0; real error1NormL2  = int2d(Th) (error1  * error1 );
    Vh error2  = phi2  - phi0; real error2NormL2  = int2d(Th) (error2  * error2 );
    Vh error3  = phi3  - phi0; real error3NormL2  = int2d(Th) (error3  * error3 );
    Vh error4  = phi4  - phi0; real error4NormL2  = int2d(Th) (error4  * error4 );
    Vh error5  = phi5  - phi0; real error5NormL2  = int2d(Th) (error5  * error5 );
    Vh error6  = phi6  - phi0; real error6NormL2  = int2d(Th) (error6  * error6 );
    Vh error7  = phi7  - phi0; real error7NormL2  = int2d(Th) (error7  * error7 );
    Vh error8  = phi8  - phi0; real error8NormL2  = int2d(Th) (error8  * error8 );
    Vh error9  = phi9  - phi0; real error9NormL2  = int2d(Th) (error9  * error9 );
    Vh error10 = phi10 - phi0; real error10NormL2 = int2d(Th) (error10 * error10);
    Vh error11 = phi11 - phi0; real error11NormL2 = int2d(Th) (error11 * error11);

    cout << error1NormL2  << endl;
    cout << error2NormL2  << endl;
    cout << error3NormL2  << endl;
    cout << error4NormL2  << endl;
    cout << error5NormL2  << endl;
    cout << error6NormL2  << endl;
    cout << error7NormL2  << endl;
    cout << error8NormL2  << endl;
    cout << error9NormL2  << endl;
    cout << error10NormL2 << endl;
    cout << error11NormL2 << endl;

    // Vh test;
    // plot(test, wait=true);
}
