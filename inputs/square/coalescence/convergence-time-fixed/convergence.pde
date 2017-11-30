#include xstr(GITROOT/sources/freefem/writers.pde)

// Load package
load "gmsh"

#ifdef SOLVER_ADAPT
mesh Th = gmshload("output/mesh.msh");
#else
mesh Th = gmshload("../0/output/mesh.msh");
#endif

// Meshes for each of the meshsizes
#ifdef SOLVER_ADAPT
#define LOOP_BODY(ITERATION) mesh Th ## ITERATION = gmshload("output/mesh.msh")
LOOP(0,N_TESTS,LOOP_BODY)
#endif

// Define functional spaces on fine mesh
fespace Vh(Th,P1);

#ifdef SOLVER_ADAPT
#define AUX_AUX_LOOP_BODY(ITERATION,ORDER) fespace Vh ## ITERATION (Th ## ITERATION, P ## ORDER);
#define AUX_LOOP_BODY(ITERATION,ORDER) AUX_AUX_LOOP_BODY(ITERATION,ORDER)
#define LOOP_BODY(ITERATION) AUX_LOOP_BODY(ITERATION, SOLVER_POLYNOMIAL_ORDER)
LOOP(0,N_TESTS,LOOP_BODY)
#endif

// Define fields
#ifdef SOLVER_ADAPT
#define LOOP_BODY(ITERATION) Vh ## ITERATION phi ## ITERATION;
#else
#define LOOP_BODY(ITERATION) Vh phi ## ITERATION;
#endif
LOOP(0,N_TESTS,LOOP_BODY)

// Create empty output file
{ofstream errorFile("output/errors.txt");}

for(int iteration = 0; iteration <= N_ITERATIONS_COARSE; iteration++)
{
    cout << "Calculating errors for iteration " + iteration + " on the coarsest mesh." << endl;

    #ifdef SOLVER_ADAPT
        #define LOOP_BODY(ITERATION) \
        Th ## ITERATION = gmshload("../" + xstr(ITERATION) + "/output/mesh/low-order-mesh-" + (iteration * 2^(N_TESTS - 1 - ITERATION)) + ".msh"); \
        phi ## ITERATION = phi ## ITERATION;
        LOOP(0,N_TESTS,LOOP_BODY)
    #endif


    #define LOOP_BODY(ITERATION) \
        readfreefem("../" + xstr(ITERATION) + "/output/phi/phi-"  + (iteration * 2^(N_TESTS - 1 - ITERATION)) + ".txt", phi ## ITERATION);
    LOOP(0,N_TESTS,LOOP_BODY)

    real[int] errorNormL2(N_TESTS);
    #define LOOP_BODY(ITERATION) \
        Vh error ## ITERATION  = phi ## ITERATION  - phi0;\
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
