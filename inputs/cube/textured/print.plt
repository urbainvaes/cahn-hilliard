#!/usr/bin/env gnuplot

system("mkdir -p pictures/print")
n_files = system("ls output/print/print-*.txt | wc -l") - 1

set term pngcairo
set xrange [0:1]
set yrange [0:1]
set size ratio -1

unset key

do for [i = 0:n_files] {
    input_file = "output/print/print-".i.".txt"

    set output "pictures/print/cube_injection-print-".sprintf('%06.0f',i).".png"
    set title "Iteration: ".i
    set palette defined ( -1 "light-green", 1 "light-blue" )
    plot "output/contactAngle.gnuplot" with filledcurves palette, \
        input_file using 1:2:8 with lines lt rgb "black"

    set palette
    set cbrange [60:120]
    set output "pictures/print/cube_injection-angles-".sprintf('%06.0f',i).".png"
    plot input_file using 1:2:8 with lines palette
}

system('mencoder "mf://pictures/print/cube_injection-print-*.png" -mf fps=4 -o pictures/print.avi -ovc lavc -lavcopts vcodec=mpeg4:vhq')
system('mencoder "mf://pictures/print/cube_injection-angles-*.png" -mf fps=4 -o pictures/angle.avi -ovc lavc -lavcopts vcodec=mpeg4:vhq')
