If(!Exists(fL))
fL = 2.;
EndIf

fS = fL;
eps = .2;

If (!Exists(Lx))
  Lx = 1;
EndIf

If (!Exists(Ly))
  Ly = 1;
EndIf

If (!Exists(Lz))
  Lz = 1;
EndIf

If (!Exists(s))
  s = 0.05;
EndIf

p1 = newp; Point(p1) = {-Lx/2. , -Ly/2. , 0 , s};
p2 = newp; Point(p2) = {Lx/2.  , -Ly/2. , 0 , s};
p3 = newp; Point(p3) = {Lx/2.  , Ly/2.  , 0 , s};
p4 = newp; Point(p4) = {-Lx/2. , Ly/2.  , 0 , s};

l1 = newl; Line(1) = {p1, p2};
l2 = newl; Line(2) = {p2, p3};
l3 = newl; Line(3) = {p3, p4};
l4 = newl; Line(4) = {p4, p1};

Extrude {0, 0, Lz} {
  Line{l1,l2,l3,l4};
}

Sx = Lx/fL; Sy = Ly/fL; Sz = Lz/fL; s = s/fS;
p5 = newp; Point(p5) = {-Sx/2. , -Sy/2. , 0 , s};
p6 = newp; Point(p6) = {Sx/2.  , -Sy/2. , 0 , s};
p7 = newp; Point(p7) = {Sx/2.  , Sy/2.  , 0 , s};
p8 = newp; Point(p8) = {-Sx/2. , Sy/2.  , 0 , s};

l5 = newl; Line(l5) = {p5, p6};
l6 = newl; Line(l6) = {p6, p7};
l7 = newl; Line(l7) = {p7, p8};
l8 = newl; Line(l8) = {p8, p5};

Extrude {0, 0, Sz} {
  Line{l5,l6,l7,l8};
}

Mx = Sx*(1+eps); My = Sy*(1+eps); Mz = Sz*(1+eps); s = s*fS;
p9  = newp; Point(p9)  = {-Mx/2. , -My/2. , 0 , s};
p10 = newp; Point(p10) = {Mx/2.  , -My/2. , 0 , s};
p11 = newp; Point(p11) = {Mx/2.  , My/2.  , 0 , s};
p12 = newp; Point(p12) = {-Mx/2. , My/2.  , 0 , s};

l9  = newl; Line(l9)  = {p9,  p10};
l10 = newl; Line(l10) = {p10, p11};
l11 = newl; Line(l11) = {p11, p12};
l12 = newl; Line(l12) = {p12,  p9};

Extrude {0, 0, Mz} {
  Line{l9,l10,l11,l12};
}

Line Loop(61) = {24, 21, 22, 23};
Plane Surface(62) = {61};
Line Loop(63) = {44, 41, 42, 43};
Plane Surface(64) = {61, 63};
Line Loop(65) = {4, 1, 2, 3};
Plane Surface(66) = {63, 65};
Line Loop(67) = {37, 25, 29, 33};
Plane Surface(68) = {67};
Line Loop(69) = {57, 45, 49, 53};
Plane Surface(70) = {69};
Line Loop(71) = {17, 5, 9, 13};
Plane Surface(72) = {71};
Surface Loop(73) = {68, 40, 28, 32, 36, 62};
Volume(74) = {73};
Surface Loop(75) = {70, 60, 48, 52, 56, 64, 36, 40, 28, 32, 68};
Volume(76) = {75};
Surface Loop(77) = {16, 66, 12, 72, 20, 8, 56, 60, 48, 52, 70};
Volume(78) = {77};
Physical Volume("Domain", 1) = {78, 76, 74};
Physical Surface("Bottom", 1) = {66, 64, 62};
Physical Surface("Rest", 2) = {72, 20, 8, 12, 16};

Translate {Lx/2., Ly/2., 0.} {
  Volume{74, 76, 78};
}

// View options
Geometry.LabelType = 2;
Geometry.Surfaces = 1;
Geometry.SurfaceNumbers = 2;
