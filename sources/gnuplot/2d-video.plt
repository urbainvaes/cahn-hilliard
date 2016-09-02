# Number of time steps
n = system("ls output/phi/phi.*.vtk | wc -l") - 1

set term pdf size 12cm,3cm

system("mkdir -p pictures/gnuplot")
do for [i=0:n:10] {

  outfile = sprintf('pictures/gnuplot/phase.%04.0f.pdf',i)
  set output outfile

  set table "geometry.dat"
  splot "output/phi/phi.".i.".gnuplot"
  unset table

  set cbrange [-1.5:1.5]
  set palette defined ( -1 "light-gray", 1 "light-blue" )

  unset key
  unset tics
  unset border
  unset colorbox

  set size ratio -1
  set lmargin at screen 0.05
  set rmargin at screen 0.95
  set bmargin at screen 0.05
  set tmargin at screen 0.95
  plot "geometry.dat" with lines palette, \
       "output/iso/contactLine".i.".dat" with lines

  print "Producing picture for iteration ".i."."
}

ENCODER = system('which mencoder');
if (strlen(ENCODER)==0) print '=== mencoder not found ==='; exit
CMD = 'mencoder mf://pictures/gnuplot/*.png -mf fps=25:type=png -ovc lavc -lavcopts vcodec=mpeg4:mbd=2:trell -oac copy -o pictures/phase.avi'
system(CMD)
