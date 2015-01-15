# L is a 3 columns array of all the position of the ligands (large list)
# R is the coordinate (x,y,z) of the studied cell
# r is the radius of a cell
#
# The receptors move with the angle alpha which follows a Biased Random Walk
# ie. alpha ~ N(beta,bias)
# The concentration of the ligand and the receptor respect the following equation
# k1 is the speed of the reaction R+L -> RL
# k2 is the speed of the reaction RL -> R+L
# [RL] = k1[R][L] - k2[RL]
# ie [RL] = k1/(k2 +1) * [R][L]
# We admit that beta is equal to delta[RL]
# ie beta ~ k1/(k2+1)([R]delta[L] + [L]delta[R])
# We assume that we only have to look at the concentration of the ligands around the membrane cell
# and that we do not need to look at the concentration of the receptor (insignificant)
#
# First we reduce the size of the list of ligands by keeping only those are close to the cell center.
# Then we are going to look all over the membrane of the cell for ligand concentration 
# The bias will be proportional in each direction to the differentiate of the ligand concentration

function angleBRW(L,R=[0.5,0.5,0.5],r)
	list=Array(Float64)	
	for i in 1:size(L,1)
		dx=L[i,1]-R[1]
		dy=L[i,2]-R[2]
		if (sqrt(dx*dx+dy*dy)<1.1*r && sqrt(dx*dx+dy*dy)>0.9*r) 
			alpha=acos(dx/sqrt(dx*dx+dy*dy))*sign(dy)
			list=[list;alpha]
		end
	end
	if(length(list)>1)
		beta=mean(list[2:end])
		bias=std(list[2:end])
		angle=beta+rand()*(bias*bias)
	else 
		angle=rand()*2*pi
	end
	
return angle
			
end
