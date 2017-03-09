// Input variables:
//      - x, y : center of the square
//      - dx, dy : dimensions of the square
//      - t : angle in the x-y plane
//      - index : starting index for points and lines
Macro Square

  If (!Exists(Lx))
    Lx = 1;
  EndIf

  If (!Exists(Ly))
    Ly = 1;
  EndIf

  If (!Exists(s))
    s = 0.1;
  EndIf

  If (!Exists(t))
    t = 0;
  EndIf

  If (!Exists(x))
    x = Lx/2;
  EndIf

  If (!Exists(y))
    y = Ly/2;
  EndIf

  If (!Exists(z))
    z = 0;
  EndIf

  If (!Exists(index))
    index = 0;
  EndIf

  length_x = 0.5*Lx;
  length_y = 0.5*Ly;

  points[1] = newp; Point(points[1]) = {x - length_x*Cos(t) + length_y*Sin(t), y - length_x*Sin(t) - length_y*Cos(t), z, s};
  points[2] = newp; Point(points[2]) = {x + length_x*Cos(t) + length_y*Sin(t), y + length_x*Sin(t) - length_y*Cos(t), z, s};
  points[3] = newp; Point(points[3]) = {x + length_x*Cos(t) - length_y*Sin(t), y + length_x*Sin(t) + length_y*Cos(t), z, s};
  points[4] = newp; Point(points[4]) = {x - length_x*Cos(t) - length_y*Sin(t), y - length_x*Sin(t) + length_y*Cos(t), z, s};

  lines[1] = newl; Line(lines[1]) = {points[1],points[2]};
  lines[2] = newl; Line(lines[2]) = {points[2],points[3]};
  lines[3] = newl; Line(lines[3]) = {points[3],points[4]};
  lines[4] = newl; Line(lines[4]) = {points[4],points[1]};

  lloop = newreg;
  Line Loop(lloop) = {lines[1],lines[2],lines[3],lines[4]};
Return
