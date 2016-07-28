// Generate list of files to be included
System "ls -v output/phi/phase-*.pos | sed '1d' > includes.geo";
System 'sed -i "s/^\(.\+\)$/Merge \"\1\";/" includes.geo';


// Use Euler angles instead of quaternion
General.Trackball = 0;

// Not upside down
General.RotationX = 300.7256005599669;
General.RotationY = 1.020846997272915;
General.RotationZ = 318.5479184306434;

Mesh.ColorCarousel   = 2;
Mesh.SurfaceEdges    = 0;
Mesh.VolumeEdges     = 0;

Geometry.Lines       = 0;
Geometry.Surfaces    = 0;
Geometry.Points      = 0;
Geometry.SurfaceType = 0;
Geometry.SurfaceNumbers = 0;

View.Visible = 0;
View.ShowScale = 0;
View.RangeType = 2;
View.CustomMin = -1.3;
View.CustomMax = 1.3;

Include "../includes.geo";
System 'rm includes.geo';

nSteps = PostProcessing.NbViews;

For i In {0:nSteps-1}

  Plugin(CutPlane).A = 1;
  Plugin(CutPlane).B = 0;
  Plugin(CutPlane).C = 0;
  Plugin(CutPlane).D = - 0.5*Lx;
  Plugin(CutPlane).View = i;
  Plugin(CutPlane).Run;

  Plugin(CutPlane).A = 0;
  Plugin(CutPlane).B = 1;
  Plugin(CutPlane).C = 0;
  Plugin(CutPlane).D = - 0.5*Ly;
  Plugin(CutPlane).View = i;
  Plugin(CutPlane).Run;

  Plugin(CutPlane).A = 0;
  Plugin(CutPlane).B = 0;
  Plugin(CutPlane).C = 1;
  Plugin(CutPlane).D = - 0.5*Lz;
  Plugin(CutPlane).View = i;
  Plugin(CutPlane).Run;

  Plugin(Isosurface).Value = 0;
  Plugin(Isosurface).View = i;
  Plugin(Isosurface).Run;

  View[nSteps + 4*i].OffsetX = - 0.5*Lx;
  View[nSteps + 4*i + 1].OffsetY = 0.5*Ly;
  View[nSteps + 4*i + 2].OffsetZ = - 0.5*Lz;

  View[nSteps + 4*i].Visible = 1;
  View[nSteps + 4*i + 1].Visible = 1;
  View[nSteps + 4*i + 2].Visible = 1;
  View[nSteps + 4*i + 3].Visible = 1;

  Draw;
  If(Exists(video))
    System "mkdir -p output/iso";
    Print Sprintf("../output/iso/isosurface-%04g.jpg", i);
  EndIf
  If(!Exists(video))
    Sleep 0.2;
  EndIf

  View[nSteps + 4*i].Visible = 0;
  View[nSteps + 4*i + 1].Visible = 0;
  View[nSteps + 4*i + 2].Visible = 0;
  View[nSteps + 4*i + 3].Visible = 0;

EndFor

Exit;
