// Include readers and writers
#include xstr(GITROOT/sources/freefem/writers.pde)

// Load package
load "gmsh"

// Read fine mesh ! P1 or P2?
mesh Th = gmshload("output/mesh.msh"); fespace Vh(Th,P2);

// ! Do not read the high-order mesh
#define LOOP_BODY(ITERATION) mesh Th ## ITERATION = gmshload("../" + xstr(ITERATION) + "/output/mesh.msh");
LOOP(0,N_TESTS,LOOP_BODY)

// Define functional spaces on fine mesh
#define AUX_AUX_LOOP_BODY(ITERATION,ORDER) fespace Vh ## ITERATION (Th ## ITERATION, P ## ORDER);
#define AUX_LOOP_BODY(ITERATION,ORDER) AUX_AUX_LOOP_BODY(ITERATION,ORDER)
#define LOOP_BODY(ITERATION) AUX_LOOP_BODY(ITERATION, SOLVER_POLYNOMIAL_ORDER)
LOOP(0,N_TESTS,LOOP_BODY)

// Define fields
Vh0  phi0  = 0;
#define LOOP_BODY(ITERATION) Vh ## ITERATION phi ## ITERATION = 0;
LOOP(1,N_TESTS,LOOP_BODY)

// Create empty output file
{ofstream errorFile("output/errors.txt");}

for(int iteration = 0; iteration <= SOLVER_NITER; iteration++)
{
    #ifdef SOLVER_ADAPT
        #define LOOP_BODY(ITERATION) \
        Th ## ITERATION = gmshload("../" + xstr(ITERATION) + "/output/mesh/low-order-mesh-" + iteration + ".msh"); \
        phi ## ITERATION = phi ## ITERATION;
        LOOP(0,N_TESTS,LOOP_BODY)
    #endif

    #define LOOP_BODY(ITERATION) \
        readfreefem("../" + xstr(ITERATION) + "/output/phi/phi-"  + iteration + ".txt", phi ## ITERATION);
    LOOP(0,N_TESTS,LOOP_BODY)


    real[int] errorNormL2(N_TESTS);
    // ! Choose Vh or Vh0 for error
    #define LOOP_BODY(ITERATION) \
        Vh0 error ## ITERATION  = phi ## ITERATION  - phi0;\
        errorNormL2[ITERATION]  = sqrt(int2d(Th) (error ## ITERATION  * error ## ITERATION ));
    LOOP(1,N_TESTS,LOOP_BODY)

    // Write errors to output files
    {
        ofstream errorFile("output/errors.txt", append);
        for (int jOut = 0; jOut < N_TESTS; jOut++)
            errorFile << errorNormL2[jOut] << " ";
        errorFile << endl;
    }
}
