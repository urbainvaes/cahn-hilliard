// Dimensions of square
Lx = 1.; // export
Ly = 0.5; // export
s = .1;
t = 0.;
x = 0.;
y = 0.;
z = 0.;

// Label of pores
lpores = 10;
Physical Line(lpores) = {};

// Outside square
points[1] = newp; Point(points[1]) = {0  , 0  , z , s};
points[2] = newp; Point(points[2]) = {Lx , 0  , z , s};
points[3] = newp; Point(points[3]) = {Lx , Ly , z , s};
points[4] = newp; Point(points[4]) = {0  , Ly , z , s};

lines[1] = newl; Line(lines[1]) = {points[1],points[2]};
lines[2] = newl; Line(lines[2]) = {points[2],points[3]};
lines[3] = newl; Line(lines[3]) = {points[3],points[4]};
lines[4] = newl; Line(lines[4]) = {points[4],points[1]};

Periodic Line{lines[2]} = {-lines[4]};

// FreeFem ++ requires label
Physical Line(1) = {lines[1]};
Physical Line(2) = {lines[2]};
Physical Line(3) = {lines[3]};
Physical Line(4) = {lines[4]};

square = newreg;
Line Loop(square) = {lines[1],lines[2],lines[3],lines[4]};

Macro Obstacle

  x1 = - 1.2*lx/2;
  y1 = - ly/2;
  x2 =   1.2*lx/2;
  y2 = - ly/2;
  x3 =   lx/2;
  y3 =   ly/2;
  x4 = - lx/2;
  y4 =   ly/2;

  points[1] = newp; Point(points[1]) = {x + x1 , y + y1 , 0 , s};
  points[2] = newp; Point(points[2]) = {x + x2 , y + y2 , 0 , s};
  points[3] = newp; Point(points[3]) = {x + x3 , y + y3 , 0 , s};
  points[4] = newp; Point(points[4]) = {x + x4 , y + y4 , 0 , s};

  lines[1] = newl; Line(lines[1]) = {points[1],points[2]};
  lines[2] = newl; Line(lines[2]) = {points[2],points[3]};
  lines[3] = newl; Line(lines[3]) = {points[3],points[4]};
  lines[4] = newl; Line(lines[4]) = {points[4],points[1]};

  Physical Line(lpores) += {lines[1]};
  Physical Line(lpores) += {lines[2]};
  Physical Line(lpores) += {lines[3]};
  Physical Line(lpores) += {lines[4]};

  lloop = newreg;
  Line Loop(lloop) = {lines[1],lines[2],lines[3],lines[4]};
Return

// "Characteristic width and height
lx = Lx/1.5; // export
ly = Ly/7;

// Number of obstacles
nPores = 1; // export
topWidth = 1.2 * lx; // export

d = Lx/nPores;

x0 = d/2;
y0 = Ly/2.;

For i In {0:nPores-1}
  x = x0 + i*d;
  y = y0;

  Call Obstacle;
  loops[i] = lloop;
EndFor

// Define surface
domain = news;
Plane Surface(domain) = {square, loops[]};
Physical Surface (1) = {domain};

// View options
Geometry.LabelType = 2;
Geometry.Lines = 1;
Geometry.LineNumbers = 2;
Geometry.Surfaces = 1;
Geometry.SurfaceNumbers = 2;
