Merge "output/mesh.msh";
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

viewsBefore = 1;
viewsPerStep = 1;
maxIters = 1000;
startAt = 0;

For i In {startAt:maxIters}
  If (FileExists(Sprintf("./output/phi/phi-%g.pos", i)))
    Merge Sprintf("./output/phi/phi-%g.pos", i);
    baseIndex = viewsBefore + (i-startAt)*viewsPerStep;

    // Plugin(CutPlane).A = 1;
    // Plugin(CutPlane).B = 0;
    // Plugin(CutPlane).C = 0;
    // Plugin(CutPlane).D = - 0.5*Lx;
    // Plugin(CutPlane).View = baseIndex;
    // Plugin(CutPlane).Run;
    // View[baseIndex + 1].OffsetX = - 0.5*Lx;

    // Plugin(CutPlane).A = 0;
    // Plugin(CutPlane).B = 1;
    // Plugin(CutPlane).C = 0;
    // Plugin(CutPlane).D = - 0.5*Ly;
    // Plugin(CutPlane).View = baseIndex;
    // Plugin(CutPlane).Run;
    // View[baseIndex + 2].OffsetY = 0.5*Ly;

    // Plugin(CutPlane).A = 0;
    // Plugin(CutPlane).B = 0;
    // Plugin(CutPlane).C = 1;
    // Plugin(CutPlane).D = 0;
    // Plugin(CutPlane).View = baseIndex;
    // Plugin(CutPlane).Run;
    // View[baseIndex + 3].OffsetZ = Lz;

    // Plugin(Isosurface).Value = 0;
    // Plugin(Isosurface).Value = baseIndex + 3;
    // Plugin(Isosurface).Run;
    // Delete View[baseIndex + 3];

    Plugin(Isosurface).Value = 0;
    Plugin(Isosurface).View = baseIndex;
    Plugin(Isosurface).Run;
    View[baseIndex + viewsPerStep].SmoothNormals = 1;
    View[baseIndex + viewsPerStep].ColormapAlpha = 0.7;

    Delete View[baseIndex];

    For j In {0:viewsPerStep-1}
      View[baseIndex + j].Visible = 1;
      View[baseIndex + j].ShowScale = 0;
      View[baseIndex + j].RangeType = 2;
      View[baseIndex + j].CustomMin = -1.3;
      View[baseIndex + j].CustomMax = 1.3;
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
