# Module to simulate cell growth
# Receives the array of alive cells, and based on some undecided criteria grows a subsection of them each time step
# Needs to check against neighbours for overlaps. Cells near other cells probably wouldn't grow.


function cell_growth(alive_cells::Array, growth_rate::Real)

  for i in 1 : length(alive_cells)
    area = alive_cells[i].radius * 2 * pi
    area += (area * growth_rate)

    alive_cells[i].radius = (area / 2 * pi)
  end

  return alive_cells

end