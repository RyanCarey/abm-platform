# Module to simulate cell growth
# Receives the array of alive cells, and based on some undecided criteria grows a subsection of them each time step
# Needs to check against neighbours for overlaps. Cells near other cells probably wouldn't grow.
include("cell_type.jl")
include("move.jl")
include("birth_and_death.jl")

# Need 2 global variables implemented:
# AVG_RADIUS - The radius that all cells are created around
# GROWTH_RATE - A specified maximal growth rate

global AVG_RADIUS = 1
global GROWTH_RATE = 0.1

# Decides when to split a cell into two.
function growth_decision!(alive_cells::Array, i::Int)
	cell = alive_cells[i]
	original_area = pi * AVG_RADIUS ^ 2
	current_area = pi * cell.r ^ 2

	if current_area / original_area > 1.75
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
    area *= (1 + (GROWTH_RATE * rand()))
    p_new_r = sqrt(area / pi)

    if (!is_overlap(alive_cells, i, cell.loc, p_new_r)) && (p_new_r < cell.loc.x < X_SIZE - p_new_r) && (p_new_r < cell.loc.y < Y_SIZE - p_new_r)
    	# Cell has space to grow
    	# println("Growing Cell")
    	cell.r = sqrt(area / pi)
    end
    # Else, cell doesn't grow.
	return alive_cells
end