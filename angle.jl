# Biased Random Walk V2
# C is the coordinate (x,y,z) of the studied cell
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
# 3-The receptors move with the angle alpha which follows a Biased Random Walk
# ie. alpha ~ N(beta,var)
# where beta is the angle of the sum of the ligand-concentration vectors
# and assuming a normal wrapped distribution for the pregfered angle, we assume that:
# var = sqrt(ln(1/R^2))
# R is the length of the mean resultant ; R = norm(sum(ligand vector))/sum(norm(ligand vector))
# 
# 3bis-We have also constructed another way of calculating the variance, but it is just intuitive:
# var=1/degree_precision(sum(i=1..degree_precision)(ML(concentration's cell (i))/maximum(ML) * distance(beta,angle(i)))
# where angle(i)=i*2*pi/degree_precision
# var= var + ML[round(C[1] + cos(angle)*r)+1,round(C[2] + sin(angle)*r)+1]/maximum(ML)  *  min(abs(beta-angle),2*pi-abs(beta-angle))*min(abs(beta-angle),2*pi-abs(beta-angle))

function angleBRW(ML=ones(50,50),C=[10,10,0.5],degree_precision=360)
  r = C[3]
	sum_x=0
	sum_y=0
	sum_norm_vect=0
	for i in 1:degree_precision
		angle=i*2*pi/degree_precision
		#we add one to correct the fact that the matrix doesn't start at 0 and we correct the fact that matrix start from the top left
		x_ligand_i = round(C[1] + cos(angle)*r) + 1
		y_ligand_i = round(y_size - (C[2] + sin(angle)*r)) + 1
		sum_norm_vect += ML[y_ligand_i,x_ligand_i]
		sum_x += ML[y_ligand_i,x_ligand_i] * cos(angle)
		sum_y += ML[y_ligand_i,x_ligand_i] * sin(angle)
	end
	if(sum_x!=0)
		beta=acos(sum_y/sqrt(sum_x*sum_x+sum_y*sum_y))*sign(sum_y)
		sd=sqrt(-2*log(sqrt(sum_x*sum_x+sum_y*sum_y)/sum_norm_vect))
		chosen_angle=beta +randn()*sd #add this for randomness
	elseif(sum_y!=0)
		chosen_angle=pi/2*sign(sum_y)
	else
		chosen_angle= rand()*2*pi
	end
  return chosen_angle
end

#Persistent random walk
function anglePRW(prev_angle=-pi,variance=0.2)
	angle = prev_angle+randn()*variance
	return angle
end

#Persistent Biased Random walk
function anglePBRW(prev_angle,L,r,variance=0.25,omega=0.5,C=[0.5,0.5,0.5])
	return omega*angleBRW(L,C,r) + (1-omega)*anglePRW(prev_angle,variance)
end



#println(angleBRW())
