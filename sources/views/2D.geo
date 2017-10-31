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
  System StrCat("mkdir -p pictures/", field);
EndIf

View.ShowScale = 1;

For i In {0: maxIters}
  iteration = startAt + i*step;
  If (FileExists(Sprintf("output/done/done-%g.txt", iteration)))
    Merge StrCat("output/", field, "/", field, Sprintf("-%g.pos", iteration));
    View[i].Visible = 1;
    Draw;
    If(video == 1)
      Print StrCat("pictures/", field, "/", field, Sprintf("-%04g.png", iteration));
    EndIf
    View[i - 1].Visible = 0;
  EndIf
  If (!FileExists(Sprintf("output/done/done-%g.txt", iteration)))
    Sleep .1; Draw; i = i - 1;
  EndIf
EndFor
