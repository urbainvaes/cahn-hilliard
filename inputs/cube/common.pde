// CONTACT ANGLE VISUALIZATION
mesh ThSquare; ThSquare = gmshload("square.msh");
fespace VhSquare(ThSquare,P1);
VhSquare contactAngleVh = contactAngles * 180 / pi;
{
  ofstream data("contactAngle.msh");
  writeHeader(data);
  write1dData(data, "ContactAngle", 0, 0, contactAngleVh);

  ofstream ftheta("output/contactAngle.gnuplot");
  for (int ielem=0; ielem<ThSquare.nt; ielem++) {
      for (int j=0; j <3; j++) {
          ftheta << ThSquare[ielem][j].x << " " << ThSquare[ielem][j].y << " " << contactAngleVh[][VhSquare(ielem,j)] << endl;
      }
      ftheta << ThSquare[ielem][0].x << " " << ThSquare[ielem][0].y << " " << contactAngleVh[][VhSquare(ielem,0)] << "\n\n\n";
  }
}

system("./bin/msh2pos square.msh contactAngle.msh");

// PRINT OF DROPLET
VhSquare printPlane;
system("mkdir -p" + " output/print output/cubeDynamics");

{
    ofstream dummy1("output/cubeDynamics/lengthPrint.txt");
    ofstream dummy2("output/cubeDynamics/massPhi1.txt");
    ofstream dummy3("output/cubeDynamics/positionX.txt");
    ofstream dummy4("output/cubeDynamics/positionY.txt");
};
