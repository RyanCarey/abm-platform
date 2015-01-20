# Biased Random Walk V2
# R is the coordinate (x,y,z) of the studied cell
# r is the radius of a cell
# ML is the matrix of ligand's concentration
# degree_precision is an integer and the numnber of ligants we are going to use to assess the favorite direction
# 
# 1-We first need to adapt the localization of the cell to the matrix. The cell will be spotted by the cooridnates (they can be float)
# whereas the matrix is located thaks to integer. We assume that the localisation of the cell matches with the coordinates of the matrix. 
# If R=(5.2,6.3) then the center of teh cell will be in the cell (6,7). We start to count the colums at 1 for the matrix. 
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
# var= var + ML[round(R[1] + cos(angle)*r)+1,round(R[2] + sin(angle)*r)+1]/maximum(ML)  *  min(abs(beta-angle),2*pi-abs(beta-angle))*min(abs(beta-angle),2*pi-abs(beta-angle))

function angleBRW2(ML=ones(500,500),R=[100,100,0.5],r=15,degree_precision=360)

for i in 1:500
	ML[:,i]=ML[:,i]+5*(i-1)*ones(500,1)
end


	sum_x=0
	sum_y=0
	sum_norm_vect=0

	for i in 1:degree_precision
		angle=i*2*pi/degree_precision

		#we add one to correct the fact that the matrix doesn't start at 0 and we correct the fact that matrix start from the top left
		x_ligand_i=size(ML,1) - (round(R[1] + cos(angle)*r)+1) 
		y_ligand_i=round(R[2] + sin(angle)*r)+1
		
		sum_norm_vect=sum_norm_vect + ML[x_ligand_i,y_ligand_i]
		
		sum_x=sum_x+ML[x_ligand_i,y_ligand_i]*cos(angle)
		sum_y=sum_y+ML[x_ligand_i,y_ligand_i]*sin(angle)
	end

	if(sum_x!=0)
		beta=acos(sum_y/sqrt(sum_x*sum_x+sum_y*sum_y))*sign(sum_y)
		println(beta)

		var=sqrt(-2*log(sqrt(sum_x*sum_x+sum_y*sum_y)/sum_norm_vect))
		println(var)
		choosen_angle=beta+(rand()-1/2)*var*var
	elseif(sum_y!=0)
		angle=pi/2*sign(sum_y)
	else
		angle=rand()*2*pi
	end
	
return choosen_angle
			
end

#Persitant random walk
function anglePRW(prev_angle=-pi,variance=0.25)
	angle = prev_angle+randn()*variance
	return angle
end

#Persistant Biased Random walk
function anglePBRW(prev_angle,variance=0.25,omega=0.5,L,R=[0.5,0.5,0.5],r)
	return omega*angleBRW(L,R,r) + (1-omega)*anglePRW(prev_angle,variance)
end



println(angleBRW2())
