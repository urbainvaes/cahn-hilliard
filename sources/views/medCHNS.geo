If(!Exists(video))
  video = 0;
EndIf

If(!Exists(step))
  step = 0;
EndIf

If(!Exists(startAt))
  startAt = 0;
EndIf

If(!Exists(offsetX))
  offsetX = .6;
EndIf

If(!Exists(startX))
  startX = -.9;
EndIf

maxIters = 10000;

If(StrCmp(field, "all") != 0) viewsPerStep = 1; EndIf
If(StrCmp(field, "all") == 0)
  viewsPerStep   = 4;
  General.ScaleX = 0.6;
  General.ScaleY = 0.6;
  View.ShowScale = 1;
EndIf

For i In {0: maxIters}
  iteration = startAt + i*step;
  indexStart = i*viewsPerStep;
  If (FileExists(Sprintf("../output/done/done-%g.txt", iteration)))
    For j In {0:viewsPerStep-1}
      View[indexStart - viewsPerStep + j].Visible = 0;
    EndFor
    If(StrCmp(field, "all") != 0)
      Merge StrCat("../output/", field, "/", field, Sprintf("-%g.pos", iteration));
    EndIf
    If(StrCmp(field, "all") == 0)
      Merge Sprintf("../output/phi/phi-%g.pos", iteration);
      View[indexStart].ShowScale = 1;
      View[indexStart].RangeType = 2;
      View[indexStart].CustomMin = -1.3;
      View[indexStart].CustomMax = 1.3;

      Merge Sprintf("../output/mu/mu-%g.pos", iteration);
      Merge Sprintf("../output/pressure/pressure-%g.pos", iteration);
      Merge Sprintf("../output/velocity/velocity-%g.pos", iteration);

      For j In {0:viewsPerStep-1}
        View[indexStart + j].OffsetX = startX + j*offsetX;
      EndFor
    EndIf
    For j In {0:viewsPerStep-1}
      View[indexStart + j].Visible = 1;
    EndFor
    Draw;
    If(video == 1)
      System StrCat("mkdir -p pictures/", field);
      Print StrCat("../pictures/", field, "/", field, Sprintf("-%04g.png", iteration));
    EndIf
  EndIf
    If (!FileExists(Sprintf("../output/done/done-%g.txt", iteration)))
      Sleep .1; Draw; i = i - 1;
    EndIf
EndFor
