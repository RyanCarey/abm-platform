# Module to generate new cells mid simulation, or kill cells
# Takes the initial location of a cell, angle of travel, a threshold for chance to generate a new cell [0;1], and cell radius
# Threshold 0.1 = 10% chance each time step
# Needs to know desired direction of parent cell
# Returns [Original Cell Location] and [New Cell Location]
# If a cell is dividing, it stops desiring to move
# If 2nd value is null, no new cell

include("cell_type.jl")
include("move.jl")

function life_or_death(alive_cells, dead_cells, index, divide_threshold, die_threshold)
	
	seed = rand()
	if seed > 1 - divide_threshold
		alive_cells = cell_division(alive_cells, index)
	elseif seed < die_threshold
		alive_cells, dead_cells = cell_death(alive_cells, dead_cells, index)
	end
	
	return alive_cells, dead_cells
end

function cell_division(cells, i)
	radius = cells[i].r		
	angle = 2 * pi * rand()		
	# New Cell!
	println("New Cell!")
	new_x = cells[i].loc.x - cos(angle) * 2 * radius
	new_y = cells[i].loc.y - sin(angle) * 2 * radius
	new_point = Point(new_x, new_y)
	in_empty_space = !(is_overlap(cells, new_point, radius))
	attempt = 0
	give_up = false
	while !in_empty_space || !(radius < new_x < X_SIZE - radius) || !(radius < new_y < Y_SIZE - radius)
		angle = 2 * pi * rand()
		new_x = cells[i].loc.x - cos(angle) * 2 * radius
		new_y = cells[i].loc.y - sin(angle) * 2 * radius
		in_empty_space = !(is_overlap(cells, new_point, radius))
		attempt += 1
		if attempt > 100
			println("Tried 100 times to place new cell, giving up!")
			give_up = true
			break
		end
	end
		
		if !give_up
			new_cell = Cell("$i.1", Point(new_x, new_y), radius, 1, 1, "Alive")
			push!(cells, new_cell)
		end

	return cells
end

function cell_death(alive_cells, dead_cells, i)
	
	# Dead Cell!
	println("Dead Cell!")
	dead_cell = splice!(alive_cells, i)
	dead_cell.state = "Dead"
	push!(dead_cells, dead_cell)
	return alive_cells, dead_cells
end
		
