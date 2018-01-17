// Create file
if(i == 0) 
{
    ofstream afterFangle("output/angle.txt");
}

// Extract isoline
real[int,int] afterXY(3,1);
isoline(Th, phi, afterXY, close=false, iso=0.0, smoothing=0.1, file="output/isoline/contact_line"+i+".txt");

// Gradient
Vh afterDxphi = dx(phi);
Vh afterDyphi = dy(phi);

// First and second points on the line
real afterX0 = afterXY(0,0);
real afterY0 = afterXY(1,0);

real afterX1 = afterXY(0,10);
real afterY1 = afterXY(1,10);

real afterDeltaX = -(afterX1 - afterX0);
real afterDeltaY = afterY1 - afterY0;

cout << "(" << afterX0 << "," << afterY0 << ")" << endl;
cout << "(" << afterX1 << "," << afterY1 << ")" << endl;
cout << "atan2(" << afterDeltaX << "," << afterDeltaY << ") = " << atan2(afterDeltaX,afterDeltaY) <<  endl;

real afterAngle = atan2(afterDeltaY,afterDeltaX) * 180 / pi;

{
    ofstream afterFangle("output/angle.txt", append);
    afterFangle << afterAngle << endl;
}
