OUTDATED

# Cahn-Hilliard solver
This repository contains the code we developped to simulate the Cahn-Hilliard equation in 2 and 3 dimensions.

## Dependencies
This code depends on the following free and open-source programs:

- **Gmsh**, to generate the mesh and do the post-processing;
- **FreeFem++**, to solve the PDE numerically;
- **Paraview**, to visualize results;
- **Gnuplot**, to produce plots;
- **GNU Make**, to build the project;
- **cpp**, to configure the solver.

## Installation
To code of the project can be obtained by cloning the git repository.

`git clone https://github.com/urbainvaes/cahn-hilliard`

## Getting started
A simulation is defined by three elements:

- A **geometry**, which must be described by a Gmsh .geo file.
- A **problem configuration**, which must be written in the FreeFem++ language,
    and specifies the initial and boundary conditions of the problem,
    based on the physical labels defined in the **geometry**.
    In addition, this file can be used to specify the physical parameters of the problem (interface thickness, mobility, etc.)
    and the parameters of the solver (value of time step, number of steps).
    If left undefined, default parameters are used.
- A **post-processing file**, which produces pictures or videos from the output produced by the solver.

### Creating a new simulation
Below, we describe step by step how to create a simple simulation for the coalescence of two droplets in 2D, which we name *example-droplets*.

The first step is to create the directory *inputs/example-droplets* (`mkdir -p inputs/example-droplets`).
and to define each of the elements above.

- For the **geometry**, we create a file *square.geo* in the newly created directory.
  This file defines a simple square, assigns the label 1 to the domain, and the labels 1,2,3,4 to the boundaries.

```
// Dimensions of square
Lx = 1;
Ly = 1;

// Mesh size;
s = .01;

Point(1) = {0,  0,  0, s};
Point(2) = {Lx, 0,  0, s};
Point(3) = {Lx, Ly, 0, s};
Point(4) = {0,  Ly, 0, s};

Line(1) = {1,2};
Line(2) = {2,3};
Line(3) = {3,4};
Line(4) = {4,1};

Line Loop(1) = {1,2,3,4};
Plane Surface(1) = {1};

Physical Surface (1) = {1};
Physical Line (1) = {1};
Physical Line (2) = {2};
Physical Line (3) = {3};
Physical Line (4) = {4};

// View options
Geometry.LabelType = 2;
Geometry.Lines = 1;
Geometry.LineNumbers = 2;
Geometry.Surfaces = 1;
Geometry.SurfaceNumbers = 2;
```
- Next, we write the **problem configuration** in a file *coalescence.pde*, in the same directory.
  This file must define initial and boundary conditions.
```
// Initial condition
real radius = 0.2;

real x1 = 0.5 + radius*1.1;
real y1 = 0.5;
func droplet1 = ((x - x1)^2 + (y - y1)^2 < radius^2 ? 1.5 : -0.5);

real x2 = 0.5 - radius*1.1;
real y2 = 0.5;
func droplet2 = ((x - x2)^2 + (y - y2)^2 < radius^2 ? 1.5 : -0.5);

func phi0 = droplet1 + droplet2;
func mu0 = 0;
[phi, mu] = [phi0, mu0];

// Boundary conditions (Hydrophobic boundaries)
varf varBoundary([phi1,mu1], [phi2,mu2]) =
  int2d(Th,1,2,3,4) (-5*mu2)
;

// Value of epsilon
eps = 0.04;

// Time step
dt = 1 * 1e-6;

// Number of iterations
nIter = 400;
```
- The program used for visualization in 2D is **paraview**, and so the view must be callable by pvpython.
  The specification of this part is less flexible, and we recommend that you start by taking the following script.
```python
# Import modules
import re
import glob
import sys
import optparse
from paraview.simple import *

# Parse command line options
parser = optparse.OptionParser()
parser.add_option('-v', '--video', dest = 'file_video')
parser.add_option('-i', '--input', dest = 'field_name')
parser.add_option('-r', '--range', dest = 'range')
(options, args) = parser.parse_args()

# Ask for file name if undefined
if options.field_name is None:
    options.field_name = raw_input('Enter field name:')

# Paraview code
paraview.simple._DisableFirstRenderCameraReset()

# Read data file
files = sorted(glob.glob("output/"+options.field_name+".*.vtk"), key=lambda x: int(x.split('.')[1]))
scalarField = LegacyVTKReader(FileNames=files)

# Retrieve name of scalar field
cellData = str(scalarField.GetCellDataInformation().GetFieldData())
list_data_names = re.findall(r'Name: (.+)', cellData)
list_data_names.remove('Label')
data_name = list_data_names[0];

# Animation
animationScene = GetAnimationScene()
animationScene.UpdateAnimationUsingDataTimeSteps()

# Get active view and display scalar field in it
renderView = GetActiveViewOrCreate('RenderView')
display = Show(scalarField, renderView)

# Set field to color
ColorBy(display, ('CELLS', data_name))

# show color bar/color legend
display.SetScalarBarVisibility(renderView, True)

# Set range
if options.range is None:
    display.RescaleTransferFunctionToDataRange(True)
else:
    bounds = options.range.split(',')
    scalarLUT = GetColorTransferFunction(data_name)
    scalarLUT.RescaleTransferFunction(float(bounds[0]), float(bounds[1]))

# reset view to fit data
renderView.ResetCamera()

# Set representation type
# display.SetRepresentationType('Surface With Edges')
display.SetRepresentationType('Surface')

# Save video or play animation
if options.file_video is not None:
    WriteAnimation(options.file_video, Magnification=1, FrameRate=40.0, Compression=True)
else:
    animationScene.Play()
```

