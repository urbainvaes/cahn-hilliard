Macro Circ
  // Define surface circle
  cp0 = newp; Point(cp0) = {x    , y    , 0, s}; // Center
  cp1 = newp; Point(cp1) = {x - r, y - r, 0, s};
  cp2 = newp; Point(cp2) = {x + r, y - r, 0, s};
  cp3 = newp; Point(cp3) = {x + r, y + r, 0, s};
  cp4 = newp; Point(cp4) = {x - r, y + r, 0, s};

  cl1 = newl; Circle(cl1) = {cp1,cp0,cp2};
  cl2 = newl; Circle(cl2) = {cp2,cp0,cp3};
  cl3 = newl; Circle(cl3) = {cp3,cp0,cp4};
  cl4 = newl; Circle(cl4) = {cp4,cp0,cp1};

  lloop = newreg; Line Loop(lloop) = {cl1,cl2,cl3,cl4};
Return
