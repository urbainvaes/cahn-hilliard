# Input and output directories
input_dir="output/"
output_dir="pictures/"

# Number of time steps
n = system("ls output/phi.*.vtk | wc -l") - 1

#bulk free energy
set term png
set output output_dir."BulkFreeEnergy.png"
set xlabel "Time"
set ylabel "Free Energy"
plot input_dir."thermodynamics.txt" u 1:2 w l notitle

#total mass
set term png
set output output_dir."Mass.png"
set yrange [-1:1]
set xlabel "Time"
set ylabel "Mass"
plot input_dir."thermodynamics.txt" u 1:3 w l notitle

#snapshot of contact line
i=70
set term png
set output output_dir."contactLine.png"
set size ratio -1
set xlabel "x"
set ylabel "y"
plot input_dir.'contactLine'.i.'.dat' u 1:2 w l ls 3 title "contact line"

#movie of contact line
set term png
set yrange [0:0.5]
set size ratio -1
set xlabel "x"
set ylabel "y"
do for [ii=1:n:1] {
   outfile = sprintf('.tmp/contactLine%04.0f.png',ii)
   set output outfile
   set title "Contact line - iteration ".ii #textcolor rgb "white"
   plot input_dir.'contactLine'.ii.'.dat' u 1:2 w l ls 3 notitle
}

# Create movie with mencoder
ENCODER = system('which mencoder');
if (strlen(ENCODER)==0) print '=== mencoder not found ==='; exit
CMD = 'mencoder mf://.tmp/*.png -mf fps=25:type=png -ovc lavc -lavcopts vcodec=mpeg4:mbd=2:trell -oac copy -o '.output_dir.'contactLine.avi'
system(CMD)
