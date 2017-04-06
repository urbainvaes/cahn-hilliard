if (i%floor(pulsePeriod/dt) >= floor(pulsePeriod/dt)/2) {
  signInput = 1;
}
else
{
  signInput = -1;
}

if(i == 0) {
  ofstream file("parameters.txt",append);
  file << "theta = "           << theta           << endl;
  file << "pulsePeriod = "     << pulsePeriod     << endl;
  file << "pInlet = "          << pInlet          << endl;
  file << "pOutlet = "  << pOutlet  << endl;
}
else {
  if (doesMatch("parameters.txt","theta")) theta = getMatch("parameters.txt","theta");
  if (doesMatch("parameters.txt","pulsePeriod")) pulsePeriod = getMatch("parameters.txt","pulsePeriod");
  if (doesMatch("parameters.txt","pInlet")) pInlet = getMatch("parameters.txt","pInlet");
  if (doesMatch("parameters.txt","pOutlet")) pOutlet = getMatch("parameters.txt","pOutlet");
}
