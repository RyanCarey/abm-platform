# Module to generate new cells mid simulation, or kill cells
# Takes the initialation of a cell, angle of travel, a threshold for chance to generate a new cell [0;1], and cell radius
# Threshold 0.1 = 10% chance each time step
# Needs to know desired direction of parent cell
# Returns [Original Cell Location] and [New Cell Location]
# If a cell is dividing, it stops desiring to move
# If 2nd value is null, no new cell

# Checks if cell in question will die at this iteration. Chance is defined by cell type.
function chance_to_die(alive_cells::Array{Cells, 1}, dead_cells::Array{Cells, 1}, index::Int)
	if rand() < categories[alive_cells[index].cell_type].death_rate
		alive_cells, dead_cells = cell_death(alive_cells, dead_cells, index)
		return alive_cells, dead_cells, true
	end
	return alive_cells, dead_cells, false
end

# Function to divide a cell. Will assign new radii and locations to both cells (original and new) and check that they don't overlap.
function cell_division(cells::Array{Cells, 1}, i::Int)
	radius = cells[i].r
	area = pi * radius ^ 2
	new_r = sqrt( (area / 2) / pi)
	angle = 2 * pi * rand()		

	new_x = cells[i].x - cos(angle) * 2 * new_r
	new_y = cells[i].y - sin(angle) * 2 * new_r
	new_point = Point(new_x, new_y)
	in_empty_space = !(is_overlap_divide(cells, new_point, new_r))

 	attempt = 0
	give_up = false
	while !in_empty_space || !(radius < new_x < X_SIZE - radius) || !(radius < new_y < Y_SIZE - radius)
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
		
		if !give_up
			offspring_name = "$(cells[i].name).$(cells[i].offspring + 1)"
			new_cell = Cell(offspring_name, new_x, new_y, new_r, 1, 1, 0, cells[i].cell_type)
			cells[i].r = new_r
			cells[i].offspring += 1
			if categories[cells[i].cell_type].stem_cell
				# Sum ligands
				sum_ligand = mean(list_ligand[:, 4])
				# If the cell has a surrounding concentration of below the threshold:
				# 30% of the time it will spawn a stem cell and a progenitor cell.
				# 70% of the time it will spawn a progenitor cell and become one itself.
				#
				# If the cell has a surrounding concentration above the threshold:
				# 30% of the time it will spawn a stem cell and a progenitor cell.
				# 70% of the time it will spawn 2 stem cells.
				thres = rand()
				if sum_ligand < categories[cells[i].cell_type].stem_threshold
					if thres > 0.85
						new_cell.cell_type = cells[i].cell_type + 1
					else
						new_cell.cell_type = cells[i].cell_type + 1
						cells[i].cell_type = cells[i].cell_type + 1
					end
				end
				if sum_ligand >= categories[cells[i].cell_type].stem_threshold
					if thres > 0.85
						new_cell.cell_type = cells[i].cell_type + 1
					end
				end
				
			end
			push!(cells, new_cell)
		end

	return cells
end

function kill_any(alive_cells::Array{Cells, 1}, dead_cells::Array{Cells, 1})
  i = rand(1:length(alive_cells))
  return cell_death(alive_cells, dead_cells, i)
end


function cell_death(alive_cells::Array{Cells, 1}, dead_cells::Array{Cells, 1}, i::Int)
	# Dead Cell!
	#println("Dead Cell!")
	dead_cell = splice!(alive_cells, i)
	#dead_cell.state = "Dead"
	push!(dead_cells, dead_cell)
	return alive_cells, dead_cells
end
		
