Include "problem.geo";

For i In {0:np}
  Point(4*i + 1) = { 0,  0,  i * (Lz/np), s};
  Point(4*i + 2) = {Lx,  0,  i * (Lz/np), s};
  Point(4*i + 3) = {Lx, Ly,  i * (Lz/np), s};
  Point(4*i + 4) = { 0, Ly,  i * (Lz/np), s};

  Line(4*i + 1) = {4*i + 1, 4*i + 2};
  Line(4*i + 2) = {4*i + 2, 4*i + 3};
  Line(4*i + 3) = {4*i + 3, 4*i + 4};
  Line(4*i + 4) = {4*i + 4, 4*i + 1};

  Line Loop(i + 1) = {4*i + 1, 4*i + 2, 4*i + 3, 4*i + 4};
EndFor

For i In {1:np}
  Plane Surface(i + 1) = {i + 1};
EndFor

// Number of horizontal lines
hl = 4*(np + 1);
counter = 1;
For i In {0:np-1}
  For j In {1:4}
    Line(hl + 4*i + j) = {4*i + j, 4*i + 4 + j};
  EndFor
  For j In {1:4}
    index = np + 1 + 4*i + j; lateral[counter] = index; counter += 1;
    Line Loop(index) = {4*i + j, hl + 4*i + 1 + j%4, -(4*i + 4 + j), -(hl + 4*i + j)};
    Plane Surface(index) = {np + 1 + 4*i + j};
  EndFor
EndFor

// Internal circle
cp0 = newp; Point(cp0) = {Ox    , Oy    , 0, s};
cp1 = newp; Point(cp1) = {Ox - r, Oy - r, 0, s};
cp2 = newp; Point(cp2) = {Ox + r, Oy - r, 0, s};
cp3 = newp; Point(cp3) = {Ox + r, Oy + r, 0, s};
cp4 = newp; Point(cp4) = {Ox - r, Oy + r, 0, s};

cl1 = newl; Circle(cl1) = {cp1,cp0,cp2};
cl2 = newl; Circle(cl2) = {cp2,cp0,cp3};
cl3 = newl; Circle(cl3) = {cp3,cp0,cp4};
cl4 = newl; Circle(cl4) = {cp4,cp0,cp1};

cloop = newreg; Line Loop(cloop) = {cl1,cl2,cl3,cl4};
Plane Surface(1) = {1,cloop};
circ = newreg;
Plane Surface(circ) = {cloop};

Surface Loop(1) = {2, np + 2, np + 3, np + 4, np + 5, 1, circ};
Volume(1) = {1};
For i In {2:np}
  Surface Loop(i) = {i + 1, np + 4*i - 2, np + 4*i - 1, np + 4*i, np + 4*i + 1, i};
  Volume(i) = {i};
EndFor

// Define physical entities
DISK                   = 1;
DISK_COMPLEMENT        = 2;
LATERAL_FACES_CUBE     = 3;
OPPOSITE_FACE          = 4;

Physical Surface (DISK)               = {circ};
Physical Surface (DISK_COMPLEMENT)    = {1};
Physical Surface (LATERAL_FACES_CUBE) = {lateral[]};
Physical Surface (OPPOSITE_FACE)      = {np + 1};

For i In {1:np}
  Physical Volume (i) = {i};
EndFor

// View options
Geometry.LabelType = 2;
Geometry.Surfaces = 1;
Geometry.SurfaceNumbers = 2;
