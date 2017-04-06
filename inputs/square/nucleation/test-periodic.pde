load "gmsh"

// mesh Th=square(20,20,[2*pi*x,2*pi*y]);
mesh Th=gmshload("square.msh");
fespace Vh(Th,P2,periodic=[[2,y],[4,y],[1,x],[3,x]]);

Vh uh,vh;
func f=sin(x+pi/4.)*cos(y+pi/4.);

problem laplace(uh,vh) =
  int2d(Th)( dx(uh)*dx(vh) + dy(uh)*dy(vh) )
+ int2d(Th)( -f*vh )
;                

laplace;
plot(uh,value=true);
