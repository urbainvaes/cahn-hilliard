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
```
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

## Authors
Benjamin Aymard started the project in October 2015, and Urbain Vaes joined in March 2016.
