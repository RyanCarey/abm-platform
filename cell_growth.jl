# Module to simulate cell growth
# Receives the array of alive cells, and based on some undecided criteria grows a subsection of them each time step
# Needs to check against neighbours for overlaps. Cells near other cells probably wouldn't grow.
include("cell_type.jl")
include("move.jl")
include("birth_and_death.jl")

# Need 2 global variables implemented:
# avg_radius - The radius that all cells are created around
# growth_rate - A specified maximal growth rate


# Decides when to split a cell into two.
#=function growth_decision!(alive_cells::Array, i::Int, avg_radius::Real)
	cell = alive_cells[i]
	original_area = pi * avg_radius ^ 2
	current_area = pi * cell.r ^ 2

	if current_area / original_area > 1.75
		# New Cell!
		cell_division(alive_cells, i, avg_radius)
	end

	return alive_cells
end=#
			
# Decides when to split a cell into two.
function division_decision!(alive_cells::Array, i::Int, avg_radius::Real)
	cell = alive_cells[i]
	original_area = pi * avg_radius ^ 2
	current_area = pi * cell.r ^ 2

	if current_area / original_area > categories[cell.cell_type].div_thres
		# New Cell!
		cell_division(alive_cells, i)
	end

	return alive_cells
end
			

# Increases cell area by a certain random percentage of a defined maximal growth rate.
# Will only grow if it will not overlap another cell, nor violate a boundary
# Note this randomness can be substituted for a value drawn from ligand concentration maybe,

function cell_growth!(alive_cells::Array, i::Int)
	
    cell = alive_cells[i]    

    area = pi * cell.r ^ 2
    area *= (1 + (categories[cell.cell_type].growth_rate * rand()))
    println("Cell Type: ", cell.cell_type)
    println("Growth Rate: ", categories[cell.cell_type].growth_rate)
    p_new_r = sqrt(area / pi)


    if (space_to_grow(alive_cells, i, p_new_r)) && (p_new_r < cell.loc.x < X_SIZE - p_new_r) && (p_new_r < cell.loc.y < Y_SIZE - p_new_r)
    	# Cell has space to grow
    	#println("Growing Cell")
    	cell.r = sqrt(area / pi)
    end
    # Else, cell doesn't grow.
	return alive_cells
end

function space_to_grow(cells::Array, index::Int, radius::Real)
  n = length(cells)
    for i in 1:n
      if (cells[i].loc.x - cells[index].loc.x) ^ 2 + (cells[i].loc.y - cells[index].loc.y) ^ 2 < (cells[i].r + radius) ^ 2 && i != index
        return false
      end
    end
  return true
end