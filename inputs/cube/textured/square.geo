Include "geometries/macros-gmsh/square.geo";

// Meshsize
s  = 0.01;

// Dimensions of the cube
Lx = 1;  // export
Ly = 1;  // export

Call Square;
Plane Surface(1) = {lloop};
Physical Surface(1) = {1};
