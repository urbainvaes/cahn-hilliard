video = 0; // ---

maxIters = 1000;
startAt = 0;

If(StrCmp(field, "all") != 0)
  For i In {startAt: maxIters}
    If (FileExists(Sprintf("../output/done/done-%g.txt", i)))
      Merge StrCat("../output/", field, "/", field, Sprintf("-%g.pos", i));
      View[i].Visible = 1; Draw; View[i].Visible = 0;
    EndIf
    If (!FileExists(Sprintf("../output/done/done-%g.txt", i)))
      Sleep .5; i = i - 1;
    EndIf
  EndFor
EndIf

If(StrCmp(field, "all") == 0)

  offsetX = .6;
  startX = -.9;
  viewsPerStep = 4;
  General.ScaleX = 0.6;
  General.ScaleY = 0.6;
  View.ShowScale = 1;

  For i In {startAt:maxIters-1}
    If (FileExists(Sprintf("../output/done/done-%g.txt", i)))

      indexStart = (i-startAt)*viewsPerStep;

      Merge Sprintf("../output/phi/phi-%g.pos", i);
      View[indexStart].ShowScale = 1;
      View[indexStart].RangeType = 2;
      View[indexStart].CustomMin = -1.3;
      View[indexStart].CustomMax = 1.3;

      Merge Sprintf("../output/mu/mu-%g.pos", i);
      Merge Sprintf("../output/pressure/pressure-%g.pos", i);
      Merge Sprintf("../output/velocity/velocity-%g.pos", i);

      For j In {0:viewsPerStep-1}
        View[indexStart + j].OffsetX = startX + j*offsetX;
        View[indexStart + j].Visible = 1;
      EndFor

      Draw;
      If(video == 1)
        System "mkdir -p pictures/phi";
        Print Sprintf("../pictures/phi/phi-%06g.png", i);
      EndIf

      For j In {0:viewsPerStep-1}
        View[(i-startAt)*viewsPerStep + j].Visible = 0;
      EndFor

    EndIf
    If (!FileExists(Sprintf("../output/done/done-%g.txt", i)))
      // i = maxIters;
      /* i = i - 1; Sleep 0.1; */
      i = i - 1;
    EndIf
  EndFor
EndIf
