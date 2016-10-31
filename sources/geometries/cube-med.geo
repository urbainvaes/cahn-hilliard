Include "macros-gmsh/square.geo";
Include "macros-gmsh/circle.geo";
Include "macros-gmsh/cube.geo";
Include "macros-gmsh/cylinder.geo";

// Dimensions of outside cube
Lx = 1;
Ly = 1;
Lz = 1;
s  = 0.05;

// Create the cylinders
surf = 0;

nx = 3;
ny = 3;

L = Lz/5;
r = Lx/15;

cylinder_upper_loops = {};
cylinder_lower_loops = {};
cylinder_lateral_surfaces = {};

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
        cylinder_lateral_surfaces += news; 
        Ruled Surface(tmp) = {lineloops[k]};
      EndFor
  EndFor
EndFor

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
bottom_surfaces[1] = news; Plane Surface(bottom_surfaces[1]) = {lineloops[1]};
bottom_surfaces[2] = news; Plane Surface(bottom_surfaces[2]) = {lineloops[2]};
bottom_surfaces[3] = news; Plane Surface(bottom_surfaces[3]) = {lineloops[3]};
bottom_surfaces[4] = news; Plane Surface(bottom_surfaces[4]) = {lineloops[4]};
bottom_surfaces[5] = news; Plane Surface(bottom_surfaces[5]) = {lineloops[5]};
bottom_surfaces[6] = news; Plane Surface(bottom_surfaces[6]) = {lineloops[6], cylinder_lower_loops[]};


dz = Lz/2 - L/2;
z = Lz - dz/2;
Call Cube;
top_surfaces[1] = news; Plane Surface(top_surfaces[1]) = {lineloops[1], cylinder_upper_loops[]};
top_surfaces[2] = news; Plane Surface(top_surfaces[2]) = {lineloops[2]};
top_surfaces[3] = news; Plane Surface(top_surfaces[3]) = {lineloops[3]};
top_surfaces[4] = news; Plane Surface(top_surfaces[4]) = {lineloops[4]};
top_surfaces[5] = news; Plane Surface(top_surfaces[5]) = {lineloops[5]};
top_surfaces[6] = news; Plane Surface(top_surfaces[6]) = {lineloops[6]};


// Create volume
surface_loop_index = newreg;
Surface Loop(surface_loop_index) = {bottom_surfaces[1],
                                    bottom_surfaces[2],
                                    bottom_surfaces[3],
                                    bottom_surfaces[4],
                                    bottom_surfaces[5],
                                    bottom_surfaces[6], 
                                    cylinder_lateral_surfaces[],
                                    top_surfaces[1],
                                    top_surfaces[2],
                                    top_surfaces[3],
                                    top_surfaces[4],
                                    top_surfaces[5],
                                    top_surfaces[6] };

domain = newreg;
Volume(domain) = surface_loop_index;
Physical Volume(domain) = surface_loop_index;
