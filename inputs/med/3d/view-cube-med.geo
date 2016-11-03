System "ls -v output/phi/phi-*.pos | sed '1d'  > includes.geo";
System 'sed -i "s/^\(.\+\)$/Merge \"\1\";/" includes.geo';

Hide {
  Surface {
    Physical Surface{1},
    Physical Surface{2},
    Physical Surface{3}
  };
}

General.Trackball = 0;
General.RotationX = 300.7256005599669;
General.RotationY = 1.020846997272915;
General.RotationZ = 318.5479184306434;

Mesh.ColorCarousel = 2;
Mesh.SurfaceEdges  = 1;
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

Merge "output/mesh.msh";
Include "includes.geo";
System 'rm includes.geo';

nSteps = PostProcessing.NbViews;

For i In {0:nSteps-1}
  nplanes = 3;
  niso = 3;

  Plugin(CutPlane).A = 1;
  Plugin(CutPlane).B = 0;
  Plugin(CutPlane).C = 0;
  Plugin(CutPlane).D = 0;
  Plugin(CutPlane).View = i;
  Plugin(CutPlane).Run;

  Plugin(CutPlane).A = 0;
  Plugin(CutPlane).B = 1;
  Plugin(CutPlane).C = 0;
  Plugin(CutPlane).D = - Ly;
  Plugin(CutPlane).View = i;
  Plugin(CutPlane).Run;

  Plugin(CutPlane).A = 0;
  Plugin(CutPlane).B = 0;
  Plugin(CutPlane).C = 1;
  Plugin(CutPlane).D = 0;
  Plugin(CutPlane).View = i;
  Plugin(CutPlane).Run;

  Plugin(Isosurface).Value = -0.5;
  Plugin(Isosurface).View = i;
  Plugin(Isosurface).Run;

  Plugin(Isosurface).Value = -0;
  Plugin(Isosurface).View = i;
  Plugin(Isosurface).Run;

  Plugin(Isosurface).Value = 0.5;
  Plugin(Isosurface).View = i;
  Plugin(Isosurface).Run;

  For j In {0:nplanes + niso - 1}
    View[nSteps + 4*i + j].Visible = 1;
  EndFor

  Draw;

  If(Exists(video))
    System "mkdir -p output/iso";
    Print Sprintf("output/iso/isosurface-%04g.jpg", i);
  EndIf
  If(!Exists(video))
    Sleep 0.2;
  EndIf

  For j In {0:nplanes + niso - 1}
    View[nSteps + 4*i + j].Visible = 0;
  EndFor
EndFor

Exit;
