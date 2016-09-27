#!/usr/bin/env gnuplot

# Default argument
if (! exists("source")) {
    source = 'phi'
    styl = 'filledcurves'
}

# Extract boundary
system("./bin/extractBoundary.py")

# Directories
sourceDir = "output/".source
outDir = "pictures/gnuplot/".source."/".styl
system("mkdir -p ".outDir)

# Number of time steps
n = system("ls ".sourceDir."/".source.".*.vtk | wc -l") - 1

do for [i=0:n:1] {

  # set term pdf
  # set term epslatex
  set term wxt

  print "Producing picture for iteration ".i."."
  set output sprintf(outDir.'/'.source.'.'.styl.'.%04.0f.tex',i)

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
  }

  if(source eq 'mu') {
      set title "Chemical potential"
  }

  if(source eq 'pressure') {
      set cbrange [0:16]
      set title "Pressure field"
  }

  if(source eq 'velocity') {
      set cbrange [0:16]
      set title "Pressure field"
  }

  if(styl eq 'filledcurves') {
      plot "output/".source."/".source.".".i.".gnuplot" with filledcurves palette, \
           "edges.dat" with lines lt rgb "brown" lw 1, \
           "output/iso/contactLine".i.".dat" with lines lt rgb "black" lw 1.5
  }

  if(styl eq 'mesh') {
      plot "output/".source."/".source.".".i.".gnuplot" with lines palette, \
          "edges.dat" with lines lt rgb "brown" lw 1, \
          "output/iso/contactLine".i.".dat" with lines lt rgb "black" lw 1.5
  }


  x_min = GPVAL_DATA_X_MIN - .05
  x_max = GPVAL_DATA_X_MAX + .05
  y_min = GPVAL_DATA_Y_MIN - .05
  y_max = GPVAL_DATA_Y_MAX + .05

  set xrange [x_min:x_max]
  set yrange [y_min:y_max]
}
