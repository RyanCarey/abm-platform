# This function return a list of ligand
# nx is the number of ligands on the X axis
# x,y,z are the lengths of the environmental square
#
# At first we are going to assume that we work in 2D and that the concentration of ligands is the same along y
# and there is a maximum in x=0, the decreasing is linear.
# Therefore we assume that :
#   1- distance_x(Li-1,Li)+step=distance_x(Li,Li+1)
#   2- sum(i=0..n-1, distance_x(li,li+1))=x
#   3- ny=nx/2
# A brief calculuus provides:
# step = 2*X / (nx-1)(nx)
# And there are nx*ny ligands

function ligand(nx=1000,x=1,y=1,z=1)

stepx =(2*x/((nx-1)*(nx)))
ny = int(floor(nx/2))
stepy = y/ny
list=Array(Float64,nx*ny,2)

for i in 1:nx
	for j in 1:ny
		list[(i-1)*ny+j,1]=(i-1)*(i-1/2)*stepx/2
		list[(i-1)*ny+j,2]=(j-1/2)*stepy
	end
end
return list
end
