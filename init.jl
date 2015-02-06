include("cell_type.jl")
include("ellipse.jl")
# Initialization Function
# 1st parameter: Number of cells
# 2nd parameter: Height of environment
# 3rd parameter: Width of environment
# 4th parameter: Radius of the cell
#
# This function return a 2D cells of random located cells within the squares borders. The cells have a radius and they do not overlap.
# We initilaize the first location of the cell and then for each new potential cell we look within the cells whether the cell is
# overlapping with another cell. If yes, we choose another random location for the cell
function init(n, r)
  x = X_SIZE
  y = Y_SIZE
  cells = Cell[]
  if(n >= 1)
    for i in 1:n
      placed = false
      fails = 0
      rvar = max(r/10,.00001) # Radius Variation
      ri = rand_radius(r, rvar)
      while !placed
        xi = ri + (x - 2 * ri) * rand()
        yi = ri + (y - 2 * ri) * rand()
        overlap = false
        if ELLIPTICAL_BORDER
          cell = Cell(string(i), Point(xi, yi), ri, 0, 0, "Alive", 0)
          if !in_ellipse(cell)
            overlap = true
          end
        end

        for j in 1:i-1
          if((xi - cells[j].loc.x) ^ 2 + (yi - cells[j].loc.y) ^ 2 < (ri + cells[j].r) ^ 2)
            overlap = true
          end
        end
        if overlap
          fails += 1
          if fails > 10000
            Messagebox(title="Warning", message=string("Could not place cell; try smaller radius or larger map"))
            return cells
          end
        else
          cell = Cell(string(i), Point(xi, yi), ri, 0, 0, "Alive", 0, "A")
          push!(cells, cell)
          placed = true
        end
      end
    end
  end
  return cells
end

function rand_radius(mean, stdev)
  radius = mean + (stdev * randn())
  # if radius is negative, try again
  if radius <= 0
    radius = rand_radius(mean, stdev)
  end
  return radius
end
