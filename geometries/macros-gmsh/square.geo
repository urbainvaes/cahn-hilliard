Macro Square
  points[1] = newp; Point(points[1]) = {x - lx*Cos(t) + ly*Sin(t), y - lx*Sin(t) - ly*Cos(t), z, s};
  points[2] = newp; Point(points[2]) = {x + lx*Cos(t) + ly*Sin(t), y + lx*Sin(t) - ly*Cos(t), z, s};
  points[3] = newp; Point(points[3]) = {x + lx*Cos(t) - ly*Sin(t), y + lx*Sin(t) + ly*Cos(t), z, s};
  points[4] = newp; Point(points[4]) = {x - lx*Cos(t) - ly*Sin(t), y - lx*Sin(t) + ly*Cos(t), z, s};

  lines[1] = newl; Line(lines[1]) = {points[1],points[2]};
  lines[2] = newl; Line(lines[2]) = {points[2],points[3]};
  lines[3] = newl; Line(lines[3]) = {points[3],points[4]};
  lines[4] = newl; Line(lines[4]) = {points[4],points[1]};

  lloop = newreg; Line Loop(lloop) = {lines[1],lines[2],lines[3],lines[4]};
Return
