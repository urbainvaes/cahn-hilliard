function ct_line
Nt = 1000;
Np = 4;
Time = linspace(1,Nt,Nt);
THA  = zeros(Nt,1);
THR  = zeros(Nt,1);
V    = zeros(Nt,1);
pi = 3.1415926535;
for i=1:Nt
    H = fscanfMat('contactLine'+string(i)+'.dat');
    [nlines,ncolumns] = size(H);
    ctpA = [H(1:Np,1) H(1:Np,2)]; 
    P = polyfit(ctpA(:,1),ctpA(:,2),1); 
    m = P(1)/abs(P(1));    
    THA(i) = pi*(m+1)/2-atan(P(1));
    ctpR = [H(nlines-Np:nlines,1) H(nlines-Np:nlines,2)]; 
    P = polyfit(ctpR(:,1),ctpR(:,2),1);     
    m = P(1)/abs(P(1));
    THR(i) = pi*(1-m)/2+atan(P(1));
end
scf(0)
xtitle("","iteration","contact angle")
plot(Time,THR*180/pi)
//plot(Time,THA*180/pi,Time,THR*180/pi)
xs2png(0,'contactAngle.png');
endfunction
