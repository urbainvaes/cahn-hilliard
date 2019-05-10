#ifndef SOLVER_MESH_ADAPTATION
adapt = 0;
#else
adapt = 1;
#endif

If(!Exists(field))
  field = "mu";
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
  System StrCat("mkdir -p pictures/", field);
EndIf

If (adapt == 0)
  If (FileExists(Sprintf("output/high-order-mesh.msh")))
    Merge "output/high-order-mesh.msh";
  EndIf
  If (!FileExists(Sprintf("output/high-order-mesh.msh")))
    Merge "output/mesh.msh";
  EndIf
EndIf

For i In {0:maxIters}
  iteration = startAt + i*step;
  If (FileExists(Sprintf("output/done/done-%g.txt", iteration)))
    If (adapt == 1)
      If (i != 0)
        View[i-1].Visible = 0;
      EndIf
      If (!FileExists(StrCat("output/", field, "/", field, Sprintf("-%g.pos", iteration))))
        System StrCat("$(git rev-parse --show-toplevel)/sources/bin/msh2pos output/mesh/mesh-", Sprintf("%g.msh ", iteration), "output/", field, "/", field, Sprintf("-%g.msh", iteration));
      EndIf
      Merge StrCat("output/", field, "/", field, Sprintf("-%g.pos", iteration));
      View[i].Visible = 1;
    EndIf
    If (adapt == 0)
      Merge StrCat("output/", field, "/", field, Sprintf("-%g.msh", iteration));
      View[0].TimeStep += step;
    EndIf
    Draw;
    If(video == 1)
      Print StrCat("pictures/", field, "/", field, Sprintf("-%04g.png", iteration));
    EndIf
  EndIf
  If (!FileExists(Sprintf("output/done/done-%g.txt", iteration)))
    Sleep .1; Draw; i = i - 1;
  EndIf
EndFor
