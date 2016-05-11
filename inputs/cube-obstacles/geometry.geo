Include "problem.geo";

// Input variables:
//      - x, y, z: center of the cube
//      - Lx, Ly, Lz : dimensions of the cube
//      - index : starting index for points and lines
Macro Cube

  lx = 0.5*dx;
  ly = 0.5*dy;
  lz = 0.5*dz;

  For i In {0:1}
    i1 = index + 4*i + 1; Point(i1) = {x - lx*Cos(t) + ly*Sin(t), y - lx*Sin(t) - ly*Cos(t), z + (2*i-1)*lz, s};
    i2 = index + 4*i + 2; Point(i2) = {x + lx*Cos(t) + ly*Sin(t), y + lx*Sin(t) - ly*Cos(t), z + (2*i-1)*lz, s};
    i3 = index + 4*i + 3; Point(i3) = {x + lx*Cos(t) - ly*Sin(t), y + lx*Sin(t) + ly*Cos(t), z + (2*i-1)*lz, s};
    i4 = index + 4*i + 4; Point(i4) = {x - lx*Cos(t) - ly*Sin(t), y - lx*Sin(t) + ly*Cos(t), z + (2*i-1)*lz, s};

    Line(i1) = {i1,i2};
    Line(i2) = {i2,i3};
    Line(i3) = {i3,i4};
    Line(i4) = {i4,i1};

    p[4*i + 1] = i1; l[4*i + 1] = i1;
    p[4*i + 2] = i2; l[4*i + 2] = i2;
    p[4*i + 3] = i3; l[4*i + 3] = i3;
    p[4*i + 4] = i4; l[4*i + 4] = i4;
  EndFor

  For i In {1:4}
    Line(index + 8 + i) = {p[i], p[i+4]};
    l[8 + i] = index + 8 + i;
  EndFor

  Line Loop(index + 1) = {l[1] ,  l[2] ,  l[3] ,   l[4] };
  Line Loop(index + 2) = {l[1] , l[10] , -l[5] ,  -l[9] };
  Line Loop(index + 3) = {l[2] , l[11] , -l[6] , -l[10] };
  Line Loop(index + 4) = {l[3] , l[12] , -l[7] , -l[11] };
  Line Loop(index + 5) = {l[4] ,  l[9] , -l[8] , -l[12] };
  Line Loop(index + 6) = {l[5] ,  l[6] ,  l[7] ,   l[8] };

  If (surf == 1)
    ps[1] = index + 1; Plane Surface(ps[1]) = {ps[1]};
    ps[2] = index + 2; Plane Surface(ps[2]) = {ps[2]};
    ps[3] = index + 3; Plane Surface(ps[3]) = {ps[3]};
    ps[4] = index + 4; Plane Surface(ps[4]) = {ps[4]};
    ps[5] = index + 5; Plane Surface(ps[5]) = {ps[5]};
    ps[6] = index + 6; Plane Surface(ps[6]) = {ps[6]};

    Surface Loop(index + 1) = {ps[1],ps[2],ps[3],ps[4],ps[5],ps[6]};
  EndIf
Return

// Input variables:
//      - x, y, z: center of the cylinder
//      - r, L : dimensions of the cylinder
//      - index : starting index for points and lines
Macro Cylinder
  Point(index + 0) = {x    , y    , z - 0.5*L, s}; // Center
  Point(index + 1) = {x - r, y - r, z - 0.5*L, s};
  Point(index + 2) = {x + r, y + r, z - 0.5*L, s};

  Circle(index + 1) = {index + 1,index + 0,index + 2};
  Circle(index + 2) = {index + 2,index + 0,index + 1};

  Point(index + 3) = {x    , y    , z + 0.5*L, s}; // Center
  Point(index + 4) = {x - r, y - r, z + 0.5*L, s};
  Point(index + 5) = {x + r, y + r, z + 0.5*L, s};

  Circle(index + 3) = {index + 4,index + 3,index + 5};
  Circle(index + 4) = {index + 5,index + 3,index + 4};

  Line(index + 5) = {index + 1, index + 4};
  Line(index + 6) = {index + 2, index + 5};

  Line Loop(index + 1) = {index + 1, index + 2};
  Line Loop(index + 2) = {index + 3, index + 4};
  Line Loop(index + 3) = {index + 5, index + 3, -(index + 6), -(index + 1)};
  Line Loop(index + 4) = {index + 5, -(index + 4), -(index + 6), index + 2};

  Plane Surface(index + 1) = {index + 1};
  Plane Surface(index + 2) = {index + 2};
  Ruled Surface(index + 3) = {index + 3};
  Ruled Surface(index + 4) = {index + 4};

  Surface Loop(index + 1) = {index + 1, index + 3, index + 4, index + 2};
