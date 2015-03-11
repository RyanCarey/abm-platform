function ligand_concentration_onesource_2D(abscisse_ligand::Float64,ordinate_ligand::Float64, time::Real)
  global distance_source_squared = (abs(source_abscisse_ligand[number_source] - abscisse_ligand)
                                   + abs(source_ordinate_ligand[number_source]-ordinate_ligand))^2
  if type_diffusion=="Integrative"
    (res,tmp)=quadgk(integrand,0,min(time,tau0[number_source]))
  else
    res=(diffusion_maximum[number_source]/sqrt(diffusion_coefficient[number_source]*time*4*pi)
        *exp(-distance_source_squared/(diffusion_coefficient[number_source]*time*4)))
  end
  return res
end

function ligand_concentration_multiplesource_2D(abscisse_ligand::Float64,ordinate_ligand::Float64,time::Real)
	res=0
	for i in 1:nb_source
		global number_source=i
		res = res + ligand_concentration_onesource_2D(abscisse_ligand,ordinate_ligand,time)
	end
	return res
end

function ligand_concentration_multiplesource_1D(abscisse_ligand::Float64,time::Real)
	res=0
	for i in 1:nb_source
		global number_source=i
		res = res + ligand_concentration_onesource_1D(abscisse_ligand,time)
	end
	return res
end

function ligand_concentration_onesource_1D(abscisse_ligand::Float64,time::Real)
    if type_diffusion=="Integrative"
      global distance_source_squared = (source_abscisse_ligand[number_source] - abscisse_ligand)^2

      (res,tmp)=quadgk(tau -> integrand(tau, time),0,min(time,tau0[number_source]))
    else
      res=(diffusion_maximum[number_source]/sqrt(diffusion_coefficient[number_source]*time*4*pi)
          *exp(-(source_abscisse_ligand[number_source]-abscisse_ligand)^2/(diffusion_coefficient[number_source]*time*4)))
    end
    return res
end

function integrand(tau::Float64, time::Real)
  #function to integrate when running the diffusion
	result = (A_coefficient[number_source]*exp(-distance_source_squared/(4*Diffusion_coefficient[number_source] *
           (time-tau)))/(4*Diffusion_coefficient[number_source]*time*pi))
	return result
end

