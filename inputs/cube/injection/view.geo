// Merge "output/mesh.msh";
Merge "contactAngle.pos";

// Not upside down
General.Trackball = 0;
General.RotationX = 300.7256005599669;
General.RotationY = 1.020846997272915;
General.RotationZ = 318.5479184306434;
General.SmallAxes = 0;

Mesh.ColorCarousel = 2;
Mesh.SurfaceEdges  = 0;
Mesh.VolumeEdges   = 0;
Mesh.SurfaceFaces  = 0;

Geometry.Points         = 0;
Geometry.Lines          = 0;
Geometry.Surfaces       = 0;
Geometry.SurfaceNumbers = 0;

View[0].Visible = 1;
View[0].ShowScale = 1;
View[0].RangeType = 0;
View[0].ColormapNumber = 3;
View[0].Light = 1;

viewsBefore = 1;
viewsPerStep = 1;
maxIters = 10;
startAt = 0;

For i In {startAt:maxIters}

  baseIndex = viewsBefore + (i-startAt)*viewsPerStep;
  preSaved = FileExists(Sprintf("./output/phi/view%g-%g.pos", viewsPerStep, i));
  newViews = 0;

  If (preSaved)
    newViews = 1;
    For j In {1:viewsPerStep}
      Merge Sprintf("./output/phi/view%g-%g.pos", j, i);
    EndFor
  EndIf
  If (!preSaved)
    If (FileExists(Sprintf("./output/phi/phi-%g.pos", i)))
      newViews = 1;
      Merge Sprintf("./output/phi/phi-%g.pos", i);
      Plugin(Isosurface).Value = 0;
      Plugin(Isosurface).View = baseIndex;
      Plugin(Isosurface).Run;
      For j In {1:viewsPerStep}
        Save View[baseIndex + j] Sprintf("./output/phi/view%g-%g.pos", j, i);
      EndFor
      Delete View[baseIndex];
     EndIf
   EndIf
   If (newViews)
     For j In {0:viewsPerStep-1}
       View[baseIndex + j].Visible = 1;
       View[baseIndex + j].ShowScale = 0;
       View[baseIndex + j].RangeType = 2;
       View[baseIndex + j].CustomMin = -1.3;
       View[baseIndex + j].CustomMax = 1.3;
       View[baseIndex + j].LightTwoSide = 1;
       View[baseIndex + j].SmoothNormals = 1;
       View[baseIndex + j].ColormapAlpha = 1;
       View[baseIndex + j].ColormapNumber = 14;
       View[baseIndex + j].ColormapInvert = 1;
     EndFor
     Draw;
     If(Exists(video))
       System "mkdir -p pictures/iso";
       Print Sprintf("./pictures/iso/isosurface-%04g.png", i);
     EndIf

     // General.RotationZ += 1;
     For j In {0:viewsPerStep-1}
       View[viewsBefore + (i-startAt)*viewsPerStep + j].Visible = 0;
     EndFor
  EndIf
EndFor
