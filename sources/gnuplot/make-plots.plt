#!/usr/bin/env gnuplot

n_plots = 20
n_files = system("ls output/phi/phi.*.vtk | wc -l") - 1
label = system("echo ${label}")

if (n_files > n_plots) {
    step = n_files / n_plots
} else {
    step = 1
}

do for [i=0:n_files:step] {
    system("output_file=pictures/phi/".label."-phi-mesh-".i.".pdf gnuplot gnuplot/plot.plt;")
    system("output_file=pictures/mu/".label."-mu-mesh-".i.".pdf gnuplot gnuplot/plot.plt;")
    system("output_file=pictures/pressure/".label."-pressure-filledcurves-".i.".pdf gnuplot gnuplot/plot.plt;")
    system("output_file=pictures/u/".label."-u-filledcurves-".i.".pdf gnuplot gnuplot/plot.plt;")
    system("output_file=pictures/v/".label."-v-filledcurves-".i.".pdf gnuplot gnuplot/plot.plt;")
}
