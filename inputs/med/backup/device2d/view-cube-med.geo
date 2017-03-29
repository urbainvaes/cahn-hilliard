// video = 0;
// ---

General.Trackball = 0;
General.RotationZ = -90;
General.MenuWidth = 0;

Geometry.Lines    = 0;
Geometry.Surfaces = 0;
Geometry.Points   = 0;

Mesh.LineWidth = 1;
Mesh.ColorCarousel = 0;
Mesh.Color.Triangles = White;

View.LineWidth = 4;
View.ShowScale = 0;
View.RangeType = 2;
View.CustomMin = -1.3;
View.CustomMax = 1.3;
View.ColormapNumber = 1;

viewsPerStep = 1;
maxIters = 10000;
startAt = 0;

For i In {startAt:maxIters-1}
  If (FileExists(Sprintf("./output/phi/phi-%g.pos", i)))
    Merge Sprintf("./output/phi/phi-%g.pos", i);

    indexStart = (i-startAt)*viewsPerStep;

    For j In {0:viewsPerStep-1}
      View[indexStart + j].Visible = 1;
    EndFor

    Draw;
    If(Exists(video))
      System "mkdir -p pictures/phi";
      Print Sprintf("./pictures/phi/phi-%g.pdf", i);
    EndIf

    For j In {0:viewsPerStep-1}
      View[(i-startAt)*viewsPerStep + j].Visible = 0;
    EndFor

  EndIf
  If (!FileExists(Sprintf("./output/phi/phi-%g.pos", i)))
    i = maxIters - 1;
  EndIf
EndFor
