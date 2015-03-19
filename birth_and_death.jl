# Module for growth, mitosis and death
# Takes the initialation of a cell, angle of travel, a threshold for chance to generate a new cell [0;1], and cell radius
# Threshold 0.1 = 10% chance each time step
# Needs to know desired direction of parent cell
# Returns [Original Cell Location] and [New Cell Location]
# If a cell is dividing, it stops desiring to move
# If 2nd value is null, no new cell

# Checks if cell in question will die at this iteration. Chance is defined by cell type.
function chance_to_die(alive_cells::Vector{Cell}, dead_cells::Vector{Cell}, categories::Vector{Cell_type}, 
                       index::Int)
	if rand() < categories[alive_cells[index].cell_type].death_rate
		alive_cells, dead_cells = cell_death(alive_cells, dead_cells, index)
		return alive_cells, dead_cells, true
	end
	return alive_cells, dead_cells, false
end

# Function to divide a cell. Will assign new radii and locations to both cells (original and new) and check that they don't overlap.
function cell_divide(cells::Vector{Cell}, categories::Vector{Cell_type}, i::Int, x_size::Real, y_size::Real, concentrations::Vector{Float64})
	radius = cells[i].r
	area = pi * radius ^ 2
	# Calculate radius if area was half, and a random angle.
	new_r = sqrt( (area / 2) / pi)
	angle = 2 * pi * rand()		

	# Calculate a new location based on the new radius and random angle. Use this to check the environment for overlaps.
	new_x = cells[i].x - cos(angle) * 2 * new_r
	new_y = cells[i].y - sin(angle) * 2 * new_r
	new_point = Point(new_x, new_y)
	in_empty_space = !(is_overlap_divide(cells, new_point, new_r))

 	attempt = 0
	give_up = false
	# While this new cell overlaps or is placed outside the environment, calculate a new random location.
	while !in_empty_space || !(radius < new_x < x_size - radius) || !(radius < new_y < y_size - radius)
		angle = 2 * pi * rand()
		new_x = cells[i].x - cos(angle) * 2 * new_r
		new_y = cells[i].y - sin(angle) * 2 * new_r
		temp_r = cells[i].r
		cells[i].r = new_r
		in_empty_space = !(is_overlap_divide(cells, Point(new_x, new_y), new_r))
    
    	attempt += 1
		if attempt > 100
			println("Tried 100 times to place new cell, giving up!")
			cells[i].r = temp_r
			give_up = true
			break
		end
	end
	
	# If the cell is able to be successfully placed, create a new cell of the same type and reduce parent cell area accordingly.
		if !give_up
			offspring_name = "$(cells[i].name).$(cells[i].offspring + 1)"
			new_cell = Cell(offspring_name, new_x, new_y, new_r, 1, 1, 0, cells[i].cell_type)
			cells[i].r = new_r
			cells[i].offspring += 1

			# If the cell type is a stem cell, use the stem threshold for the type to calculate the type of the offspring cell.
			if categories[cells[i].cell_type].stem_cell
				# Sum ligands
				sum_ligand = mean(concentrations)
				# If the cell has a surrounding concentration of below the threshold:
				# 30% of the time it will spawn a stem cell and a progenitor cell.
				# 70% of the time it will spawn a progenitor cell and become one itself.
				#
				# If the cell has a surrounding concentration above the threshold:
				# 30% of the time it will spawn a stem cell and a progenitor cell.
				# 70% of the time it will spawn 2 stem cells.
				if sum_ligand < categories[cells[i].cell_type].conc_threshold
					if rand() > 0.85
						new_cell.cell_type = cells[i].cell_type + 1
					else
						new_cell.cell_type = cells[i].cell_type + 1
						cells[i].cell_type = cells[i].cell_type + 1
					end
				end
				if sum_ligand >= categories[cells[i].cell_type].conc_threshold
					if rand() > 0.85
						new_cell.cell_type = cells[i].cell_type + 1
					end
				end
			end
			push!(cells, new_cell)
		end

	return cells
end

# Function to randomly kill 1 cell in the simulation.
function kill_any(alive_cells::Vector{Cell}, dead_cells::Vector{Cell})
  i = rand(1:length(alive_cells))
  return cell_death(alive_cells, dead_cells, i)
end

# Function to remove specified cell from the simulation.
function cell_death(alive_cells::Vector{Cell}, dead_cells::Vector{Cell}, i::Int)
	# Dead Cell!
	#println("Dead Cell!")
	dead_cell = splice!(alive_cells, i)
	#dead_cell.state = "Dead"
	push!(dead_cells, dead_cell)
	return alive_cells, dead_cells
end

# Function to determine whether a cell has grown enough to divide.
function division_decision!(alive_cells::Vector{Cell}, categories::Vector{Cell_type}, i::Int, 
                            x_size::Real, y_size::Real, concentrations::Vector{Float64})
  	cell = alive_cells[i]
	original_area = pi * categories[cell.cell_type].avg_r ^ 2
	current_area = pi * cell.r ^ 2

	if current_area / original_area > categories[cell.cell_type].div_thres
		# New Cell!
		cell_divide(alive_cells, categories, i, x_size, y_size, concentrations)
	end

	return alive_cells
end
			

function cell_growth!(alive_cells::Vector{Cell}, categories::Vector{Cell_type}, i::Int,x_size::Real, y_size::Real)
  # Increases cell area by a random percentage of the growth rate for that type.
  # Will only grow if it will not overlap another cell, nor violate a boundary
    cell = alive_cells[i]    
    area = pi * cell.r ^ 2
    area *= (1 + (categories[cell.cell_type].growth_rate * rand()))
    p_new_r = sqrt(area / pi)

    if (space_to_grow(alive_cells, i, p_new_r)) && (p_new_r < cell.x < x_size - p_new_r) && (p_new_r < cell.y < y_size - p_new_r)
    	# Cell has space to grow
    	#println("Growing Cell")
    	cell.r = sqrt(area / pi)
    end
    # Else, cell doesn't grow.
	return alive_cells
end

# Function to check whether a growing cell is able to grow without overlapping other cells in the simulation.
function space_to_grow(cells::Vector{Cell}, index::Int, radius::Real)
  n = length(cells)
    for i in 1:n
      if (cells[i].x - cells[index].x) ^ 2 + (cells[i].y - cells[index].y) ^ 2 < (cells[i].r + radius) ^ 2 && i != index
        return false
      end
    end
  return true
end
