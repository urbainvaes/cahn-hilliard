# Number of time steps
n = system("ls output/phi.*.vtk | wc -l") - 1

set term png
unset key
set pm3d
set view map
# set palette rgb 33,13,10;
# set palette maxcolors 2
set palette defined ( 0 "red", 1 "blue" )
set dgrid3d 200,200 # Comment to see mesh
set cbrange [-1.5:1.5]

system("mkdir -p pictures/gnuplot")
do for [i=1:n:1] {
   outfile = sprintf('pictures/gnuplot/phase.%04.0f.png',i)
   set output outfile
   set title "Phase field at iteration ".i
   splot "output/phi.".i.".gnuplot" with lines palette
   print "Producing picture for iteration ".i."."
}

ENCODER = system('which mencoder');
if (strlen(ENCODER)==0) print '=== mencoder not found ==='; exit
CMD = 'mencoder mf://pictures/gnuplot/*.png -mf fps=25:type=png -ovc lavc -lavcopts vcodec=mpeg4:mbd=2:trell -oac copy -o pictures/phase.avi'
system(CMD)
