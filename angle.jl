using Winston
using Distributions

include("diffusion.jl")

# Proposed angle of direction for the cell
#
# t : time_step
# nb_ligands : number of ligands around the cell ie the number of possible directions
# cell : data from the cell we want to assess the next angle

#Ze still need to correct the possible borders porblems: the min works for rectangle only!!!!!!!!!!!!!!!
function angle_from_ligand(time,cell)
 	x = cell.loc.x
  	y = cell.loc.y
  	r = cell.r
	#println(x," ",y)
	#println(nb_ligands)
  	list_ligand=Array(Float64,int(nb_ligands),5) #angle,x,y,ligand concentration in (x,y), cumulative distribution probability

	for i in 1:nb_ligands
		angle=(i-1)*2*pi/nb_ligands

		list_ligand[i,1] = angle
		list_ligand[i,2] = x+cos(angle)*r#min(Y_SIZE-(floor(y + sin(angle)*r)),Y_SIZE)
		list_ligand[i,3] = y+sin(angle)*r#min(floor(x + cos(angle)*r) + 1,X_SIZE)
		list_ligand[i,4] = ligand_concentration_onesource(list_ligand[i,2])
		if(i==1)
			list_ligand[i,5]=list_ligand[i,4]
		else
			list_ligand[i,5]=list_ligand[i-1,5]+list_ligand[i,4]
		end
	end
	#Cumulative ligand concentration probability
	#0<list_ligand(1,5)<list_ligand(2,5)<...<list_ligand(last,5)=1	
	if(maximum(list_ligand[:,5]!=0))
		list_ligand[:,5] = list_ligand[:,5]./maximum(list_ligand[:,5])
	end
	#println(list_ligand)
	#Method 1: we choose the angle which has the maximum concentration
	choosen_angle_1=list_ligand[indmax(list_ligand[:,4]),1]

	#Method 2: we chose the angle thanks to a uniform distribution
	#and the cumulative probability of the ligand concentration:
	#We need to round to the rand() to the ceil of an element of list_ligand(:,5)
	choosen_angle_2=list_ligand[findfirst(list_ligand[:,5].>rand()),1]
	#println(choosen_angle_1)
  	return choosen_angle_2
end

#Persistent random walk
function angle_persistent(cell,sd=0)
	angle = cell.angle+randn()*sd
	return angle
end


#Combination of the two methods
#probability is the probability of choosing the angle from the persistent random walk over the direction fro; the ligand
function angle_from_both(cell::Cell,probability_persistent=0.5)
	if(rand()<probability_persistent)
		angle=anglePRW(cell)
	else
		angle=angle_from_ligand(time,cell,nb_ligands)
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
