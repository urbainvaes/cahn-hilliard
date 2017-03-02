// Mass flux in the domain
cout << "Mass flux: " << massFlux << endl;
cout << "Real mass flux: " << int2d(Th,1) (dz(mu)) << endl;

// Position of center of mass
massPhi1 = int3d(Th) ((phi + 1.)/2.);  
real positionX = int3d(Th) ((phi + 1.)/2. * x) / massPhi1;
real positionY = int3d(Th) ((phi + 1.)/2. * y) / massPhi1;
cout << "Total mass of phi = 1: " << massPhi1 << endl;
cout << "X position of center of mass: " << positionX << endl;
cout << "Y position of center of mass: " << positionY << endl;

// Contact plane
printPlane=phi;
real[int,int] xy(3,1);
isoline(ThSquare, printPlane, xy, close=false, iso=0.0, smoothing=0.1, file="output/print/print-"+i+".txt");
