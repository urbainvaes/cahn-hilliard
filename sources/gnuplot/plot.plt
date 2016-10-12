#!/usr/bin/env gnuplot

# output_file  : output file, of the form [anything].<field>.<style>.<iteration>.<format>

# Arguments
output_file   = system("echo ${output_file}")
output_format = system("echo ${output_file##*.}")
output_iter   = system("basename ${output_file%.*} | tr '-' '\n' | tail -1 | head -1")
output_style  = system("basename ${output_file%.*} | tr '-' '\n' | tail -2 | head -1")
output_field  = system("basename ${output_file%.*} | tr '-' '\n' | tail -3 | head -1")

print "Producing picture ".output_file

# Extract boundary
system("./bin/extractBoundary.py")

input_file   = "output/".output_field."/".output_field.".".output_iter.".gnuplot"
isoline_file = "output/iso/contactLine".output_iter.".dat"
edges_file   = "output/edges.dat"

# Create output directory
system("mkdir -p $(dirname ${output_file})")

set term png
set output "/dev/null"
plot edges_file

x_min = GPVAL_DATA_X_MIN - .05
x_max = GPVAL_DATA_X_MAX + .05
y_min = GPVAL_DATA_Y_MIN - .05
y_max = GPVAL_DATA_Y_MAX + .05

set xrange [x_min:x_max]
set yrange [y_min:y_max]

# Output format
if(output_format eq 'tex') {
    set term epslatex
}

if(output_format eq 'pdf') {
    set term pdf
}

if(output_format eq 'png') {
    set term png
}

if(output_format eq 'wxt') {
  set term wxt
}

set output output_file

unset key
set border
set colorbox
set tics

set size ratio -1
set lmargin at screen 0.06
set rmargin at screen 0.85
set bmargin at screen 0.15
set tmargin at screen 0.95

if(output_field eq 'phi') {
  set title "Phase field ($\\phi$) - Iteration ".output_iter
  set palette defined ( -1 "light-green", 1 "light-blue" )
  set cbrange [-1:1]
}

if(output_field eq 'mu') {
  set title "Chemical potential ($\\mu$) - Iteration ".output_iter
  set palette defined ( -1 "green", 1 "blue" )
}

if(output_field eq 'pressure') {
  set title "Pressure field ($p$) - Iteration ".output_iter
  set palette defined ( -1 "green", 1 "blue" )
}

if(output_field eq 'velocity') {
  set title "Velocity field $(u,v)$ - Iteration ".output_iter
}

if(output_style eq 'filledcurves') {
  plot input_file with filledcurves palette, \
       edges_file with lines lt rgb "brown" lw 1, \
       isoline_file with lines lt rgb "black" lw 1.5
}

if(output_style eq 'mesh') {
  plot input_file with lines palette, \
       edges_file with lines lt rgb "brown" lw 1, \
       isoline_file with lines lt rgb "black" lw 1.5
}

if(output_style eq 'vectors') {
  plot input_file using 1:2:3:4 with vectors filled heads, \
       edges_file with lines lt rgb "brown" lw 1, \
       isoline_file with lines lt rgb "black" lw 1.5
}
