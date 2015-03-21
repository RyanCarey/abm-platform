function get_concentrations(cell::Cell, time::Real, diffusion_coefficient::Vector{Float64}, A_coefficient::Vector{Float64},
                            x_size::Float64)
	#Array initialization
  receptors=Array(Float64,int(n_receptors),3) #angle,x and y ordinate of the cell receptors
	receptor_angles=Array(Float64,int(n_receptors)) #angles of the receptors from the cell centre
	concentrations=Array(Float64,int(n_receptors)) #concentration of ligand at the ordinate defined by receptors
	for i in 1:n_receptors    # number of receptors on cell
	  angle=(i-1)*2*pi/n_receptors
    receptor_angles[i] = angle
	  receptors[i,1] = cell.x+cos(angle)*cell.r
	  receptors[i,2] = cell.y+sin(angle)*cell.r
	  if type_source=="Point" 
      concentrations[i] = conc_multisource_2D(receptors[i,1],receptors[i,2], time, diffusion_coefficient, A_coefficient)
	  elseif type_source=="Triangle"
      concentrations[i] = x_size - receptors[i,1]
	  elseif type_source=="Line"
      concentrations[i] = conc_multisource_1D(receptors[i,1], time, diffusion_coefficient, A_coefficient)
	  end
	end
  println("conc,receptor: ",[(concentrations[i],receptor_angles[i], receptors[i,1], receptors[i,2]) for i in 1:length(concentrations)])
  return concentrations, receptor_angles
end


function angle_from_ligand(cell::Cell, categories::Vector{Cell_type}, k::Int, x_size::Real, 
                           y_size::Real, time::Real, concentrations::Vector{Float64}, receptor_angles::Vector{Float64})

  # whether the concentration has an impact depends on the ratio and the absolute amount
	ratio = maximum(concentrations) / mean(concentrations)
  ratio_threshold = categories[cell.cell_type].threshold_ratio_concentration
	conc_threshold = categories[cell.cell_type].conc_threshold

	if maximum(concentrations) < conc_threshold || ratio < ratio_threshold
	  chosen_angle = randn() * pi
	else
    indices = 
	  chosen_angle = receptor_angles[any_indmax(concentrations), 1]
	end
	# Multiple the chosen angle by the cell type defined concentration response.
  	ligand_angle = chosen_angle + pi * (categories[cell.cell_type].conc_response < 0)
	return ligand_angle
end


function angle_from_both(cell::Cell, categories::Vector{Cell_type}, randomness::Real, x_size::Real, y_size::Real, 
                         time::Real, concentrations::Vector{Float64}, receptor_angles::Vector{Float64})
  # proposes a direction for the cell to travel, taking the ligand, previous motion and random chance into account
  # we should put this in as weighted rather than sampled
	if rand() < categories[cell.cell_type].persistence && time > 1
		angle = mod2pi(cell.angle)
	else
    ligand_angle = angle_from_ligand(cell, categories, 1, x_size, y_size, time, concentrations, receptor_angles)
    println("ligand angle: ", ligand_angle)
    angle = mod2pi(wt_sum_angles(2pi*rand(), ligand_angle, randomness))
		#angle = mod2pi((1-randomness)* ligand_angle + randomness * rand() * 2pi)
	end
  println("angle: ",angle)
	return angle
end


function wt_sum_angles(alpha::Float64,beta::Float64, w::Float64)
  vec_sum = wt_sum_vecs(angle_to_vec(alpha),angle_to_vec(beta),w)
  return vec_to_angle(vec_sum)
end

function angle_to_vec(theta::Float64)
  return [cos(theta);sin(theta)]
end

function vec_to_angle(A::Vector{Float64})
  if A[1] > 0
    return atan(A[2]/A[1])
  else
    return pi + atan(A[2]/A[1])
  end
end

function wt_sum_vecs(A::Vector{Float64},B::Vector{Float64},w::Float64)
  return w.*A .+ (1-w).*B
end


function any_indmax(list)
  # gets the index of a maximal element, selecting randomly between all maxima
  maximal_indices = [1:length(list)][list.==maximum(list)]
  random_indmax = maximal_indices[rand(1:length(maximal_indices))]
  return random_indmax
end


