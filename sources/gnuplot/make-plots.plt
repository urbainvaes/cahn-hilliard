#!/usr/bin/env gnuplot

# Process input parameters {{{
output_label  = system("echo ${label}")
output_format = system("echo ${extension}")
max_iter      = system("echo ${max_iter}")
step          = system("echo ${step}")

if (output_format eq '') {
    output_format = 'png'
}


if (max_iter eq '') {
    n_files = system("ls output/phi/phi.*.vtk | wc -l") - 1
    max_iter = n_files
}

if (step eq '') {

    n_plots = 1000;

    if (max_iter > n_plots) {
        step = max_iter / n_plots
    } else {
        step = 1
    }
}
# }}}
# Extract boundary {{{
system("./bin/extractBoundary.py")
edges_file = "output/edges.dat"
# }}}
# Calculate maximum and minimum values of data {{{
set term png
set output "/dev/null"
plot edges_file

delta_x = GPVAL_DATA_X_MAX - GPVAL_DATA_X_MIN
delta_y = GPVAL_DATA_Y_MAX - GPVAL_DATA_Y_MIN
min(x, y) = (x < y ? x : y)

buffer = 0;
if(buffer == 1) {
    x_min = GPVAL_DATA_X_MIN - .05 * min(delta_x,delta_y)
    x_max = GPVAL_DATA_X_MAX + .05 * min(delta_x,delta_y)
    y_min = GPVAL_DATA_Y_MIN - .05 * min(delta_x,delta_y)
    y_max = GPVAL_DATA_Y_MAX + .05 * min(delta_x,delta_y)
}
else {
    x_min = GPVAL_DATA_X_MIN
    x_max = GPVAL_DATA_X_MAX
    y_min = GPVAL_DATA_Y_MIN
    y_max = GPVAL_DATA_Y_MAX
}

set xrange [x_min:x_max]
set yrange [y_min:y_max]
#}}}
# Calculate size to give to terminal {{{
# size_wanted = 7; # Size of canvas (not of plot)
size_wanted = 7; # Size of canvas (not of plot)
ratio_yx = (y_max - y_min)/(x_max - x_min)
if(ratio_yx > 1) {
    size_y = size_wanted
    size_x = size_wanted/ratio_yx
}
else {
    size_x = size_wanted
    size_y = size_wanted*ratio_yx
}
size_scale = 0.2;
size_margin = 0.4;
size_x = size_x + 2*size_margin + size_scale
size_y = size_y + 2*size_margin
#}}}
# Set terminal {{{
if(output_format eq 'tex') {
    set term epslatex size size_x,size_y
}

if(output_format eq 'pdf') {
    set term pdf size size_x,size_y
}

if(output_format eq 'png') {
    pixPerCm = 100
    size_x = pixPerCm*size_x
    size_y = pixPerCm*size_y
    set term pngcairo size size_x,size_y
}
# }}}
# Set layout options {{{
unset key
unset border
unset colorbox
unset tics

set size ratio -1
# set lmargin at screen 0.1
# set rmargin at screen 0.9
# set bmargin at screen 0.1
# set tmargin at screen 0.9
# }}}

system("mkdir -p pictures/phi pictures/mu pictures/pressure pictures/muGradPhi pictures/boundary")

# Plot edges
set output "pictures/boundary/".output_label."-boundary.".output_format
plot edges_file with lines lt rgb "black" lw 2

do for [output_iter=0:max_iter:step] {
    output_index = output_iter
    isoline_file = "output/iso/contactLine".output_iter.".dat"

    output_field="phi"
    output_style="filledcurves"
    load "gnuplot/plot.plt"
}
