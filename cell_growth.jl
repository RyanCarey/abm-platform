# Module to simulate cell growth
# Receives the array of alive cells, and based on some undecided criteria grows a subsection of them each time step
# Needs to check against neighbours for overlaps. Cells near other cells probably wouldn't grow.
include("cell_type.jl")

function growth_decision(alive_cells::Array, index::Int)
	cell = alive_cells[index]
	for i in 1 : length(alive_cells)
		if i != index
		   # Check to see if cells are nearby. Maybe use is_overlap with a 'fake' bigger radius?
		end
	end
end
			


function cell_growth(alive_cells::Array, growth_rate::Real)

  for i in 1 : length(alive_cells)
    #alive_cells[i].radius *= sqrt(1+growth_rate)
    area = alive_cells[i].r ^ 2 * pi
    area += (area * growth_rate)
    alive_cells[i].r = sqrt(area / pi)
  end

  return alive_cells

end
