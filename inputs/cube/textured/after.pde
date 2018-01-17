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
}
