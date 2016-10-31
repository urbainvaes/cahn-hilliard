// Input variables:
//      - x, y, z: center of the cylinder
//      - r, L : dimensions of the cylinder
//      - index : starting index for points and lines
Macro Cylinder

  If (!Exists(surf))
    surf = 1;
  EndIf

  cp[0] = newp; Point(cp[0]) = {x    , y    , z - 0.5*L, s}; // Center
  cp[1] = newp; Point(cp[1]) = {x - r, y - r, z - 0.5*L, s};
  cp[2] = newp; Point(cp[2]) = {x + r, y - r, z - 0.5*L, s};
  cp[3] = newp; Point(cp[3]) = {x + r, y + r, z - 0.5*L, s};
  cp[4] = newp; Point(cp[4]) = {x - r, y + r, z - 0.5*L, s};

  cl[1] = newl; Circle(cl[1]) = {cp[1], cp[0], cp[2]};
  cl[2] = newl; Circle(cl[2]) = {cp[2], cp[0], cp[3]};
  cl[3] = newl; Circle(cl[3]) = {cp[3], cp[0], cp[4]};
  cl[4] = newl; Circle(cl[4]) = {cp[4], cp[0], cp[1]};

  cp[5] = newp; Point(cp[5]) = {x    , y    , z + 0.5*L, s}; // Center
  cp[6] = newp; Point(cp[6]) = {x - r, y - r, z + 0.5*L, s};
  cp[7] = newp; Point(cp[7]) = {x + r, y - r, z + 0.5*L, s};
  cp[8] = newp; Point(cp[8]) = {x + r, y + r, z + 0.5*L, s};
  cp[9] = newp; Point(cp[9]) = {x - r, y + r, z + 0.5*L, s};

  cl[5] = newl; Circle(cl[5]) = {cp[6], cp[5], cp[7]};
  cl[6] = newl; Circle(cl[6]) = {cp[7], cp[5], cp[8]};
  cl[7] = newl; Circle(cl[7]) = {cp[8], cp[5], cp[9]};
  cl[8] = newl; Circle(cl[8]) = {cp[9], cp[5], cp[6]};

  cl[9]  = newl; Line( cl[9]) = {cp[1], cp[6]};
  cl[10] = newl; Line(cl[10]) = {cp[2], cp[7]};
  cl[11] = newl; Line(cl[11]) = {cp[3], cp[8]};
  cl[12] = newl; Line(cl[12]) = {cp[4], cp[9]};

  lineloops[1] = newreg; Line Loop(lineloops[1]) = {cl[1], cl[2], cl[3], cl[4]};
  lineloops[2] = newreg; Line Loop(lineloops[2]) = {cl[5], cl[6], cl[7], cl[8]};

  If (surf == 1)
    surfaces[1] = news; Plane Surface(surfaces[1]) = {lineloops[1]};
    surfaces[2] = news; Plane Surface(surfaces[2]) = {lineloops[2]};
  EndIf

  For i_macro In {1:4}
    lineloops[2 + i_macro] = newreg; Line Loop(lineloops[2 + i_macro]) = {cl[i_macro], cl[9 + i_macro%4], -cl[4 + i_macro], -cl[8 + i_macro]};
    If (surf == 1)
      surfaces[2 + i_macro] = news; Ruled Surface(surfaces[2 + i_macro]) = {lineloops[2 + i_macro]};
    EndIf
  EndFor

  If (surf)
    surfaceloopindex = newreg;
    surfaceloop = {surfaces[1], surfaces[3], surfaces[4], surfaces[5], surfaces[6], surfaces[2]};
    Surface Loop(surfaceloopindex) = {surfaceloop[]};
  EndIf
Return
