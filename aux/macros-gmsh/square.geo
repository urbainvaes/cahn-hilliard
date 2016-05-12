Macro Square
  sp1 = newp; Point(sp1) = {x - lx*Cos(t) + ly*Sin(t), y - lx*Sin(t) - ly*Cos(t), z, s};
  sp2 = newp; Point(sp2) = {x + lx*Cos(t) + ly*Sin(t), y + lx*Sin(t) - ly*Cos(t), z, s};
  sp3 = newp; Point(sp3) = {x + lx*Cos(t) - ly*Sin(t), y + lx*Sin(t) + ly*Cos(t), z, s};
  sp4 = newp; Point(sp4) = {x - lx*Cos(t) - ly*Sin(t), y - lx*Sin(t) + ly*Cos(t), z, s};

  sl1 = newl; Line(sl1) = {sp1,sp2};
  sl2 = newl; Line(sl2) = {sp2,sp3};
  sl3 = newl; Line(sl3) = {sp3,sp4};
  sl4 = newl; Line(sl4) = {sp4,sp1};

  lloop = newreg; Line Loop(lloop) = {sl1,sl2,sl3,sl4};
Return
