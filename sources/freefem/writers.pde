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

macro savemeshgmsh(filename, vh, th) {
  ofstream currentMesh(filename);
  writeHeader(currentMesh);
  writeNodes(currentMesh, vh);
  writeElements(currentMesh, vh, th);
} //EOM

macro savefreefem(filename, field) {
    ofstream data(filename);
    data << field[];
} //EOM

macro readfreefem(filename, field) {
    ifstream data(filename);
    data >> field[];
} //EOM
