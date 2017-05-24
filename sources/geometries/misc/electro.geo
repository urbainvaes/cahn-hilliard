// Dimensions of square
Lx = 1.; // export
Ly = 1.; // export

// Mesh size
s = 0.10;

// Number of divisions
n = 5;
dx = Lx/(2*n + 1);

// Height
yd = 0.1; // export

// Dimensions of the bar
tx = Lx/30;
ty = Ly/2;

If (yd > 0.01)
  For i In {0:n-1}
    points[4*i + 1] = newp; Point(points[4*i + 1]) = {(Lx-dx)/n*i, 0, 0, s};
    points[4*i + 2] = newp; Point(points[4*i + 2]) = {(Lx-dx)/n*i + dx, 0, 0, s};
    points[4*i + 3] = newp; Point(points[4*i + 3]) = {(Lx-dx)/n*i + dx, yd, 0, s};
    points[4*i + 4] = newp; Point(points[4*i + 4]) = {(Lx-dx)/n*i + 2*dx, yd, 0, s};
  EndFor
  points[4*n + 1] = newp; Point(points[4*n + 1]) = {Lx- dx, 0, 0, s};
  points[4*n + 2] = newp; Point(points[4*n + 2]) = {Lx, 0, 0, s};

  For i In {0:n-1}
    lines[4*i + 1 - 1] = newl; Line(lines[4*i + 1 - 1]) = {points[4*i + 1], points[4*i + 2]};
    lines[4*i + 2 - 1] = newl; Line(lines[4*i + 2 - 1]) = {points[4*i + 2], points[4*i + 3]};
    lines[4*i + 3 - 1] = newl; Line(lines[4*i + 3 - 1]) = {points[4*i + 3], points[4*i + 4]};
    lines[4*i + 4 - 1] = newl; Line(lines[4*i + 4 - 1]) = {points[4*i + 4], points[4*i + 5]};
  EndFor
  lines[4*n + 1 - 1] = newl; Line(lines[4*n + 1 - 1]) = {points[4*n + 1], points[4*n + 2]};

  begin = points[1];
  end = points[4*n + 2];
EndIf

If (yd <= 0.01)
  begin = newp; Point(begin) = {0, 0, 0, s};
  end = newp; Point(end) = {Lx, 0, 0, s};
  lines[0] = newl; Line(lines[0]) = {begin, end};
EndIf

If (ty > 0.01)
  ptige[0] = newp; Point(ptige[0]) = {Lx/2 + tx/2, Ly, 0, s};
  ptige[1] = newp; Point(ptige[1]) = {Lx/2 + tx/2, Ly - ty, 0, s};
  ptige[2] = newp; Point(ptige[2]) = {Lx/2 - tx/2, Ly - ty, 0, s};
  ptige[3] = newp; Point(ptige[3]) = {Lx/2 - tx/2, Ly, 0, s};

  ltige[0] = newl; Line(ltige[0]) = {ptige[0], ptige[1]};
  ltige[1] = newl; Line(ltige[1]) = {ptige[1], ptige[2]};
  ltige[2] = newl; Line(ltige[2]) = {ptige[2], ptige[3]};

  tige_begin = ptige[0];
  tige_end   = ptige[3];
EndIf

If (ty <= 0.01)
  ptige[0] = newp; Point(ptige[0]) = {Lx/2 + tx/2, Ly, 0, s};
  ptige[1] = newp; Point(ptige[1]) = {Lx/2 - tx/2, Ly, 0, s};

  ltige[0] = newl; Line(ltige[0]) = {ptige[0], ptige[1]};

  tige_begin = ptige[0];
  tige_end   = ptige[1];
EndIf

pleft = newp; Point(pleft) = {0, Ly, 0, s};
lleft[0] = newl; Line(lleft[0]) = {tige_end, pleft};
lleft[1] = newl; Line(lleft[1]) = {pleft, begin};

pright = newp; Point(pright) = {Lx, Ly, 0, s};
lright[0] = newl; Line(lright[0]) = {end, pright};
lright[1] = newl; Line(lright[1]) = {pright, tige_begin};

Line Loop(1) = {lines[], lright[], ltige[], lleft[]};
Plane Surface(1) = {1};

Physical Line("Bottom",1) = {lines[]};
Physical Line("Sides",2) = {lleft[1], lright[0]};
Physical Line("Top",3) = {lleft[0], lright[1]};
Physical Line("Tige",4) = {ltige[]};
Physical Surface("Domain",1) = {1};

// View options
Geometry.LabelType = 2;
Geometry.Lines = 1;
Geometry.LineNumbers = 2;
Geometry.Surfaces = 1;
Geometry.SurfaceNumbers = 2;
