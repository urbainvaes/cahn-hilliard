input_file   = "output/".output_field."/".output_field.".".output_iter.".gnuplot"
output_file  = "pictures/".output_field."/".output_label."-".output_field."-".output_style."-".output_index.".".output_format
set output output_file

print "Producing picture ".output_file." from ".input_file

if(output_field eq 'phi') {
  # set title "Phase field - Iteration ".output_iter
  unset title
  # set palette maxcolors 2
  set palette defined ( -1 "light-green", 1 "light-blue" )
  set cbrange [-1:1]
}

if(output_field eq 'mu') {
  # set title "Chemical potential - Iteration ".output_iter
  unset title
  unset cbrange
  set palette defined ( 0 '#000090', 1 '#000fff', 2 '#0090ff', 3 '#0fffee', 4 '#90ff70', 5 '#ffee00', 6 '#ff7000', 7 '#ee0000', 8 '#7f0000')
}

if(output_field eq 'pressure') {
  set title "Pressure field - Iteration ".output_iter
  set cbrange [0:100]
  # set palette defined ( -1 "light-green", 1 "light-blue" )
  set palette defined ( 0 '#000090', 1 '#000fff', 2 '#0090ff', 3 '#0fffee', 4 '#90ff70', 5 '#ffee00', 6 '#ff7000', 7 '#ee0000', 8 '#7f0000')
}

if(output_field eq 'velocity') {
  set title "Velocity field $(u,v)$ - Iteration ".output_iter
}

if(output_field eq 'muGradPhi') {
  set title "||mu . grad(phi)|| - Iteration".output_iter
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