Return

// Outer cube
outer_cube = 0;
index = outer_cube;
dx = Lx;
dy = Ly;
dz = Lz;
x = 0.5*Lx;
y = 0.5*Ly;
z = 0.5*Lz;
t = 0.0*Pi;
surf = 0;
Call Cube;

// Inner cube
inner_cube = 1000;
index = inner_cube;
dx = 0.2*Lx;
dy = 0.2*Ly;
dz = 0.3*Lz;
x = 0.3*Lx;
y = 0.3*Ly;
z = 0.5*Lz;
t = 0.25*Pi;
surf = 1;
Call Cube;

// Inner cylinder
inner_cylinder = 2000;
index = inner_cylinder;
x = 0.7*Lx;
y = 0.7*Ly;
z = 0.5*Lz;
r = 0.1*Lx;
L = 0.6*Lz;
Call Cylinder;

// Define surface square
Sx = 0.4 * Lx; // Length in x-direction
Sy = 0.4 * Ly; // Length in y-direction

sp1 = newp; Point(sp1) = {0.5*Lx - 0.5*Sx, 0.5*Ly - 0.5*Sy, Lz};
sp2 = newp; Point(sp2) = {0.5*Lx + 0.5*Sx, 0.5*Ly - 0.5*Sy, Lz};
sp3 = newp; Point(sp3) = {0.5*Lx + 0.5*Sx, 0.5*Ly + 0.5*Sy, Lz};
sp4 = newp; Point(sp4) = {0.5*Lx - 0.5*Sx, 0.5*Ly + 0.5*Sy, Lz};

sl1 = newl; Line(sl1) = {sp1,sp2};
sl2 = newl; Line(sl2) = {sp2,sp3};
sl3 = newl; Line(sl3) = {sp3,sp4};
sl4 = newl; Line(sl4) = {sp4,sp1};

sloop = newreg; Line Loop(sloop) = {sl1,sl2,sl3,sl4};
square = newreg; Plane Surface(square) = {sloop};

// Define surface circle
cp0 = newp; Point(cp0) = {Ox    , Oy    , 0, s}; // Center
cp1 = newp; Point(cp1) = {Ox - r, Oy - r, 0, s};
cp2 = newp; Point(cp2) = {Ox + r, Oy - r, 0, s};
cp3 = newp; Point(cp3) = {Ox + r, Oy + r, 0, s};
cp4 = newp; Point(cp4) = {Ox - r, Oy + r, 0, s};

cl1 = newl; Circle(cl1) = {cp1,cp0,cp2};
cl2 = newl; Circle(cl2) = {cp2,cp0,cp3};
cl3 = newl; Circle(cl3) = {cp3,cp0,cp4};
cl4 = newl; Circle(cl4) = {cp4,cp0,cp1};

cloop = newreg; Line Loop(cloop) = {cl1,cl2,cl3,cl4};
circ = newreg; Plane Surface(circ) = {cloop};

// Define surfaces
Plane Surface(1) = {1,cloop};
Plane Surface(2) = {2};
Plane Surface(3) = {3};
Plane Surface(4) = {4};
Plane Surface(5) = {5};
Plane Surface(6) = {6,sloop};

// Define volumes
Surface Loop(1) = {square, 2, 3, 4, 5, 6, 1, circ};
Volume(1) = {outer_cube + 1, inner_cube + 1, inner_cylinder + 1};

// Define physical entities
Physical Surface(1) = {1};
Physical Surface(2) = {2};
Physical Surface(3) = {3};
Physical Surface(4) = {4};
Physical Surface(5) = {5};
Physical Surface(6) = {6};
Physical Surface(11) = {circ};
Physical Surface(12) = {square};
Physical Surface(13) = {inner_cube + 1, inner_cube + 2, inner_cube + 3, inner_cube + 4, inner_cube + 5, inner_cube + 6}; 
Physical Surface(14) = {inner_cylinder + 1, inner_cylinder + 2, inner_cylinder + 3, inner_cylinder + 4}; 
Physical Volume (1) = {1};

// View options
Geometry.LabelType = 2;
Geometry.Surfaces = 1;
Geometry.SurfaceNumbers = 2;
