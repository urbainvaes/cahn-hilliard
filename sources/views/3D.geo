Include "geometry.geo";

#ifndef SOLVER_ADAPT
adapt = 0;
#else
adapt = 1;
#endif

#ifdef INIT_VIEW
#include xstr(INIT_VIEW)
#endif

If(!Exists(viewsBefore))
  viewsBefore = 0;
EndIf

If(!Exists(video))
  video = 0;
EndIf

If(!Exists(step))
  step = 1;
EndIf

If(!Exists(startAt))
  startAt = 0;
EndIf

If(!Exists(maxIters))
  maxIters = 10000;
EndIf

If(video == 1)
  System "mkdir -p pictures/iso";
EndIf

System "mkdir -p output/cache";

// Not upside down
General.Trackball = 0;
General.RotationX = 300.7256005599669;
General.RotationY = 1.020846997272915;
General.RotationZ = 318.5479184306434;
General.SmallAxes = 0;

Mesh.ColorCarousel = 2;
Mesh.SurfaceEdges  = 0;
Mesh.VolumeEdges   = 0;
Mesh.SurfaceFaces  = 1;

Geometry.Points         = 0;
Geometry.Lines          = 0;
Geometry.Surfaces       = 0;
Geometry.SurfaceNumbers = 0;

View[0].Visible = 1;
View[0].ShowScale = 0;
View[0].RangeType = 0;
View[0].ColormapNumber = 3;
View[0].Light = 1;

viewsPerStep = 1;

If (adapt == 1)
  extension = "pos";
EndIf
If (adapt == 0)
  extension = "msh";
EndIf

For i In {0:maxIters}
  iteration = startAt + i*step;
  baseIndex = viewsBefore + i*viewsPerStep;

  preSaved = FileExists(Sprintf("./output/cache/view%g-phi%g.pos", viewsPerStep, i));
  ////////////////
  preSaved = 0; // CHANGE THIS TO USE CACHE
  ////////////////
  newViews = 0;
  If (preSaved)
    newViews = 1;
    For j In {1:viewsPerStep}
      Merge Sprintf("./output/cache/view%g-phi%g.pos", j, iteration);
    EndFor
  EndIf
  If (!preSaved)
    If (FileExists(Sprintf("./output/done/done-%g.txt", iteration)))
      newViews = 1;
      Merge StrCat(Sprintf("./output/phi/phi-%g.", iteration), extension);
      Plugin(Isosurface).Value = 0;
      Plugin(Isosurface).View = baseIndex;
      Plugin(Isosurface).Run;
      For j In {1:viewsPerStep}
        Save View[baseIndex + j] Sprintf("./output/cache/view%g-phi%g.pos", j, i);
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
    If(video == 1)
      Print Sprintf("./pictures/iso/isosurface-%04g.png", iteration);
    EndIf

    For j In {0:viewsPerStep-1}
      View[baseIndex + j].Visible = 0;
    EndFor
  EndIf
EndFor
