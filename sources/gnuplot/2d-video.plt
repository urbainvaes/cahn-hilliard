#!/usr/bin/env gnuplot

# Number of time steps
n = system("ls output/phi/phi.*.vtk | wc -l") - 1

# set term png
# set term pdf size 12cm,3cm
# set term pdf
set term epslatex
# set term wxt

# Extract boundary
system("./bin/extractBoundary.py")

# Create output directory
system("mkdir -p pictures/gnuplot")

do for [i=0:100:10] {

  print "Producing picture for iteration ".i."."

  ## PHASE
  outfile = sprintf('pictures/gnuplot/phase.%04.0f.tex',i)
  set output outfile
  set title "Phase field ($\\phi$)"

  # set table "geometry.dat"
  # splot "output/phi/phi.".i.".gnuplot"
  # unset table

  # set pm3d
  # set view map
  # set dgrid3d 10,10 # Comment to see mesh
  # splot "output/phi/phi.".i.".gnuplot" with points palette

  set cbrange [-1:1]
  set palette defined ( -1 "light-green", 1 "light-blue" )

  unset key
  set border
  set colorbox
  set tics

  # Margins
  set size ratio -1
  set lmargin at screen 0.06
  set rmargin at screen 0.85
  set bmargin at screen 0.15
  set tmargin at screen 0.95

  plot "output/phi/phi.".i.".gnuplot" with filledcurves palette, \
       "edges.dat" with lines lt rgb "brown" lw 1, \
       "output/iso/contactLine".i.".dat" with lines lt rgb "black" lw 1.5

  unset multiplot
  x_min = GPVAL_DATA_X_MIN - .1
  x_max = GPVAL_DATA_X_MAX + .1
  y_min = GPVAL_DATA_Y_MIN - .1
  y_max = GPVAL_DATA_Y_MAX + .1

  set xrange [x_min:x_max]
  set yrange [y_min:y_max]

  ## MESH
  outfile = sprintf('pictures/gnuplot/mesh-phase.%04.0f.tex',i)
  set output outfile

  plot "output/phi/phi.".i.".gnuplot" with lines palette, \
       "edges.dat" with lines lt rgb "brown" lw 1, \
       "output/iso/contactLine".i.".dat" with lines lt rgb "black" lw 1.5

}

ENCODER = system('which mencoder');
if (strlen(ENCODER)==0) print '=== mencoder not found ==='; exit
CMD = 'mencoder mf://pictures/gnuplot/*.png -mf fps=25:type=png -ovc lavc -lavcopts vcodec=mpeg4:mbd=2:trell -oac copy -o pictures/phase.avi'
system(CMD)
