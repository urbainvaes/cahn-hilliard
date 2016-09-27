#!/usr/bin/env gnuplot

# Default argument
if (! exists("source")) {
    source = 'phi'
    sink = 'phi/filledcurves'
}

# Number of time steps
n = system("ls output/".source."/".source.".*.vtk | wc -l") - 1

# Extract boundary
system("./bin/extractBoundary.py")

outputDir = "pictures/gnuplot/".sink
system("mkdir -p ".outputDir)

do for [i=0:n:10] {

  # set term pdf
  set term epslatex
  # set term wxt

  print "Producing picture for iteration ".i."."
  set output sprintf(outputDir.'/'.source.'.%04.0f.tex',i)

  unset key
  set border
  set colorbox
  set tics

  set size ratio -1
  set lmargin at screen 0.06
  set rmargin at screen 0.85
  set bmargin at screen 0.15
  set tmargin at screen 0.95

  if(source eq 'phi') {
      set title "Phase field ($\\phi$)"
      set cbrange [-1:1]
      set palette defined ( -1 "light-green", 1 "light-blue" )

      if(sink eq 'phi/filledcurves') {
          plot "output/phi/phi.".i.".gnuplot" with filledcurves palette, \
               "edges.dat" with lines lt rgb "brown" lw 1, \
               "output/iso/contactLine".i.".dat" with lines lt rgb "black" lw 1.5
      }

      if(sink eq 'phi/mesh') {
          plot "output/phi/phi.".i.".gnuplot" with lines palette, \
               "edges.dat" with lines lt rgb "brown" lw 1, \
               "output/iso/contactLine".i.".dat" with lines lt rgb "black" lw 1.5
      }
  }

  x_min = GPVAL_DATA_X_MIN - .05
  x_max = GPVAL_DATA_X_MAX + .05
  y_min = GPVAL_DATA_Y_MIN - .05
  y_max = GPVAL_DATA_Y_MAX + .05

  set xrange [x_min:x_max]
  set yrange [y_min:y_max]
}
