Include "macros-gmsh/square.geo";
Include "macros-gmsh/circle.geo";
Include "macros-gmsh/cube.geo";
Include "macros-gmsh/cylinder.geo";

If (!Exists(Lx)) Lx = 1; EndIf
If (!Exists(Ly)) Ly = 1; EndIf
If (!Exists(Lz)) Lz = 1; EndIf
If (!Exists(s)) s = 0.07; EndIf

// Outer cube
  dx   = Lx;
  dy   = Ly;
  dz   = Lz;
  x    = 0.5*Lx;
  y    = 0.5*Ly;
  z    = 0.5*Lz;
  t    = 0.0*Pi;
  surf = 0;

  Call Cube;

  outer_cube_ll = lineloops[];

// Configuration of array
  nx = 3;
  ny = 3;
  nz = 2;

  dx = Lx/(2*nx + 1);
  dy = Ly/(2*ny + 1);
  dz = Lz/(2*nz + 1);

  surf = 1;

  Physical Surface("Array", 21) = {};

// Array of little cubes
For i In {0:nx-1}
  For j In {0:ny-1}
    For k In {0:nz-1}
      
      x = 1.5*dx + 2*i*dx;
      y = 1.5*dy + 2*j*dy;
      z = 1.5*dz + 2*k*dz;

      Call Cube;

      Physical Surface("Array") += {surfaceloop[]};
      array_sl_indices[i*nz*ny + j*nz + k] = surfaceloopindex;
    EndFor
  EndFor
EndFor

// Circle
  x = 0.5*Lx;
  y = 0.5*Ly;
  z = 0;
  r = 0.15;

  Call Circ;

  cloop = lloop;
  circ = newreg;
  Plane Surface(circ) = {cloop};

// Define surfaces of domain
  i1 = newreg; Plane Surface(i1) = {outer_cube_ll[1], cloop};
  i2 = newreg; Plane Surface(i2) = outer_cube_ll[2];
  i3 = newreg; Plane Surface(i3) = outer_cube_ll[3];
  i4 = newreg; Plane Surface(i4) = outer_cube_ll[4];
  i5 = newreg; Plane Surface(i5) = outer_cube_ll[5];
  i6 = newreg; Plane Surface(i6) = outer_cube_ll[6];

// Define volume of domain
  outer_cube_sl_index = newreg;
  Surface Loop(outer_cube_sl_index) = {circ, i1, i2, i3, i4, i5, i6};
  Volume(1) = {outer_cube_sl_index, array_sl_indices[]};

// Define physical entities
  // Outer cube
  Physical Surface(1) = {i1};
  Physical Surface(2) = {i2};
  Physical Surface(3) = {i3};
  Physical Surface(4) = {i4};
  Physical Surface(5) = {i5};
  Physical Surface(6) = {i6};

  // Circle
  Physical Surface(11) = {circ};

  // Domain
  Physical Volume (1) = {1};

// View options
  Geometry.LabelType = 2;
  Geometry.SurfaceNumbers = 2;

  Color Gray
  {
    Surface
    {
      Physical Surface{21}
    };
  }
