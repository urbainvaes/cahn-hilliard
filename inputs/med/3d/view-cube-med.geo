Merge "output/mesh.msh";

Hide {
  Surface {
    Physical Surface{1},
    Physical Surface{2},
    Physical Surface{4}
  };
}

General.Trackball = 0;
General.RotationX = 300.7256005599669;
General.RotationY = 1.020846997272915;
General.RotationZ = 318.5479184306434;

Mesh.ColorCarousel = 2;
Mesh.SurfaceEdges  = 0;
Mesh.VolumeEdges   = 0;
Mesh.SurfaceFaces  = 1;

Geometry.Lines          = 1;
Geometry.Surfaces       = 1;
Geometry.Points         = 0;
Geometry.SurfaceType    = 0;
Geometry.SurfaceNumbers = 0;

View.Visible = 0;
View.ShowScale = 0;
View.RangeType = 2;
View.CustomMin = -1.3;
View.CustomMax = 1.3;

Color Gray
{
  Surface {
    Physical Surface{5},
    Physical Surface{4}
  };
}

viewsPerStep = 5;
maxIters = 20;
startAt = 0;

For i In {startAt:maxIters}
  If (FileExists(Sprintf("output/phi/phi-%g.pos", i)))
    Merge Sprintf("output/phi/phi-%g.pos", i);

    Plugin(CutPlane).A = 1;
    Plugin(CutPlane).B = 0;
    Plugin(CutPlane).C = 0;
    Plugin(CutPlane).D = - 0.5*Lx;
    Plugin(CutPlane).View = (i-startAt)*viewsPerStep;
    Plugin(CutPlane).Run;

    Plugin(CutPlane).A = 0;
    Plugin(CutPlane).B = 1;
    Plugin(CutPlane).C = 0;
    Plugin(CutPlane).D = - 0.5*Ly;
    Plugin(CutPlane).View = (i-startAt)*viewsPerStep;
    Plugin(CutPlane).Run;

    Plugin(CutPlane).A = 0;
    Plugin(CutPlane).B = 0;
    Plugin(CutPlane).C = 1;
    Plugin(CutPlane).D = - 0.5*Lz;
    Plugin(CutPlane).View = (i-startAt)*viewsPerStep;
    Plugin(CutPlane).Run;

    Plugin(Isosurface).Value = 0;
    Plugin(Isosurface).View = (i-startAt)*viewsPerStep;
    Plugin(Isosurface).Run;

    /* Delete View[(i-startAt)*viewsPerStep]; */

    View[i*viewsPerStep + 0].Visible = 0;
    View[i*viewsPerStep + 1].OffsetX = - 0.5*Lx;
    View[i*viewsPerStep + 2].OffsetY = 0.5*Ly;
    View[i*viewsPerStep + 3].OffsetZ = - 0.5*Lz;

    View[i*viewsPerStep + 4].SmoothNormals = 1;
    View[i*viewsPerStep + 4].ColormapAlpha = 0.7;

    For j In {1:viewsPerStep-1}
      View[(i-startAt)*viewsPerStep + j].Visible = 1;
    EndFor

    General.RotationZ += 0;
    Draw;

    If(Exists(video))
      System "mkdir -p pictures/iso";
      Print Sprintf("pictures/iso/iso-%04g.jpg", i);
    EndIf
    If(!Exists(video))
      Sleep 0.2;
    EndIf

    For j In {0:viewsPerStep-1}
      View[(i-startAt)*viewsPerStep + j].Visible = 0;
    EndFor

  EndIf
EndFor

Mesh.SurfaceFaces = 0;
For i In {startAt:maxIters}
  View[i*viewsPerStep].Visible = 1;
  View[i*viewsPerStep].DrawSkinOnly = 1;
  View[i*viewsPerStep].ColormapAlpha = 0.6;
  Draw;
  If(Exists(video))
    System "mkdir -p pictures/phi";
    Print Sprintf("pictures/phi/phi-%04g.jpg", i);
  EndIf
  If(!Exists(video))
    Sleep 0.2;
  EndIf
  View[i*viewsPerStep].Visible = 0;
EndFor

Exit;
