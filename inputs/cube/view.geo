Merge "geometry.geo";
Merge "output/mesh.msh";

// Generate list of files to be included
System 'ls -v output/output-*.msh > includes.geo';
System 'sed -i "s/^/Merge \"/" includes.geo';
System 'sed -i "s/$/\";/" includes.geo';

// Include output files
Include "includes.geo";

// Clean generated list
System 'rm includes.geo';

// View options
Geometry.SurfaceNumbers = 0;

// Use Euler angles instead of quaternion
General.Trackball = 0;

// Euler angles
General.RotationX = 110;
General.RotationY = 0;
General.RotationZ = 30;

// Specify which parts of the geometry and mesh to draw
Mesh.SurfaceEdges    = 0;
Mesh.VolumeEdges     = 0;
Geometry.Lines       = 0;
Geometry.Surfaces    = 0;
Geometry.Points      = 0;
Geometry.SurfaceType = 0;

// Number of cutting planes
nplanes = 3;

Plugin(CutPlane).A = 1;
Plugin(CutPlane).B = 0;
Plugin(CutPlane).C = 0;
Plugin(CutPlane).D = - 0.5*Lx;
Plugin(CutPlane).View = 0;
Plugin(CutPlane).Run;
View[1].OffsetX = - 0.5*Lx;

Plugin(CutPlane).A = 0;
Plugin(CutPlane).B = 1;
Plugin(CutPlane).C = 0;
Plugin(CutPlane).D = - 0.5*Ly;
Plugin(CutPlane).View = 0;
Plugin(CutPlane).Run;
View[2].OffsetY = - 0.5*Ly;

Plugin(CutPlane).A = 0;
Plugin(CutPlane).B = 0;
Plugin(CutPlane).C = 1;
Plugin(CutPlane).D = - 0.5*Lz;
Plugin(CutPlane).View = 0;
Plugin(CutPlane).Run;
View[3].OffsetZ = 0.5*Lz;

Plugin(Isosurface).Value = 0;
Plugin(Isosurface).View = 0;
Plugin(Isosurface).Run;

For i In {0:PostProcessing.NbViews-1}
  View[i].Visible = 0;
  View[i].ShowScale = 0;
  View[i].RangeType = 2;
  View[i].CustomMin = -2;
  View[i].CustomMax = 2;
EndFor
View[1].ShowScale = 1;

For i In {1:nplanes+1}
  View[i].Visible   = 1;
EndFor

For i In {nplanes+1:PostProcessing.NbViews-2}
  Draw;
  If(Exists(video))
    System "mkdir -p output/iso";
    Print Sprintf("output/iso/isosurface-%04g.jpg", i);
  EndIf
  If(!Exists(video))
    Sleep 0.1;
  EndIf
  For j In {1:nplanes}
    View[j].TimeStep += 1;
  EndFor
  View[i].Visible = 0;
  View[i+1].Visible = 1;
EndFor

Exit;
