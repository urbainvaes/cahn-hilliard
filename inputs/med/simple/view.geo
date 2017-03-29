video = 0; // ---

General.Trackball = 0;
General.MenuWidth = 2;
General.SmallAxes = 0;

Geometry.Lines    = 0;
Geometry.Surfaces = 0;
Geometry.Points   = 0;

View.ColormapNumber = 1;

viewsPerStep = 4;
maxIters = 20;
startAt = 1;

offsetX = 5;
startX = -7;

For i In {startAt:maxIters-1}
  If (FileExists(Sprintf("./output/phi/phi-%g.pos", i)))

    indexStart = (i-startAt)*viewsPerStep;

    Merge Sprintf("./output/phi/phi-%g.pos", i);
    View[indexStart].ShowScale = 1;
    View[indexStart].RangeType = 2;
    View[indexStart].CustomMin = -1.3;
    View[indexStart].CustomMax = 1.3;

    Merge Sprintf("./output/mu/mu-%g.pos", i);
    View[indexStart+1].ShowScale = 0;

    Merge Sprintf("./output/pressure/pressure-%g.pos", i);
    View[indexStart+2].ShowScale = 0;

    Merge Sprintf("./output/velocity/velocity-%g.pos", i);

    Plugin(MathEval).View = indexStart + 3;
    Plugin(MathEval).Run;

    x0 = 5.82; y0 = 14; dx = 6.4 - x0;
    Plugin(StreamLines).View       = 0;
    Plugin(StreamLines).X0         = x0;
    Plugin(StreamLines).Y0         = y0;
    Plugin(StreamLines).X1         = x0 + dx;
    Plugin(StreamLines).Y1         = y0;
    Plugin(StreamLines).X2         = x0;
    Plugin(StreamLines).Y2         = y0 + dx;
    Plugin(StreamLines).MaxIter    = 10000;
    Plugin(StreamLines).DT         = 1;
    Plugin(StreamLines).NumPointsU = 50;
    Plugin(StreamLines).View       = indexStart + 3;
    Plugin(StreamLines).OtherView  = indexStart + 4;
    Plugin(StreamLines).Run;
    Delete View[indexStart + 4];
    Delete View[indexStart + 3];

    View[indexStart+3].ShowScale = 0;

    For j In {0:viewsPerStep-1}
      View[indexStart + j].OffsetX = startX + j*offsetX;
      View[indexStart + j].Visible = 1;
    EndFor

    Draw;
    If(video == 1)
      System "mkdir -p pictures/phi";
      Print Sprintf("./pictures/phi/phi-%06g.png", i);
    EndIf

    For j In {0:viewsPerStep-1}
      View[(i-startAt)*viewsPerStep + j].Visible = 0;
    EndFor

  EndIf
  If (!FileExists(Sprintf("./output/phi/phi-%g.pos", i)))
    // i = maxIters;
    i = i - 1; Sleep 0.1;
  EndIf
EndFor
