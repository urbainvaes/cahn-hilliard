Include "macros-gmsh/square.geo";
Include "macros-gmsh/circle.geo";
Include "macros-gmsh/cube.geo";
Include "macros-gmsh/cylinder.geo";

// Dimensions of outside cube
Lx = 1;
Ly = 1;
Lz = 1; // export
s  = 0.1;

// Create the cylinders
surf = 0;

nx = 2;
ny = 2;

L = Lz/5;
r = Lx/15;

cylinder_upper_loops = {};
cylinder_lower_loops = {};
cylinder_lateral_surfaces = {};

s = s/4; 
For i In {0:nx-1}
  For j In {0:ny-1}
      x = (Lx/nx)*(0.5 + i);
      y = (Ly/ny)*(0.5 + j);
      z = Lz/2;
      Call Cylinder; 
      cylinder_lower_loops += {lineloops[1]};
      cylinder_upper_loops += {lineloops[2]};

      For k In {3:6}
        tmp = news;
        cylinder_lateral_surfaces += tmp;
        Ruled Surface(tmp) = {lineloops[k]};
      EndFor
  EndFor
EndFor
s = 4*s;

x = 0.5;
y = 0.5;
lx = 0.5;
ly = 0.5;
t = 0;

// Create cubes
surf = 0;

dx = Lx;
dy = Ly;

dz = Lz/2 - L/2;
z = dz/2;
Call Cube;
bottom_surfaces[0] = news; Plane Surface(bottom_surfaces[0]) = {lineloops[1]};
bottom_surfaces[1] = news; Plane Surface(bottom_surfaces[1]) = {lineloops[2]};
bottom_surfaces[2] = news; Plane Surface(bottom_surfaces[2]) = {lineloops[3]};
bottom_surfaces[3] = news; Plane Surface(bottom_surfaces[3]) = {lineloops[4]};
bottom_surfaces[4] = news; Plane Surface(bottom_surfaces[4]) = {lineloops[5]};
bottom_surfaces[5] = news; Plane Surface(bottom_surfaces[5]) = {lineloops[6], cylinder_lower_loops[]};
bottom_lateral_surfaces = {
  bottom_surfaces[1],
  bottom_surfaces[2],
  bottom_surfaces[3],
  bottom_surfaces[4]
};


dz = Lz/2 - L/2;
z = Lz - dz/2;
Call Cube;
top_surfaces[0] = news; Plane Surface(top_surfaces[0]) = {lineloops[1], cylinder_upper_loops[]};
top_surfaces[1] = news; Plane Surface(top_surfaces[1]) = {lineloops[2]};
top_surfaces[2] = news; Plane Surface(top_surfaces[2]) = {lineloops[3]};
top_surfaces[3] = news; Plane Surface(top_surfaces[3]) = {lineloops[4]};
top_surfaces[4] = news; Plane Surface(top_surfaces[4]) = {lineloops[5]};
top_surfaces[5] = news; Plane Surface(top_surfaces[5]) = {lineloops[6]};
top_lateral_surfaces = {
  top_surfaces[1],
  top_surfaces[2],
  top_surfaces[3],
  top_surfaces[4]
};

// Create volume
surface_loop = bottom_surfaces[];
surface_loop += top_surfaces[];
surface_loop += cylinder_lateral_surfaces[];

Physical Surface(1) = bottom_surfaces[0];
Physical Surface(2) = top_surfaces[5];
Physical Surface(3) = {bottom_lateral_surfaces[], top_lateral_surfaces[] };
Physical Surface(4) = {bottom_surfaces[5], top_surfaces[0]};
Physical Surface(5) = {cylinder_lateral_surfaces[]};

surface_loop_index = newreg;
Surface Loop(surface_loop_index) = surface_loop[];
Volume(1) = {surface_loop_index};
Physical Volume(1) = {1};

// View options
Geometry.LabelType = 2;
Geometry.Surfaces = 1;
Geometry.SurfaceNumbers = 2;

Color Gray
{
  Surface {
    Physical Surface{5},
    Physical Surface{4}
  };
}
