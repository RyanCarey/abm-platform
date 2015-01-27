# Module to generate new cells mid simulation, or kill cells
# Takes the initial location of a cell, angle of travel, a threshold for chance to generate a new cell [0;1], and cell radius
# Threshold 0.1 = 10% chance each time step
# Needs to know desired direction of parent cell
# Returns [Original Cell Location] and [New Cell Location]
# If a cell is dividing, it stops desiring to move
# If 2nd value is null, no new cell

include("cell_type.jl")

function life_or_death(cells, index, divide_threshold, die_threshold)
	
	seed = rand()
	if seed > 1 - divide_threshold
		cells = cell_division(cells, index)
	elseif seed < die_threshold
		cells = cell_death(cells, index)
	end
	
	return cells
end

function cell_division(cells, i)
	radius = cells[i].r		
	angle = 2 * pi * rand()		
	# New Cell!
	println("New Cell!")
	new_cell = Cell("$i.1", Point(cells[i].loc.x - cos(angle) * radius, cells[i].loc.y - sin(angle) * radius), radius * .72, 1, 1, "Alive")
	cells[i].loc.x += (cos(angle) * radius)
	cells[i].loc.y += (sin(angle) * radius)
	push!(cells, new_cell)

	return cells
end

function cell_death(cells, i)
	
	# Dead Cell!
	println("Dead Cell!")
	cells[i].state = "Dead"
		
	return cells
end
		
