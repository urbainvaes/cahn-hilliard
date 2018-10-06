// Dimensions of square

#ifndef GEOMETRY_LX
#define GEOMETRY_LX 1
#endif

#ifndef GEOMETRY_LY
#define GEOMETRY_LY 1
#endif

#ifndef GEOMETRY_S
#define GEOMETRY_S 0.005
#endif

#ifndef GEOMETRY_CENTERED_AT_0_X
#define GEOMETRY_OFFSET_X GEOMETRY_LX/2
#else
#define GEOMETRY_OFFSET_X 0
#endif

#ifndef GEOMETRY_CENTERED_AT_0_Y
#define GEOMETRY_OFFSET_Y GEOMETRY_LY/2
#else
#define GEOMETRY_OFFSET_Y 0
#endif

s = GEOMETRY_S;

// Define domain
Point(1) = {GEOMETRY_OFFSET_X - GEOMETRY_LX/2 , GEOMETRY_OFFSET_Y - GEOMETRY_LY/2 , 0 , s};
Point(2) = {GEOMETRY_OFFSET_X + GEOMETRY_LX/2 , GEOMETRY_OFFSET_Y - GEOMETRY_LY/2 , 0 , s};
Point(3) = {GEOMETRY_OFFSET_X + GEOMETRY_LX/2 , GEOMETRY_OFFSET_Y + GEOMETRY_LY/2 , 0 , s};
Point(4) = {GEOMETRY_OFFSET_X - GEOMETRY_LX/2 , GEOMETRY_OFFSET_Y + GEOMETRY_LY/2 , 0 , s};

Line(1) = {1,2};
Line(2) = {2,3};
Line(3) = {3,4};
Line(4) = {4,1};

Line Loop(1) = {1,2,3,4};
Plane Surface(1) = {1};

Physical Line (1) = {1};
Physical Line (2) = {2};
Physical Line (3) = {3};
Physical Line (4) = {4};

Physical Surface (1) = {1};

// View options
Geometry.LabelType = 2;
Geometry.Lines = 1;
Geometry.LineNumbers = 2;
Geometry.Surfaces = 1;
Geometry.SurfaceNumbers = 2;
