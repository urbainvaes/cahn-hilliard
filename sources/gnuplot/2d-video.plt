# Number of time steps
n = system("ls output/phi/phi.*.vtk | wc -l") - 1

set term png

system("mkdir -p pictures/gnuplot")
do for [i=1:n:1] {

  outfile = sprintf('pictures/gnuplot/phase.%04.0f.png',i)
  set output outfile

  set table "geometry.dat"
  splot "output/phi/phi.".i.".gnuplot"
  unset table

  unset key
  set size square
  unset colorbox
  set cbrange [-1.5:1.5]
  set title "Phase field at iteration ".i
  set palette rgb 33,13,10;
  # set palette defined ( 0 "gray", 1 "gray" )
  # set pm3d
  # set view map
  # set dgrid3d # Comment to see mesh
  plot "geometry.dat" with lines palette, \
       "output/iso/contactLine".i.".dat" with lines

  # set multiplot
  # unset multiplot
  # set yrange [GPVAL_Y_MIN:GPVAL_Y_MAX]
  # set xrange [GPVAL_X_MIN:GPVAL_X_MAX]

  print "Producing picture for iteration ".i."."
}

ENCODER = system('which mencoder');
if (strlen(ENCODER)==0) print '=== mencoder not found ==='; exit
CMD = 'mencoder mf://pictures/gnuplot/*.png -mf fps=25:type=png -ovc lavc -lavcopts vcodec=mpeg4:mbd=2:trell -oac copy -o pictures/phase.avi'
system(CMD)
