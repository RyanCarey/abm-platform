# Module to simulate cell growth
# Receives the array of alive cells, and based on some undecided criteria grows a subsection of them each time step
# Needs to check against neighbours for overlaps. Cells near other cells probably wouldn't grow.

# Decides when to split a cell into two.
function division_decision!(alive_cells::Array{Cell,1}, i::Int, x_size::Real, y_size::Real)
	cell = alive_cells[i]
	original_area = pi * categories[cell.cell_type].avg_r ^ 2
	current_area = pi * cell.r ^ 2

	if current_area / original_area > categories[cell.cell_type].div_thres
		# New Cell!
		cell_division(alive_cells, i, x_size, y_size)
	end

	return alive_cells
end
			

# Increases cell area by a certain random percentage of its types maximal growth rate.
# Will only grow if it will not overlap another cell, nor violate a boundary
# Note this randomness can be substituted for a value drawn from ligand concentration maybe,

function cell_growth!(alive_cells::Array{Cell,1}, i::Int,x_size::Real, y_size::Real)
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

function space_to_grow(cells::Array{Cell,1}, index::Int, radius::Real)
  n = length(cells)
    for i in 1:n
      if (cells[i].x - cells[index].x) ^ 2 + (cells[i].y - cells[index].y) ^ 2 < (cells[i].r + radius) ^ 2 && i != index
        return false
      end
    end
  return true
end
