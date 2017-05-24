// Dimensions of square
s = 0.05;

If (!Exists(Lx))
  Lx = 1;
EndIf

If (!Exists(Ly))
  Ly = 1;
EndIf

If (!Exists(s))
  s = 0.03;
EndIf

capillaryWidth  = 0.2*Lx;
capillaryHeight = 0.2*Ly;

// Define domain
Point(1)  = {0                       , 0                        , 0 , s};
Point(2)  = {Lx                      , 0                        , 0 , s};
Point(3)  = {Lx                      , Ly/2 - capillaryHeight/2 , 0 , s};
Point(4)  = {Lx/2 + capillaryWidth/2 , Ly/2 - capillaryHeight/2 , 0 , s};
Point(5)  = {Lx/2 + capillaryWidth/2 , Ly/2 + capillaryHeight/2 , 0 , s};
Point(6)  = {Lx                      , Ly/2 + capillaryHeight/2 , 0 , s};
Point(7)  = {Lx                      , Ly                       , 0 , s};
Point(8)  = {0                       , Ly                       , 0 , s};
Point(9)  = {0                       , Ly/2 + capillaryHeight/2 , 0 , s};
Point(10) = {Lx/2 - capillaryWidth/2 , Ly/2 + capillaryHeight/2 , 0 , s};
Point(11) = {Lx/2 - capillaryWidth/2 , Ly/2 - capillaryHeight/2 , 0 , s};
Point(12) = {0                       , Ly/2 - capillaryHeight/2 , 0 , s};

Line(1)  = {1  , 2  };
Line(2)  = {2  , 3  };
Line(3)  = {3  , 4  };
Line(4)  = {4  , 5  };
Line(5)  = {5  , 6  };
Line(6)  = {6  , 7  };
Line(7)  = {7  , 8  };
Line(8)  = {8  , 9  };
Line(9)  = {9  , 10 };
Line(10) = {10 , 11 };
Line(11) = {11 , 12 };
Line(12) = {12 , 1  };

Line Loop(13) = {8, 9, 10, 11, 12, 1, 2, 3, 4, 5, 6, 7};
Plane Surface(14) = {13};

Physical Surface("Domain",1) = {14};
Physical Line("Inflow", 1)  = {12};
Physical Line("Outflow1",2)  = {2};
Physical Line("Outflow2",3)  = {7};
Physical Line("Rest",4)  = {1, 11, 10, 9, 8, 6, 5, 4, 3};
