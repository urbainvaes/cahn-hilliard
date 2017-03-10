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
S = .02;
s = .02;

// Use buffer zone
buffer = 0;

// Thickness of buffer zone, where we impose small mesh size
bx = .2*lx;
by = .2*ly;

// Sizes of the domain
Lx = (nx+1)*dx + nx*lx;
Ly = (ny+1)*dy + ny*ly;

// Define domain
Point(1) = {0,  0,  0, S};
Point(2) = {Lx, 0,  0, S};
Point(3) = {Lx, Ly, 0, S};
Point(4) = {0,  Ly, 0, S};

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
bufferloops[0] = border;
normaldomainlimits[0] = border;

// Define macro for cube with bl-corner at x,y
Macro Square
  p1 = newp; Point(p1) = {x     , y     , 0., s};
  p2 = newp; Point(p2) = {x + lx, y     , 0., s};
  p3 = newp; Point(p3) = {x + lx, y + ly, 0., s};
  p4 = newp; Point(p4) = {x     , y + ly, 0., s};

  l1 = newl; Line(l1) = {p1, p2};
  l2 = newl; Line(l2) = {p2, p3};
  l3 = newl; Line(l3) = {p3, p4};
  l4 = newl; Line(l4) = {p4, p1};

  // FreeFem ++ requires label
  Physical Line(lpores) += {l1};
  Physical Line(lpores) += {l2};
  Physical Line(lpores) += {l3};
  Physical Line(lpores) += {l4};

  loops[counter] = newl; Line Loop(loops[counter]) = {l1, l2, l3, l4};
  normaldomainlimits[counter] = loops[counter];

  If (buffer == 1)
    p1 = newp; Point(p1) = {x - bx     , y -by      , 0., S};
    p2 = newp; Point(p2) = {x + lx + bx, y -by      , 0., S};
    p3 = newp; Point(p3) = {x + lx + bx, y + ly + by, 0., S};
    p4 = newp; Point(p4) = {x - bx     , y + ly + by, 0., S};

    l1 = newl; Line(l1) = {p1, p2};
    l2 = newl; Line(l2) = {p2, p3};
    l3 = newl; Line(l3) = {p3, p4};
    l4 = newl; Line(l4) = {p4, p1};

    Physical Line(newl) = {l1};
    Physical Line(newl) = {l2};
    Physical Line(newl) = {l3};
    Physical Line(newl) = {l4};

    bufferloops[counter] = newl; Line Loop(bufferloops[counter]) = {l1, l2, l3, l4};
    bufferzones[counter] = news; Plane Surface(bufferzones[counter]) = {bufferloops[counter], loops[counter]};
    Physical Surface(news) = {bufferzones[counter]};
    normaldomainlimits[counter] = bufferloops[counter];
  EndIf
Return

For i In {1:nx}
  For j In {1:ny}
    counter += 1;
    x = i*dx + (i-1)*lx;
    y = j*dy + (j-1)*ly;
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
