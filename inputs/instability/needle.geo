s = GEOMETRY_S;
Lx = GEOMETRY_LX;
Ly = GEOMETRY_LY;
Cn = SOLVER_CN;

// Testing parameters

// s = 0.01;
// Lx = 2.;
// Ly = .5;
// Cn = .1;

// Needle
Point(1) = {0    , 0   , 0 , s};
Point(2) = {Lx , -Ly/2   , 0 , s};
Point(3) = {Lx , Ly/2 , 0 , s};

Line(1) = {1,2};
Line(2) = {2,3};
Line(3) = {3,1};

Line Loop(1) = {1,2,3};

Physical Line (1) = {1};
Physical Line (2) = {2};
Physical Line (3) = {3};

// Othe domain
// Point(1) = {0    , -Cn/5   , 0 , s};
// Point(2) = {Lx/2 , -Cn/2   , 0 , s};
// Point(3) = {Lx/2 , -Ly/2 , 0 , s};
// Point(4) = {Lx   , -Ly/2 , 0 , s};
// Point(5) = {Lx   , Ly/2  , 0 , s};
// Point(6) = {Lx/2 , Ly/2  , 0 , s};
// Point(7) = {Lx/2 , Cn/2    , 0 , s};
// Point(8) = {0    , Cn/5    , 0 , s};


// Line(1) = {1,2};
// Line(2) = {2,3};
// Line(3) = {3,4};
// Line(4) = {4,5};
// Line(5) = {5,6};
// Line(6) = {6,7};
// Line(7) = {7,8};
// Line(8) = {8,1};

// Line Loop(1) = {1,2,3,4,5,6,7,8};

// Physical Line (1) = {1};
// Physical Line (2) = {2};
// Physical Line (3) = {3};
// Physical Line (4) = {4};
// Physical Line (5) = {5};
// Physical Line (6) = {6};
// Physical Line (7) = {7};
// Physical Line (8) = {8};
// Physical Line (9) = {9};

Plane Surface(1) = {1};
Physical Surface (1) = {1};

// View options
Geometry.LabelType = 2;
Geometry.Lines = 1;
Geometry.LineNumbers = 2;
Geometry.Surfaces = 1;
Geometry.SurfaceNumbers = 2;
