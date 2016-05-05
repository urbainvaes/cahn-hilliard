###############################
#  Create mesh from geometry  #
###############################
mesh : output/mesh.msh

output/mesh.msh : geometry.geo problem.geo
	gmsh $< -3 -o $@ | tee logs/gmsh.log

###################
#  Run FreeFem++  #
###################
run : output/thermodynamics.txt

includes/gmsh.pde : geometry.geo problem.geo
	grep -h 'export' $^ | sed 's/^/real /' > $@;

output/thermodynamics.txt : solver.pde problem.pde output/mesh.msh includes/gmsh.pde
	FreeFem++ -ne solver.pde -plot 0 | tee logs/freefem.log

##############
#  Graphics  #
##############
VIDEO = pictures/video.mpg
video : $(VIDEO)

$(VIDEO) : view.geo output/thermodynamics.txt
	gmsh -display :0 $< -setnumber video 1
	mencoder "mf://output/iso/*.jpg" -mf fps=10 -o $(VIDEO) -ovc lavc -lavcopts vcodec=mpeg4:vhq

visualization : view.geo output/thermodynamics.txt
	gmsh -display :0 view.geo

view : $(VIDEO)
	DISPLAY=:0 vlc -f $(VIDEO)

###################
#  Clean outputs  #
###################
clean :
	rm -rf  pictures/* output/* includes/* logs/*
