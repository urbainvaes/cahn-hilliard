if(i == 0) {
  ofstream file("parameters.txt",append);
  file << "theta = " << theta << endl;
  file << "pInlet = " << pInlet << endl;
}
else {
  if (doesMatch("parameters.txt","theta")) theta = getMatch("parameters.txt","theta");
  if (doesMatch("parameters.txt","pInlet")) pInlet = getMatch("parameters.txt","pInlet");
}
