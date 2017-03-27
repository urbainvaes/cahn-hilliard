General.ScaleX = 0.5;
General.ScaleY = 0.5;
View.ShowScale = 0;

viewsPerStep = 2;
maxIters = 1000;
startAt = 0;

deltaX = .55;
deltaY = 0;
centerX = 0;
centerY = 0;

For i In {startAt: maxIters}
  If (FileExists(Sprintf("../output/done/done-%g.txt", i)))
    indexStart = (i-startAt)*viewsPerStep;
    Merge Sprintf("./../output/phi/phi-%g.pos", i);
    View[indexStart].ShowScale = 0;
    Merge Sprintf("../output/mu/mu-%g.pos", i);
    View[indexStart+1].ShowScale = 1;
    For j In {0:viewsPerStep-1}
      View[indexStart+j].OffsetX = centerX - (1-j%2)*deltaX + (j%2)*deltaX;
      View[indexStart+j].OffsetY = centerY + (1-Floor(j/2))*deltaY - Floor(j/2)*deltaY;
      View[indexStart + j].Visible = 1;
    EndFor
    Draw;
    For j In {0:viewsPerStep-1}
      View[indexStart + j].Visible = 0;
    EndFor
  EndIf
  If (!FileExists(Sprintf("../output/done/done-%g.txt", i)))
    Sleep .5; i = i - 1;
  EndIf
EndFor
