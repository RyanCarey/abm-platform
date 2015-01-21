# Module to generate new cells mid simulation
# Takes the initial location of a cell, angle of travel, a threshold for chance to generate a new cell [0;1], and cell radius
# Threshold 0.1 = 10% chance each time step
# Needs to know desired direction of parent cell
# Returns [Original Cell Location] and [New Cell Location]
# If a cell is dividing, it stops desiring to move
# If 2nd value is null, no new cell


function cell_division(cells, threshold)

	for i = size(cells)
		radius = cells[i; 3]
		seed = rand()
		angle = 2*pi*rand()
		if seed < threshold
			# New Cell!
			println("New Cell!")
			new = cells[i; 1:2] - [(cos(angle) * radius) (sin(angle) * radius)]
			cells[i; 1:2] += [(cos(angle) * radius) (sin(angle) * radius)]

			new_radius = (radius * .72)
			cells[i; 3] = new_radius
			push!(cells, [new[1], new[2], new_radius])
			return cells
		end
	end
end
		
