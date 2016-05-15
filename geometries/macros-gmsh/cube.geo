// Input variables:
//      - x, y, z: center of the cube
//      - dx, dy, dz : dimensions of the cube
//      - t : angle in the x-y plane
//      - index : starting index for points and lines
Macro Cube

  length_x = 0.5*dx;
  length_y = 0.5*dy;
  length_z = 0.5*dz;

  For index In {0:1}
    points[4*index + 1] = newp; Point(points[4*index + 1]) = {x - length_x*Cos(t) + length_y*Sin(t), y - length_x*Sin(t) - length_y*Cos(t), z + (2*index-1)*length_z, s};
    points[4*index + 2] = newp; Point(points[4*index + 2]) = {x + length_x*Cos(t) + length_y*Sin(t), y + length_x*Sin(t) - length_y*Cos(t), z + (2*index-1)*length_z, s};
    points[4*index + 3] = newp; Point(points[4*index + 3]) = {x + length_x*Cos(t) - length_y*Sin(t), y + length_x*Sin(t) + length_y*Cos(t), z + (2*index-1)*length_z, s};
    points[4*index + 4] = newp; Point(points[4*index + 4]) = {x - length_x*Cos(t) - length_y*Sin(t), y - length_x*Sin(t) + length_y*Cos(t), z + (2*index-1)*length_z, s};

    lines[4*index + 1] = newl; Line(lines[4*index + 1]) = {points[4*index + 1], points[4*index + 2]};
    lines[4*index + 2] = newl; Line(lines[4*index + 2]) = {points[4*index + 2], points[4*index + 3]};
    lines[4*index + 3] = newl; Line(lines[4*index + 3]) = {points[4*index + 3], points[4*index + 4]};
    lines[4*index + 4] = newl; Line(lines[4*index + 4]) = {points[4*index + 4], points[4*index + 1]};
  EndFor

  For index In {1:4}
    lines[8 + index] = newl; Line(lines[8 + index]) = {points[index], points[index+4]};
  EndFor

  lineloops[1] = newreg; Line Loop(lineloops[1]) = {lines[1] ,  lines[2] ,  lines[3] ,   lines[4] };
  lineloops[2] = newreg; Line Loop(lineloops[2]) = {lines[1] , lines[10] , -lines[5] ,  -lines[9] };
  lineloops[3] = newreg; Line Loop(lineloops[3]) = {lines[2] , lines[11] , -lines[6] , -lines[10] };
  lineloops[4] = newreg; Line Loop(lineloops[4]) = {lines[3] , lines[12] , -lines[7] , -lines[11] };
  lineloops[5] = newreg; Line Loop(lineloops[5]) = {lines[4] ,  lines[9] , -lines[8] , -lines[12] };
  lineloops[6] = newreg; Line Loop(lineloops[6]) = {lines[5] ,  lines[6] ,  lines[7] ,   lines[8] };

  If (surf == 1)
    surfaces[1] = news; Plane Surface(surfaces[1]) = {lineloops[1]};
    surfaces[2] = news; Plane Surface(surfaces[2]) = {lineloops[2]};
    surfaces[3] = news; Plane Surface(surfaces[3]) = {lineloops[3]};
    surfaces[4] = news; Plane Surface(surfaces[4]) = {lineloops[4]};
    surfaces[5] = news; Plane Surface(surfaces[5]) = {lineloops[5]};
    surfaces[6] = news; Plane Surface(surfaces[6]) = {lineloops[6]};

    surfaceloopindex = newreg;
    surfaceloop = {surfaces[1], surfaces[2], surfaces[3], surfaces[4], surfaces[5], surfaces[6]};
    Surface Loop(surfaceloopindex) = {surfaceloop[]};
  EndIf
Return