To finish specifying the problem, we must create a configuration file *config.mk* in the same directory,
to specify that the geometry, problem, and post-processing are described by the files we created.
```
DIMENSION = 2               # Dimension of the problem
GEOMETRY = square.geo       # File describing the geometry
PROBLEM = coalescence.pde   # File describing the problem
VIEW = view.py              # File used for post-processing
```
### Executing the simulation
Once all the elements of the simulation have been specified, it can be run.
Since the folder *inputs* can contain the parameters for many simulations,
the first step is to specify that we want to run the *example-droplets* example.
This is done with the command `make install`, which creates the directory *tests/example-droplets*,
which is where the different programs (gmsh, FreeFem++, gnuplot) will be executed,
and where the outputs and temporary files will be stored.

Once this is done, we can proceed to create a mesh using `make mesh` and run FreeFem++ for the problem using `make run`.
The run generates output files in the directory *tests/example-droplets/output/*, which can be read by the file *view.py* to produce animation.
One can see the simulation results using `make visualization`, and create a video using `make video`.

## Documentation
This section provides additional documentation about the code.

### Targets of Makefile in top directory
The Makefile in the top directory of the project defines the following targets:
- **install**: lists the simulations defined in inputs, prompts the user to select one and:

    - Ensures that the directory *tests/simulation-name* exists, or creates it if necessary.
    - Creates folders for the output, pictures and logs in the newly created directory, if necessary.
    - Copies (using hard links) all the files from *inputs/simulation-name* and *sources* to the new directory.
    - Creates a file *.problem* containing the name of the simulation in the root directory.

- **uninstall**: removes the file *.problem*.
- **clean-all**: removes the directory *tests*, which contains the outputs of all the simulations run.
- **.DEFAULT**: when calling make with any other target than the three described above,
GNU Make will pass the target to the *Makefile* in the subdirectory *tests/simulation-name*,
where *simulation-name* is read from the file *.problem* created at installation.

### Targets of Makefile in subdirectories
Below, **GEOMETRY**, **PROBLEM** and **VIEW** are the variables defined in the configuration file.
- **mesh** : creates the file *output/mesh.msh* from the file **GEOMETRY**.
- **run** : preprocess and execute *solver.pde* using FreeFem++, using the **PROBLEM**.
- **visualization** : shows the simulation results in Paraview (2D) or Gmsh (3D) using the file **VIEW**.
- **video** : same as **visualization**, but create a video from the frames.
- **view** : view video using vlc.
- **plots** : create plots of the physical quantities based on script in *sources/gnuplot/thermo.plt*.

### Use predefined geometries and views
In the simple example above, we created new files for the geometry, the problem and the post-processing,
and referred to these files for the configuration file *config.mk*.
Often, however, one would like to use the same geometry or post-processing for different simulations.
In addition, this repository defines geometries in *sources/geometries* and views in *sources/views*.
Since these two folders will both be copied to the simulation directory (*tests/simulation-name*),
they can be used for the simulation.
For example, instead of rewriting a *.geo* for a square, one could use the readily available file *sources/geometries/square.geo*,
and refer to it from the configuration file.
The path to the file must be relative to the execution directory, i.e. we have to write
```
GEOMETRY = geometries/square.geo.
```

## Modules of the code
Several modules can be activated to simulate more complicated models.
To activate a module, add a line "MODULE = 1" in *config.mk*.
Each of the modules is described below

### Module *adapt*
The use of this module activates mesh-adaptation.

In 2D, the *FreeFem++* built-in function `adaptmesh` is use,
with parameters `hmax = 0.1` and `hmin = hmax/64`.

In 3D, the metric field used for the adaptation is used using `mshmet`,
with parameters `hmax = 0.1` and `hmin = hmax/20`, 
after which the adaptation is accomplished by *Tetgen* through the *FreeFem++* function `tetgreconstruction`.

In both cases,
the default values of `hmin` and `hmax` have been chosen based on a number of examples
and usually provide good results,
but they can be changed if desired in the problem configuration file.

### Module *PLOT*
When activated, the solver will display a plot of the solution at each time step.
Note that this slows down the simulation.

### Module *NS*
This modules adds Navier-Stokes equations to the sytem of equations of the simulation.
To use this module, boundary conditions for the pressure and velocity fields have to be specified in the problem file.
```
varf varUBoundary(u, test) = ...;
varf varVBoundary(v, test) = ...;
varf varPBoundary(p, test) = ...;
```
Physical parameters can also be defined, and will take default values if not.
The different parameters, with default values, are defined below:

- `Re` (default: 1) is the Reynolds number of the flow,
  which is assumed to take a constant value across the two phases.
- `Ca` (default: 1) is the capillary number.
- `muGradPhi` (default: 1) is a parameter prescribing the discretization used for the capillary term.
  Its value must be 1, to use the discretization `mu*grad(phi)`, or 0, to use `phi*grad(mu)`.

### Module *ELECTRO* (unstable)
Using this requires the definition of

- epsilonR1: relative permittivity in phase *phi = -1*.
- epsilonR2: relative permittivity in phase *phi = 1*.

When enabled, the system will be coupled to the Poisson equation for the electric potential,
through the addition of an additional term in the free energy.

### Module *GRAVITY* (unstable)
Using this requires the definition of

- `rho1`: specific mass of phase *phi = -1*.
- `rho2`: specific mass of phase *phi = 1*.
- `gx`: x-component of the gravity vector.
- `gy`: y-component of the gravity vector.
- `gz`: In 3D, z-component of the gravity vector.

When enabled, gravity will be added to the simulation.

## Authors
Benjamin Aymard started the project in October 2015, and Urbain Vaes joined in March 2016.
