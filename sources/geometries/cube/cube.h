#ifndef CONFIG_Lx
#define CONFIG_Lx 1
#endif

#ifndef CONFIG_Ly
#define CONFIG_Ly 1
#endif


#ifndef CONFIG_Lz
#define CONFIG_Lz 1
#endif

#ifndef CONFIG_s
#define CONFIG_s 0.04
#endif

#ifndef CONFIG_r
#define CONFIG_r 0.1*Lx
#endif

Lx = CONFIG_Lx;
Ly = CONFIG_Ly;
Lz = CONFIG_Lz;
s  = CONFIG_s;
r  = CONFIG_r;

#include "../macros-gmsh/circle.geo"
#include "../macros-gmsh/cube.geo"

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

// Circle
  x = 0.5*Lx;
  y = 0.5*Ly;
  z = 0;

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

  domain = newreg;
  Volume(domain) = outer_cube_sl_index;

// Define physical entities

  // Circle
  Physical Surface(1) = {circ};

  // Complement of circle
  Physical Surface(2) = {i1};

  // Lateral faces of the cube
  Physical Surface(3) = {i2,i3,i4,i5};

  // Opposite face
  Physical Surface(4) = {i6};

  // Domain
  Physical Volume (1) = {domain};

// View options
  Geometry.LabelType = 2;
  Geometry.Surfaces = 1;
  Geometry.SurfaceNumbers = 2;

Color Gray
{
  Surface {
    Physical Surface{1},
    Physical Surface{2}
  };
}

// vim:ft=gmsh:
