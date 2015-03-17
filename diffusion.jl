#There two cases for diffusion: the case when sources are points and when sources are line
#We have used the notation 1D for line and 2D for points
#For each cases the concnetration will depend on the type of diffusion chosen by the user
##########################################################################################################
function ligand_concentration_multiplesource_2D(abscisse_ligand::Float64,ordinate_ligand::Float64,time::Real)
#The point case: If there is more than one source, we are going to calculate the contribution for each source
#at the precse ligand receptor and we are going to linearly sum their concentration. This is possible because the diffusion
#equation deriving from the Fick's laws is linear
#Here we need both the x and the y ordinate of the ligand receptor
	res=0
	for i in 1:nb_source
		global number_source=i
		res = res + ligand_concentration_onesource_2D(abscisse_ligand,ordinate_ligand)
	end
	return res
end
#Contribution from one source
function ligand_concentration_onesource_2D(abscisse_ligand::Float64,ordinate_ligand::Float64, time::Real)
  global distance_source_squared = (abs(source_abscisse_ligand[number_source] - abscisse_ligand)
                                   + abs(source_ordinate_ligand[number_source]-ordinate_ligand))^2
  if type_diffusion=="Integrative"
    res=(diffusion_maximum[number_source]/sqrt(diffusion_coefficient[number_source]*time*4*pi)
        * exp(-distance_source_squared/sqrt(diffusion_coefficient[number_source]*time*4)))
  elseif type_diffusion=="Normal"
    res=(diffusion_maximum[number_source]/sqrt(diffusion_coefficient[number_source]*time*4*pi)
        *exp(-distance_source_squared/(diffusion_coefficient[number_source]*time*4)))
  end
  return res
end
##########################################################################################################
function ligand_concentration_multiplesource_1D(abscisse_ligand::Float64,time::Real)
#The line case: If there is more than one source, we are going to calculate the contribution for each source
#at the precse ligand receptor and we are going to linearly sum their concentration. This is possible because the diffusion
#equation deriving from the Fick's laws is linear
#Here we need only the x ordinate of the ligand receptor because the line is vertical
	res=0
	for i in 1:nb_source
		global number_source=i
		res = res + ligand_concentration_onesource_1D(abscisse_ligand, time)
	end
	return res
end
#Contribution from one source
function ligand_concentration_onesource_1D(abscisse_ligand::Float64,time::Real)
    if type_diffusion=="Integrative"
      global distance_source_squared = (source_abscisse_ligand[number_source] - abscisse_ligand)^2

      (res,tmp)=quadgk(tau -> integrand(tau, time),0,min(time,tau0[number_source]))
    elseif type_diffusion=="Normal"
      res=diffusion_maximum[number_source]/sqrt(diffusion_coefficient[number_source]*time*4*pi) * 
            exp(-(source_abscisse_ligand[number_source]-abscisse_ligand)^2/sqrt(diffusion_coefficient[number_source]*time*4))
    end
    return res
end

##########################################################################################################
function integrand(tau::Float64, time::Real)
#function to integrate when running the diffusion
#As we are using quadgk, the function can have only one parameter as an argument, 
#this is why we have put all the diffusion coefficient as global
	result = (A_coefficient[number_source]*exp(-distance_source_squared/(4*Diffusion_coefficient[number_source] *
           (time-tau)))/(4*Diffusion_coefficient[number_source]*time*pi))
	return result
end

