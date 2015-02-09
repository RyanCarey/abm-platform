using Winston
using Distributions

include("diffusion.jl")

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

#Ze still need to correct the possible borders porblems: the min works for rectangle only!!!!!!!!!!!!!!!
function angle_from_ligand(cell)
 	x = cell.loc.x
  	y = cell.loc.y
  	r = cell.r
	#println(x," ",y)
	#println(nb_ligands)
  	list_ligand=Array(Float64,int(nb_ligands),6) #angle,x,y,ligand concentration in (x,y), cumulative distribution probability, cumulative squared distribution

	for i in 1:nb_ligands
		angle=(i-1)*2*pi/nb_ligands

		list_ligand[i,1] = angle
		list_ligand[i,2] = x+cos(angle)*r#min(Y_SIZE-(floor(y + sin(angle)*r)),Y_SIZE)
		list_ligand[i,3] = y+sin(angle)*r#min(floor(x + cos(angle)*r) + 1,X_SIZE)

		list_ligand[i,4] = ligand_concentration_multiplesource_2D(list_ligand[i,2],list_ligand[i,3])

		if(i==1)
			list_ligand[i,5]=list_ligand[i,4]
			list_ligand[i,6]=list_ligand[i,4]^2
		else
			list_ligand[i,5]=list_ligand[i-1,5]+list_ligand[i,4]
			list_ligand[i,6]=list_ligand[i-1,6]+list_ligand[i,4]^2
		end
	end
	#Cumulative ligand concentration probability
	#0<list_ligand(1,5)<list_ligand(2,5)<...<list_ligand(last,5)=1	
	if(maximum(list_ligand[:,5]!=0))
		list_ligand[:,5] = list_ligand[:,5]./maximum(list_ligand[:,5])
		list_ligand[:,6] = list_ligand[:,6]./maximum(list_ligand[:,6])
	end
	#println(list_ligand)
	#Method 1: we choose the angle which has the maximum concentration
	choosen_angle_1=list_ligand[indmax(list_ligand[:,4]),1]

	#Method 2: we chose the angle thanks to a uniform distribution
	#and the cumulative probability of the ligand concentration:
	#We need to round to the rand() to the ceil of an element of list_ligand(:,5)
	choosen_angle_2=list_ligand[findfirst(list_ligand[:,5].>rand()),1]

	#Method 3: same as method 2 with a squared distribution
	choosen_angle_3=list_ligand[findfirst(list_ligand[:,6].>rand()),1]
	
  	return choosen_angle_1
end

#Combination of the two methods
#probability is the probability of choosing the angle from the persistent random walk over the direction fro; the ligand
function angle_from_both(cell::Cell)
	if(rand()<probability_persistent && iter>1)
		angle=cell.angle
	else
		angle=angle_from_ligand(cell)
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
