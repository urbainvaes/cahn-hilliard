// Mass flux in the domain

// Position of center of mass
massPhi1 = int3d(Th) ((phi + 1.)/2.);
real positionX = int3d(Th) ((phi + 1.)/2. * x) / massPhi1;
real positionY = int3d(Th) ((phi + 1.)/2. * y) / massPhi1;

cout << endl
     << "** Problem-specific output **"  << endl
     << "Imposed mass flux: "            << massFlux  << endl // Careful: factor 2 between massPhi and massPhi1
     << "Total mass of phi = 1: "        << massPhi1  << endl
     << "X position of center of mass: " << positionX << endl
     << "Y position of center of mass: " << positionY << endl;

// Contact plane

// Projection of solution on plane
printPlane=phi;

real[int,int] xy(3,1); int[int] be(1);
int nbc = isoline(ThSquare, printPlane, xy, close=false, iso=0.0, beginend=be, smoothing=0.1);

Vh dxphi = dx(phi);
Vh dyphi = dy(phi);
Vh dzphi = dz(phi);

{
    real lengthOfLine = 0;

    ofstream fiso("output/print/print-"+i+".txt");
    for( int c = 0; c < nbc; ++c) {
        for(int iAfter = be[2*c]; iAfter <  be[2*c+1]; ++iAfter) {

            real xc = xy(0,iAfter);
            real yc = xy(1,iAfter);
            real length = xy(2,iAfter);
            real normGrad = sqrt(dxphi(xc,yc,0)^2 +  dyphi(xc,yc,0)^2 + dzphi(xc,yc,0)^2);
            real localContactAngle = acos(-dzphi(xc,yc,0)/normGrad)*180/pi;

            fiso << xc                      << " "
                 << yc                      << " "
                 << c                       << " "
                 << length                  << " "
                 << dxphi(xc,yc,0)/normGrad << " "
                 << dyphi(xc,yc,0)/normGrad << " "
                 << dzphi(xc,yc,0)/normGrad << " "
                 << localContactAngle       << " "
                 << endl;
        }

        lengthOfLine = lengthOfLine + xy(2, be[2*c+1] - 1);

        if(c != nbc - 1)
            fiso << endl;
    }

    ofstream flength("output/print/lengthPrint.txt",append);
    flength << lengthOfLine << endl;
    cout << "Length of the contact line: " << lengthOfLine << endl;
}
