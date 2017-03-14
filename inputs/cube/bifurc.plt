
#!/usr/bin/env gnuplot

system("mkdir -p pictures/cubeDynamics")

set term pdf
unset key
set xlabel "Volume of fluid 1"

set output "pictures/cubeDynamics/V-lx.pdf"
set title "X-coordinate of the center of mass"
plot "<paste output/cubeDynamics/massPhi1.txt output/cubeDynamics/positionX.txt" w l

set output "pictures/cubeDynamics/V-ly.pdf"
set title "Y-coordinate of the center of mass"
plot "<paste output/cubeDynamics/massPhi1.txt output/cubeDynamics/positionY.txt" w l

set output "pictures/cubeDynamics/V-contactLine.pdf"
set title "Length of the contact line(s)"
plot "<paste output/cubeDynamics/massPhi1.txt output/cubeDynamics/lengthPrint.txt" w l
