input_file   = "output/".output_field."/".output_field.".".output_iter.".gnuplot"
output_file  = "pictures/".output_field."/".output_label."-".output_field."-".output_style."-".output_index.".".output_format
set output output_file

print "Producing picture ".output_file." from ".input_file

if(output_field eq 'phi') {
  set title "Phase field - Iteration ".output_iter
  # set palette maxcolors 2
  set palette defined ( -1 "light-green", 1 "light-blue" )
  set cbrange [-1:1]
}

if(output_field eq 'mu') {
  set title "Chemical potential ($\\mu$) - Iteration ".output_iter
}

if(output_field eq 'pressure') {
  set title "Pressure field ($p$) - Iteration ".output_iter
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
  plot input_file using 1:2:(.01*$3):4 with vectors filled heads, \
       edges_file with lines lt rgb "brown" lw 1, \
       isoline_file with lines lt rgb "black" lw 1.5
}
