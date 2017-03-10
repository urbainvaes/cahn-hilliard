Lx = 1; Ly = 1; Lz = 1; s = 0.1;

Point(1) = {0,  0,  0, s};
Point(2) = {Lx, 0,  0, s};
Point(3) = {Lx, Ly, 0, s};
Point(4) = {0,  Ly, 0, s};

Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 1};

Line Loop(1) = {1,2,3,4};
Plane Surface(1) = {1};

Extrude {0, 0, 0.5} {
  Surface{1};
}
Extrude {0, 0, 0.5} {
  Surface{26};
}
Extrude {0, -0.3, 0} {
  Surface{35};
}

Physical Surface("Inflow", 1) = {70};
Physical Surface("Outflow", 2) = {43, 21};
Physical Surface("Lateral", 3) = {39, 1, 17, 48, 47, 25, 65, 61, 57, 69};
Physical Volume("Domain", 1) = {3, 2, 1};
