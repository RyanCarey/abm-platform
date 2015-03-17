function angle_from_ligand(cell::Cell, categories::Vector{Cell_type}, k::Int, x_size::Real, 
                           y_size::Real, time::Real, concentrations::Vector{Float64})
	# this is the biased contribution to the angle
	#We are going to calculate dependiong on some threshold the angle the cell has to choose
	#Array initialization
        receptors=Array(Float64,int(nb_ligands),3)#angle,x and y ordinate of the cell receptors
	concentrations=Array(Array(Float64,int(nb_ligands)))#concnetration of ligand at the ordinate defined by receptors
	for i in 1:nb_ligands    # number of receptors on cell
	  angle=(i-1)*2*pi/nb_ligands
	  receptors[i,1] = angle
	  receptors[i,2] = cell.x+cos(angle)*cell.r
	  receptors[i,3] = cell.y+sin(angle)*cell.r
	  if type_source=="Point" 
      	    concentrations[i] = ligand_concentration_multiplesource_2D(receptors[i,2],receptors[i,3], time)
	    concentration_threshold=ligand_concentration_multiplesource_2D(x_size/2,y_size/2,0, time)
	  elseif type_source=="Line"
      	    concentrations[i] = ligand_concentration_multiplesource_1D(receptors[i,2], time)
	  end
	end
	#concentration ratio we use to know whether the cell are moving according 
	ratio = maximum(concentrations) / mean(concentrations)
	#Threshold to know whether the cell is in the niche or not.
	concentration_threshold = categories[cell.cell_type].stem_threshold
  	# If the largest concentration of ligand is less than the threshold or the ratio of max / mean is less that 1.1, choose a random angle.
  	# Else move towards the source perfectly.
	if maximum(concentrations) < concentration_threshold || ratio < categories[cell.cell_type].threshold_ratio_concentration
	  chosen_angle = randn() * pi
	else
	  chosen_angle = receptors[indmax(concentrations), 1]
	end
	# Multiple the chosen angle by the cell type defined concentration response.
  	ligand_angle = chosen_angle * categories[cell.cell_type].conc_response
	return ligand_angle, concentrations
end

##########################################################################################################
function angle_from_both(cell::Cell, categories::Vector{Cell_type}, randomness::Real, x_size::Real, y_size::Real, time::Real)
  concentrations = Array(Float64,int(nb_ligands)) # this should be brought out of angle into move
  # proposes a direction for the cell to travel, taking the ligand, previous motion and random chance into account
	if rand() < categories[cell.cell_type].persistence && time > 1
		angle = mod2pi(cell.angle)
	else
    ligand_angle, concentrations = angle_from_ligand(cell, categories, 1, x_size, y_size, time, concentrations)
		angle = mod2pi((1-randomness)* ligand_angle + randomness * rand() * 2pi)
	end
	return angle, concentrations
end

##########################################################################################################
function get_concentrations(type_source, nb_ligands, x_size, y_size, time)
  return concentrations
end


