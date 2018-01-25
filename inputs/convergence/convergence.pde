#include xstr(GITROOT/sources/freefem/writers.pde)

// Load package
load "gmsh"

// Number of iterations in main loop
#ifdef TIME_STEP_CONVERGENCE
  #define N_MAIN_LOOP N_ITERATIONS_COARSE
#endif
#ifdef SPACE_STEP_CONVERGENCE
  #define N_MAIN_LOOP SOLVER_NITER
#endif


// Iteration of test to consider when iteration in main loop is 'iteration'
#ifdef TIME_STEP_CONVERGENCE
  #define TEST_STEP(ITERATION) (iteration * 2^(N_TESTS - 1 - ITERATION))
#endif
#ifdef SPACE_STEP_CONVERGENCE
  #define TEST_STEP(ITERATION) iteration
#endif


// Set variables depending of polynomial order
#if SOLVER_POLYNOMIAL_ORDER == 1
  #define MESH_PREFIX "mesh-"
  #define EL_TYPE P1
#endif
#if SOLVER_POLYNOMIAL_ORDER == 2
  #define MESH_PREFIX "low-order-mesh-"
  #define EL_TYPE P2
#endif


// If there are different meshes
#if defined(SOLVER_MESH_ADAPTATION) || defined(SPACE_STEP_CONVERGENCE)
  #define MESH_ERROR "output/mesh.msh"
#else
  #define MESH_ERROR "../0/output/mesh.msh"
#endif


// Read fine mesh
mesh ThError = gmshload(MESH_ERROR);

// Define finite element space (! P1 or P2 !)
#if defined(SOLVER_MESH_ADAPTATION) || defined(SPACE_STEP_CONVERGENCE)
fespace VhError(ThError,P2);
#else
fespace VhError(ThError,EL_TYPE);
#endif

// Meshes for each of the meshsizes
#if defined(SOLVER_MESH_ADAPTATION) || defined(SPACE_STEP_CONVERGENCE)
#define LOOP_BODY(ITERATION) mesh Th ## ITERATION = gmshload("../" + xstr(ITERATION) + "/output/mesh.msh");
LOOP(0,N_TESTS,LOOP_BODY)
#endif

// Define finite element spaces
#if defined(SOLVER_MESH_ADAPTATION) || defined(SPACE_STEP_CONVERGENCE)
#define AUX_AUX_LOOP_BODY(ITERATION,EL_TYPE) fespace Vh ## ITERATION (Th ## ITERATION, EL_TYPE);
#define LOOP_BODY(ITERATION) AUX_AUX_LOOP_BODY(ITERATION, EL_TYPE)
LOOP(0,N_TESTS,LOOP_BODY)
#endif

// Define fields
#if defined(SOLVER_MESH_ADAPTATION) || defined(SPACE_STEP_CONVERGENCE)
#define LOOP_BODY(ITERATION) Vh ## ITERATION phi ## ITERATION;
#else
#define LOOP_BODY(ITERATION) VhError phi ## ITERATION;
#endif
LOOP(0,N_TESTS,LOOP_BODY)

// Create empty output file
{ofstream errorFile("output/errors.txt");}

for(int iteration = 0; iteration <= N_MAIN_LOOP; iteration++)
{
    cout << "Calculating errors for iteration " + iteration + "." << endl;

    #ifdef SOLVER_MESH_ADAPTATION
        #define LOOP_BODY(ITERATION) \
        Th ## ITERATION = gmshload("../" + xstr(ITERATION) + "/output/mesh/" + MESH_PREFIX + TEST_STEP(ITERATION) + ".msh"); \
        phi ## ITERATION = phi ## ITERATION;
        LOOP(0,N_TESTS,LOOP_BODY)
    #endif

    #define LOOP_BODY(ITERATION) \
        readfreefem("../" + xstr(ITERATION) + "/output/phi/phi-"  + TEST_STEP(ITERATION) + ".txt", phi ## ITERATION);
    LOOP(0,N_TESTS,LOOP_BODY)

    real[int] errorNormL2(N_TESTS);
    #define LOOP_BODY(ITERATION) \
        VhError error ## ITERATION  = phi ## ITERATION  - phi0; \
        errorNormL2[ITERATION]  = sqrt(int2d(ThError) (error ## ITERATION  * error ## ITERATION ));
    LOOP(1,N_TESTS,LOOP_BODY)

    // Write errors to output files
    {
        ofstream errorFile("output/errors.txt", append);
        for (int jOut = 0; jOut < N_TESTS; jOut++)
            errorFile << errorNormL2[jOut] << " ";
        errorFile << endl;
    }
}
