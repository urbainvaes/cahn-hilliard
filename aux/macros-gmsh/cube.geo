// Input variables:
//      - x, y, z: center of the cube
//      - dx, dy, dz : dimensions of the cube
//      - t : angle in the x-y plane
//      - index : starting index for points and lines
Macro Cube

  lx = 0.5*dx;
  ly = 0.5*dy;
  lz = 0.5*dz;

  For i In {0:1}
    p[4*i + 1] = newp; Point(p[4*i + 1]) = {x - lx*Cos(t) + ly*Sin(t), y - lx*Sin(t) - ly*Cos(t), z + (2*i-1)*lz, s};
    p[4*i + 2] = newp; Point(p[4*i + 2]) = {x + lx*Cos(t) + ly*Sin(t), y + lx*Sin(t) - ly*Cos(t), z + (2*i-1)*lz, s};
    p[4*i + 3] = newp; Point(p[4*i + 3]) = {x + lx*Cos(t) - ly*Sin(t), y + lx*Sin(t) + ly*Cos(t), z + (2*i-1)*lz, s};
    p[4*i + 4] = newp; Point(p[4*i + 4]) = {x - lx*Cos(t) - ly*Sin(t), y - lx*Sin(t) + ly*Cos(t), z + (2*i-1)*lz, s};

    l[4*i + 1] = newl; Line(l[4*i + 1]) = {p[4*i + 1], p[4*i + 2]};
    l[4*i + 2] = newl; Line(l[4*i + 2]) = {p[4*i + 2], p[4*i + 3]};
    l[4*i + 3] = newl; Line(l[4*i + 3]) = {p[4*i + 3], p[4*i + 4]};
    l[4*i + 4] = newl; Line(l[4*i + 4]) = {p[4*i + 4], p[4*i + 1]};
  EndFor

  For i In {1:4}
    l[8 + i] = newl; Line(l[8 + i]) = {p[i], p[i+4]};
  EndFor

  lineloops[1] = newreg; Line Loop(lineloops[1]) = {l[1] ,  l[2] ,  l[3] ,   l[4] };
  lineloops[2] = newreg; Line Loop(lineloops[2]) = {l[1] , l[10] , -l[5] ,  -l[9] };
  lineloops[3] = newreg; Line Loop(lineloops[3]) = {l[2] , l[11] , -l[6] , -l[10] };
  lineloops[4] = newreg; Line Loop(lineloops[4]) = {l[3] , l[12] , -l[7] , -l[11] };
  lineloops[5] = newreg; Line Loop(lineloops[5]) = {l[4] ,  l[9] , -l[8] , -l[12] };
  lineloops[6] = newreg; Line Loop(lineloops[6]) = {l[5] ,  l[6] ,  l[7] ,   l[8] };

  If (surf == 1)
    surfaces[1] = news; Plane Surface(surfaces[1]) = {lineloops[1]};
    surfaces[2] = news; Plane Surface(surfaces[2]) = {lineloops[2]};
    surfaces[3] = news; Plane Surface(surfaces[3]) = {lineloops[3]};
    surfaces[4] = news; Plane Surface(surfaces[4]) = {lineloops[4]};
    surfaces[5] = news; Plane Surface(surfaces[5]) = {lineloops[5]};
    surfaces[6] = news; Plane Surface(surfaces[6]) = {lineloops[6]};

    surfaceloopindex = newreg;
    surfaceloop = {surfaces[1], surfaces[2], surfaces[3], surfaces[4], surfaces[5], surfaces[6]};
    Surface Loop(surfaceloopindex) = surfaceloop;
  EndIf
Return
