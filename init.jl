#include("cell_type.jl")
#include("ellipse.jl")
# Initialization Function
# 1st parameter: Number of cells
# 2nd parameter: Height of environment
# 3rd parameter: Width of environment
# 4th parameter: Radius of the cell
#
# This function return a 2D cells of randomated cells within the squares borders. The cells have a radius and they do not overlap.
# We initilaize the firstation of the cell and then for each new potential cell we look within the cells whether the cell is
# overlapping with another cell. If yes, we choose another randomation for the cell

# Below variables need to be specified in the GUI eventually!!

function init(n::Real, categories::Array, x_size::Real, y_size::Real)
  freqs = n * [categories[1].amount, categories[2].amount, categories[3].amount, categories[4].amount]
  cumul_freqs = round(float([sum(freqs[1:i]) for i in 1:length(freqs)]))
  cells = Cell[]

  if(n < 1)
    Messagebox(title="Error", message=string("No cells placed, increase the number of cells"))
    return
  end
  for i in 1:n
    cell_cat = 1
    # assign cell category
    for j in 1:length(cumul_freqs)
      if i <= cumul_freqs[j]
        cell_cat = j
        break
      end
    end
    placed = false
    fails = 0
    r = categories[cell_cat].avg_r
    rvar = r/10 # Radius Variation
    ri = max(rand_radius(r, rvar),.00001)
    while !placed
      xi = categories[cell_cat].left_placed ? ri + .001 : ri + (x_size - 2ri) * rand()
      yi = ri + (y_size - 2ri) * rand()
      overlap = false
      for j in 1:i-1
        if((xi - cells[j].x) ^ 2 + (yi - cells[j].y) ^ 2 < (ri + cells[j].r) ^ 2)
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
        cell = Cell(string(i), xi, yi, ri, 0, 0, 0, cell_cat)
        push!(cells, cell)
        placed = true
      end
    end
  end
  println("Initialised")
  return cells::Array
end

function rand_radius(mean::Real, stdev::Real)
  radius = mean + (stdev * randn())
  # if radius is negative, try again
  if radius <= 0
    radius = rand_radius(mean, stdev)
  end
  return radius
end
