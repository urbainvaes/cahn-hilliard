// Input variables:
//      - x, y, z: center of the sphere
//      - r : radius of the sphere
Macro mySphere

  points[1] = newp; Point(points[1]) = {x     , y     , z     , s};
  points[2] = newp; Point(points[2]) = {x + r , y     , z     , s};
  points[3] = newp; Point(points[3]) = {x     , y + r , z     , s};
  points[4] = newp; Point(points[4]) = {x     , y     , z + r , s};
  points[5] = newp; Point(points[5]) = {x - r , y     , z     , s};
  points[6] = newp; Point(points[6]) = {x     , y - r , z     , s};
  points[7] = newp; Point(points[7]) = {x     , y     , z - r , s};

  circle[1]  = newl; Circle(circle[1])  = {points[2], points[1], points[3]};
  circle[2]  = newl; Circle(circle[2])  = {points[3], points[1], points[5]};
  circle[3]  = newl; Circle(circle[3])  = {points[5], points[1], points[6]};
  circle[4]  = newl; Circle(circle[4])  = {points[6], points[1], points[2]};
  circle[5]  = newl; Circle(circle[5])  = {points[2], points[1], points[7]};
  circle[6]  = newl; Circle(circle[6])  = {points[7], points[1], points[5]};
  circle[7]  = newl; Circle(circle[7])  = {points[5], points[1], points[4]};
  circle[8]  = newl; Circle(circle[8])  = {points[4], points[1], points[2]};
  circle[9]  = newl; Circle(circle[9])  = {points[6], points[1], points[7]};
  circle[10] = newl; Circle(circle[10]) = {points[7], points[1], points[3]};
  circle[11] = newl; Circle(circle[11]) = {points[3], points[1], points[4]};
  circle[12] = newl; Circle(circle[12]) = {points[4], points[1], points[6]};

  lloop[1] = newreg; Line Loop(lloop[1]) = {  circle [1] ,   circle [11]   ,   circle [8]};
  lloop[2] = newreg; Line Loop(lloop[2]) = {  circle [2] ,   circle [7]    , - circle [11]};
  lloop[3] = newreg; Line Loop(lloop[3]) = {  circle [3] , - circle [12]   , - circle [7]};
  lloop[4] = newreg; Line Loop(lloop[4]) = {  circle [4] , - circle [8]    ,   circle [12]};
  lloop[5] = newreg; Line Loop(lloop[5]) = {  circle [5] ,   circle [10]   , - circle [1]};
  lloop[6] = newreg; Line Loop(lloop[6]) = {- circle [2] , - circle [10]   ,   circle [6]};
  lloop[7] = newreg; Line Loop(lloop[7]) = {- circle [3] , - circle [6]    , - circle [9]};
  lloop[8] = newreg; Line Loop(lloop[8]) = {- circle [4] ,   circle [9]    , - circle [5]};


  For macro_i In {1:8}
    rsurface[macro_i] = newreg; Ruled Surface(rsurface[macro_i]) = {lloop[macro_i]};
  EndFor

  surfaceloopindex = newreg;
  surfaceloop = {rsurface[1], rsurface[2], rsurface[3], rsurface[4], rsurface[5], rsurface[6], rsurface[7], rsurface[8]};
  Surface Loop(surfaceloopindex) = {surfaceloop[]};

Return
