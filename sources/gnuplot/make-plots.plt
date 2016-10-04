#!/usr/bin/env gnuplot

n_plots = 20
n_files = system("ls output/phi/phi.*.vtk | wc -l") - 1

if (n_files > n_plots) {
    step = n_files / n_plots
} else {
    step = 1
}

do for [i=0:n_files:step] {
    system("output_file=pictures/phi/phi.mesh.".i.".pdf gnuplot gnuplot/plot.plt;")
    system("output_file=pictures/mu/mu.mesh.".i.".pdf gnuplot gnuplot/plot.plt;")
    system("output_file=pictures/pressure/pressure.filledcurves.".i.".pdf gnuplot gnuplot/plot.plt;")
}
