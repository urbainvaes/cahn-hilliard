#!/usr/bin/env gnuplot

n_plots = 1000
n_files = system("ls output/phi/phi.*.vtk | wc -l") - 1
label = system("echo ${label}")

if (n_files > n_plots) {
    step = n_files / n_plots
} else {
    step = 1
}

extension=".png"

# Extract boundary
system("./bin/extractBoundary.py")

do for [i=0:n_files:step] {
    iteration = sprintf('%06.0f',i)
    system("output_file=pictures/phi/".label."-phi-mesh-".iteration.extension." gnuplot gnuplot/plot.plt;")
    system("output_file=pictures/mu/".label."-mu-filledcurves-".iteration.extension." gnuplot gnuplot/plot.plt;")
    system("output_file=pictures/pressure/".label."-pressure-filledcurves-".iteration.extension." gnuplot gnuplot/plot.plt;")
    system("output_file=pictures/u/".label."-u-filledcurves-".iteration.extension." gnuplot gnuplot/plot.plt;")
    system("output_file=pictures/v/".label."-v-filledcurves-".iteration.extension." gnuplot gnuplot/plot.plt;")
}
