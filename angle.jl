function get_concentrations(cell::Cell, time::Real)
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
      concentrations[i] = ligand_concentration_multiplesource_2D(receptors[i,1],receptors[i,2], time)
	  elseif type_source=="Line"
      concentrations[i] = ligand_concentration_multiplesource_1D(receptors[i,1], time)
	  end
	end
  return concentrations, receptor_angles
end

function angle_from_ligand(cell::Cell, categories::Vector{Cell_type}, k::Int, x_size::Real, 
                           y_size::Real, time::Real, concentrations::Vector{Float64}, receptor_angles::Vector{Float64})

  # whether the concentration has an impact depends on the ratio and the absolute amount
	ratio = maximum(concentrations) / mean(concentrations)
  ratio_threshold = categories[cell.cell_type].threshold_ratio_concentration
	concentration_threshold = categories[cell.cell_type].stem_threshold

	if maximum(concentrations) < concentration_threshold || ratio < ratio_threshold
	  chosen_angle = randn() * pi
	else
	  chosen_angle = receptor_angles[indmax(concentrations), 1]
	end
	# Multiple the chosen angle by the cell type defined concentration response.
  	ligand_angle = chosen_angle + pi * (categories[cell.cell_type].conc_response < 0)
	return ligand_angle
end

##########################################################################################################
function angle_from_both(cell::Cell, categories::Vector{Cell_type}, randomness::Real, x_size::Real, y_size::Real, 
                         time::Real, concentrations::Vector{Float64}, receptor_angles::Vector{Float64})
  # proposes a direction for the cell to travel, taking the ligand, previous motion and random chance into account
	if rand() < categories[cell.cell_type].persistence && time > 1
		angle = mod2pi(cell.angle)
	else
    ligand_angle = angle_from_ligand(cell, categories, 1, x_size, y_size, time, concentrations, receptor_angles)
		angle = mod2pi((1-randomness)* ligand_angle + randomness * rand() * 2pi)
	end
	return angle
end

