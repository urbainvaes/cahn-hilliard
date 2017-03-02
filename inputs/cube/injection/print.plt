#!/usr/bin/env gnuplot

system("mkdir -p pictures/print")
n_files = system("ls output/print/print-*.txt | wc -l") - 1

set term pngcairo
set xrange [0:1]
set yrange [0:1]

unset key

do for [i = 0:n_files] {
    set output "pictures/print/cube_injection-print-".sprintf('%06.0f',i).".png"
    input_file = "output/print/print-".i.".txt"

    size = system("cat ".input_file." | sed '/^$/d' | awk '{print $1,$2}' > tmp.txt; \
                    cat tmp.txt | sed '1d' > tmp1.txt; cat tmp.txt | sed '$d' > tmp2.txt; \
                    paste tmp1.txt tmp2.txt | awk 'BEGIN{s=0}{s+=sqrt(($1 - $3)^2 + ($2 - $4)^2)}END{print s}';\
                    rm tmp.txt tmp1.txt tmp2.txt")

    set title "Iteration: ".i." / Size of the print: ".sprintf('%6.2f',size + 0)
    plot input_file with lines
}

system('mencoder "mf://pictures/print/*.png" -mf fps=4 -o pictures/print.avi -ovc lavc -lavcopts vcodec=mpeg4:vhq')
