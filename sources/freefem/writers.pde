macro savegmsh(filename, title, time, iteration, field) {
  ofstream data(filename);
  writeHeader(data);
  write1dData(data, title, time, iteration, field);
} //EOM

macro savegmsh2(filename, title, time, iteration, field1, field2) {
  ofstream data(filename);
  writeHeader(data);
  write2dData(data, title, time, iteration, field1, field2);
} //EOM

macro savegmsh3(filename, title, time, iteration, field1, field2, field3) {
  ofstream data(filename);
  writeHeader(data);
  write3dData(data, title, time, iteration, field1, field2, field3);
} //EOM

macro savemesh(filename, vh, th) {
  ofstream currentMesh(filename);
  writeHeader(currentMesh);
  writeNodes(currentMesh, vh);
  writeElements(currentMesh, vh, th);
} //EOM

macro savegnuplot(filename, th, field) {
  ofstream data(filename);
  for (int ielem=0; ielem<th.nt; ielem++) {
    for (int j=0; j <3; j++)
      data << th[ielem][j].x << " " << th[ielem][j].y << " " << field[][Vh(ielem,j)] << endl;
    data << th[ielem][0].x << " " << th[ielem][0].y << " " << field[][Vh(ielem,0)] << "\n\n\n";
  }
} //EOM

macro savegnuplot2(filename, th, vh, field1, field2) {
  ofstream data(filename);
  Vh[int] xh(2); xh[0] = x; xh[1] = y;
  for (int inode = 0; inode < Vh.ndof; inode++) {
      data << xh[0][][inode]                              << " "
           << xh[1][][inode]                              << " "
           << field1[][inode]                             << " "
           << field2[][inode]                             << " "
           << sqrt(field1[][inode]^2 + field2[][inode]^2) << endl;
  }
} //EOM
