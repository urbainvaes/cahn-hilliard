// Number of cubes in each dimension
nx = 5;
ny = 5;

// Label of pores
lpores = 10;
Physical Line(lpores) = {};

// Dimensions of small squares
lx = 0.2;
ly = 0.2;

// Space between the cubes
dx = 0.2;
dy = 0.2;

// Mesh size;
s = .02;

// Sizes of the domain
Lx = (nx+1)*dx + nx*lx;
Ly = (ny+1)*dy + ny*ly;

// Define domain
Point(1) = {0,  0,  0, s};
Point(2) = {Lx, 0,  0, s};
Point(3) = {Lx, Ly, 0, s};
Point(4) = {0,  Ly, 0, s};

Line(1) = {1,2};
Line(2) = {2,3};
Line(3) = {3,4};
Line(4) = {4,1};

// Define physical line
Physical Line (1) = {1};
Physical Line (2) = {2};
Physical Line (3) = {3};
Physical Line (4) = {4};

border = newl; Line Loop(border) = {1,2,3,4};

// Counter for line loops
counter = 0;

// Array containing line loops
loops[0] = border;
normaldomainlimits[0] = border;

For i In {1:nx}
  For j In {1:ny}
    counter += 1;
    x = i*dx + (i-1)*lx + lx/2;
    y = j*dy + (j-1)*ly + ly/2;
    Call Square;
  EndFor
EndFor

// Define surface
domain = news; Plane Surface(domain) = {normaldomainlimits[]};
Physical Surface ("Domain of computation") = {domain};

// View options
Geometry.LabelType = 2;
Geometry.Lines = 1;
Geometry.LineNumbers = 2;
