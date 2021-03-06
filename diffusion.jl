#There two cases for diffusion: the case when sources are points and when sources are line
#We have used the notation 1D for line and 2D for points
#For each cases the concnetration will depend on the type of diffusion chosen by the user
##########################################################################################################
function conc_multisource_2D(x_ord::Float64,y_ord::Float64,time::Float64,
                                                diffusion_coefficient::Vector{Float64}, A_coefficient::Vector{Float64})
#The point case: If there is more than one source, we are going to calculate the contribution for each source
#at the precse ligand receptor and we are going to linearly sum their concentration. This is possible because the diffusion
#equation deriving from the Fick's laws is linear
#Here we need both the x and the y ordinate of the ligand receptor
	res=0
	for source_index in 1:nb_source
    println("res before: ", res)
    if type_diffusion=="Sustained"
      D = integration_diffusion_coefficient[source_index]
      distance_source_squared = (abs(source_x_ord[source_index]-x_ord)+abs(source_y_ord[source_index]-y_ord))^2
      max = diffusion_maximum[source_index]
      (contribution,tmp)=quadgk(tau -> integrand(tau, time, distance_source_squared, D),
                     0,min(time,tau0[source_index]))
    elseif type_diffusion=="Instantaneous"
      D = diffusion_coefficient[source_index]
      max = diffusion_maximum[source_index]
      contribution = conc_onesource_2D(x_ord, y_ord, time, source_index, D, max)
    end
    res += contribution
    println("res after: ", res)
	end
	return res
end

function conc_onesource_2D(x_ord::Float64,y_ord::Float64, time::Float64, source_index::Int, D::Float64, max::Float64)
  #Contribution from one source
  distance_source_squared = (abs(source_x_ord[source_index] - x_ord)
                                   + abs(source_y_ord[source_index]-y_ord))^2
  res=(max/sqrt(D*time*4*pi) * exp(-distance_source_squared/sqrt(D*time*4)))
  return res
end

##########################################################################################################
function conc_multisource_1D(x_ord::Float64,time::Float64, diffusion_coefficient::Vector{Float64},
                                         A_coefficients::Vector{Float64})
#The line case: If there is more than one source, we are going to calculate the contribution for each source
#at the precse ligand receptor and we are going to linearly sum their concentration. This is possible because the diffusion
#equation deriving from the Fick's laws is linear
#Here we need only the x ordinate of the ligand receptor because the line is vertical

	res=0
	for source_index in 1:nb_source
    if type_diffusion=="Sustained"
      D = integration_diffusion_coefficient[source_index]
      A = A_coefficients[source_index]
      distance_source_squared = (source_x_ord[source_index] - x_ord)^2
      (contribution,tmp)=quadgk(tau -> integrand(tau, time, distance_source_squared, D),
                     0,min(time,tau0[source_index]))
      contribution *= A / sqrt(4*D*time*pi)
    elseif type_diffusion=="Instantaneous"
      D = diffusion_coefficient[source_index]
      contribution=diffusion_maximum[source_index]/sqrt(D*time*4*pi) * 
          exp(-(source_x_ord[source_index]-x_ord)^2/D*time*4)
    end
		res += contribution
	end
	return res
end

function conc_triangle(x_ord::Float64)
  # concentration is equal to the x-ordinate
	return x_ord
end

##########################################################################################################
function integrand(tau::Float64, time::Float64, distance_source_squared::Float64, D::Float64)
  #function to integrate when running the diffusion
  result = exp(-distance_source_squared/(4*D*(time-tau)))
	return result
end

