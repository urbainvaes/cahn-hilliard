// Dimensions of square

If (!Exists(Lx))
  Lx = 1;
EndIf

If (!Exists(Ly))
  Ly = 1;
EndIf

If (!Exists(cx1))
  cx1 = 0.1*Lx;
EndIf

If (!Exists(cx2))
  cx2 = 0.2*Lx;
EndIf

If (!Exists(cy))
  cy = Ly;
EndIf

If (!Exists(s))
  s = 0.03;
EndIf

// Channel
cy1 = cy;
cy2 = cy;

// Define domain
Point(1) = {0   , 0   , 0 , s};
Point(2) = {cx1 , 0   , 0 , s};
Point(3) = {cx1 , cy1 , 0 , s};
Point(4) = {cx2 , cy2 , 0 , s};
Point(5) = {cx2 , 0   , 0 , s};
Point(6) = {Lx  , 0   , 0 , s};
Point(7) = {Lx  , -Ly  , 0 , s};
Point(8) = {0   , -Ly  , 0 , s};

Line(8) = {1,8};
Line(7) = {8,7};
Line(6) = {7,6};
Line(5) = {6,5};
Line(4) = {5,4};
Line(3) = {4,3};
Line(2) = {3,2};
Line(1) = {2,1};

Line Loop(1) = {1,2,3,4,5,6,7,8};
Plane Surface(1) = {1};

Physical Line (1) = {1,5};
Physical Line (2) = {6};
Physical Line (3) = {7};
Physical Line (4) = {8};
Physical Line (5) = {2};
Physical Line (6) = {3};
Physical Line (7) = {4};

Physical Surface (1) = {1};

// View options
Geometry.LabelType = 2;
Geometry.Lines = 1;
Geometry.LineNumbers = 2;
Geometry.Surfaces = 1;
Geometry.SurfaceNumbers = 2;
