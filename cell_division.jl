# Module to generate new cells mid simulation, or kill cells
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
			
		end
	end
	return cells
end

function cell_death(cells, threshold)

	for i = size(cells)
		seed = rand()
		if seed < threshold
			# Dead Cell!
			println("Dead Cell!")
			pop!(cells, i)
		end
	end
	return cells
end
		