if (i%floor(pulsePeriod/dt) >= floor(pulsePeriod/dt)/2) {
  amplitudeInput = 1;
}
else
{
  amplitudeInput = -1;
}

if(i == 0) {
  ofstream file("parameters.txt",append);
  file << "theta = " << theta << endl;
  file << "pulsePeriod = " << pulsePeriod << endl;
  file << "pInlet = " << pInlet << endl;
  file << "pLateralOutlets = " << pLateralOutlets << endl;
  file << "pCentralOutlet = " << pCentralOutlet << endl;
}
else {
  if (doesMatch("parameters.txt","theta")) theta = getMatch("parameters.txt","theta");
  if (doesMatch("parameters.txt","pulsePeriod")) pulsePeriod = getMatch("parameters.txt","pulsePeriod");
  if (doesMatch("parameters.txt","pInlet")) pInlet = getMatch("parameters.txt","pInlet");
  if (doesMatch("parameters.txt","pLateralOutlets")) pLateralOutlets = getMatch("parameters.txt","pLateralOutlets");
  if (doesMatch("parameters.txt","pCentralOutlet")) pCentralOutlet = getMatch("parameters.txt","pCentralOutlet");
}
