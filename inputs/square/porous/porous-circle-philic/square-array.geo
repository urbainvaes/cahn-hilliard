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

// Define macro for cube with bl-corner at x,y
Macro Square
  p1 = newp; Point(p1) = {x - lx/2, y - ly/2, 0., s};
  p2 = newp; Point(p2) = {x + lx/2, y - ly/2, 0., s};
  p3 = newp; Point(p3) = {x + lx/2, y + ly/2, 0., s};
  p4 = newp; Point(p4) = {x - lx/2, y + ly/2, 0., s};

  l1 = newl; Line(l1) = {p1, p2};
  l2 = newl; Line(l2) = {p2, p3};
  l3 = newl; Line(l3) = {p3, p4};
  l4 = newl; Line(l4) = {p4, p1};

  // FreeFem ++ requires label
  Physical Line(lpores) += {l1};
  Physical Line(lpores) += {l2};
  Physical Line(lpores) += {l3};
  Physical Line(lpores) += {l4};

  loops[counter] = newl; 
  Line Loop(loops[counter]) = {l1, l2, l3, l4};
  normaldomainlimits[counter] = loops[counter];
Return

Macro Circ
  cp0 = newp; Point(cp0) = {x    , y    , 0, s}; // Center
  cp1 = newp; Point(cp1) = {x - r, y - r, 0, s};
  cp2 = newp; Point(cp2) = {x + r, y - r, 0, s};
  cp3 = newp; Point(cp3) = {x + r, y + r, 0, s};
  cp4 = newp; Point(cp4) = {x - r, y + r, 0, s};

  cl1 = newl; Circle(cl1) = {cp1,cp0,cp2};
  cl2 = newl; Circle(cl2) = {cp2,cp0,cp3};
  cl3 = newl; Circle(cl3) = {cp3,cp0,cp4};
  cl4 = newl; Circle(cl4) = {cp4,cp0,cp1};

  // FreeFem ++ requires label
  Physical Line(lpores) += {cl1};
  Physical Line(lpores) += {cl2};
  Physical Line(lpores) += {cl3};
  Physical Line(lpores) += {cl4};

  loops[counter] = newl; 
  Line Loop(loops[counter]) = {cl1, cl2, cl3, cl4};
  normaldomainlimits[counter] = loops[counter];
Return

For i In {1:nx}
  For j In {1:ny}
    counter += 1;
    x = i*dx + (i-1)*lx + lx/2;
    y = j*dy + (j-1)*ly + ly/2;
    r = 0.07;
    Call Circ;
  EndFor
EndFor

// Define surface
domain = news; Plane Surface(domain) = {normaldomainlimits[]};
Physical Surface ("Domain of computation") = {domain};

// View options
Geometry.LabelType = 2;
Geometry.Lines = 1;
Geometry.LineNumbers = 2;
