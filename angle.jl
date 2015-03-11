using Winston
using Distributions

#include("diffusion.jl")

# Proposed angle of direction for the cell
# Biased Random Walk V2
# Ca is the coordinate (x,y,z) of the studied cell
# r is the radius of a cell
# ML is the matrix of ligand's concentration
# degree_precision is an integer and the numnber of ligants we are going to use to assess the favorite direction
# 1-We first need to adapt the localization of the cell to the matrix. The cell will be spotted by the cooridnates (they can be float)
# whereas the matrix is located thaks to integer. We assume that the localisation of the cell matches with the coordinates of the matrix.
# If C=(5.2,6.3) then the center of teh cell will be in the cell (6,7). We start to count the colums at 1 for the matrix.
# We cannot have a localization (0.2,0.1) within the matrix but we can for the cell center.
# We call a ligand-concentration vector the product of teh concentration of ligand with the vector going from the center of the cell to the cell of the ligand concentration
# Moreover, the matrix of the cocnetration starts from the top left and the localization of the celle starts form the bottom left
#
# 2-We choose the number of possible directions by creating a angle step = 2*pi/degree_precision
#
# t : time_step
# nb_ligands : number of ligands around the cell ie the number of possible directions
# cell : data from the cell we want to assess the next angle


function angle_from_ligand(cell::Cell, k::Int, x_size::Real, y_size::Real)

   	x = cell.x
  	y = cell.y
  	r = cell.r

  	global list_ligand=Array(Float64,int(nb_ligands),4) #angle,x,y,ligand concentration in (x,y)


	for i in 1:nb_ligands
		angle=(i-1)*2*pi/nb_ligands
		list_ligand[i,1] = angle
		list_ligand[i,2] = x+cos(angle)*r
		list_ligand[i,3] = y+sin(angle)*r
		if(type_source=="Point")
      		  list_ligand[i,4] = ligand_concentration_multiplesource_2D(list_ligand[i,2],list_ligand[i,3])
		  concentration_threshold=ligand_concentration_multiplesource_2D(x_size/2,y_size/2,0)
		else
      		  list_ligand[i,4] = ligand_concentration_multiplesource_1D(list_ligand[i,2])
		end

	end

	ratio = maximum(list_ligand[:, 4]) / mean(list_ligand[:, 4])
	concentration_threshold = categories[cell.cell_type].stem_threshold
  # If the largest concentration of ligand is less than the threshold or the ratio of max / mean is less that 1.1, choose a random angle.
  # Else move towards the source perfectly.
  println("Maximum ligand is: ", maximum(list_ligand[:, 4]))
  println("Mean ligand is: ", mean(list_ligand[:, 4]))
  println("Ratio is: ", ratio)
	if (maximum(list_ligand[:, 4]) < concentration_threshold || ratio < 1.001)
	  choosen_angle = randn() * pi
	  println("Random Angle: ", choosen_angle)
	else
	  choosen_angle = list_ligand[indmax(list_ligand[:,4]), 1]
	  println("Deterministic Angle: ", choosen_angle)
	end




	# Multiple the chosen angle by the cell type defined concentration response.
	return choosen_angle * categories[cell.cell_type].conc_response

end

#Combination of the two methods
#probability is the probability of choosing the angle from the persistent random walk over the direction from the ligand
function angle_from_both(cell::Cell, randomness::Real, x_size::Real, y_size::Real)
	if(rand() < categories[cell.cell_type].persistence && iter > 1)
		angle = mod2pi(cell.angle)
	else
		angle = mod2pi((1-randomness)*angle_from_ligand(cell, 1, x_size, y_size) + randomness * rand() * 2pi)
	end
	return angle
end


#Persistent Biased Random walk
#function anglePBRW(conc_map, cell)
#  if PERSISTENCE == 0
#    println("persistence rounded to 9999999")
#    stdev = 9999999
#  else
#    stdev = sqrt(-log(PERSISTENCE))
#  end
#  # ?should be var or stdev?
#	return OMEGA*angleBRW(conc_map,cell) + (1-OMEGA)*anglePRW(cell,stdev)
#end
