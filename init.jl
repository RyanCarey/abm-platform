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

# Below variables need to be specified in the GUI eventually!!


categories = [Category(1,"r",1,1,1,1,true,true,true),
              Category(1,"b",1,1,1,1,false,false,false)]

function init(n, r)
  x = X_SIZE
  y = Y_SIZE
  type_freqs = n * [TYPE_1,TYPE_2,TYPE_3,TYPE_4]
  cells = Cell[]
  if(n < 1)
    Messagebox(title="Error", message=string("No cells placed, increase the number of cells"))
    return
  end
  for i in 1:n
    cell_cat = 1
    for j in 1:length(type_freqs)
      cell_cat = (i > sum(1:type_freqs[j])) ? cell_cat : cell_cat
    end
    placed = false
    fails = 0
    rvar = r/10 # Radius Variation
    ri = max(rand_radius(r, rvar),.00001)
    while !placed
      xi = categories[cell_cat].left_placed ? ri : ri + (x - 2ri) * rand()
      yi = ri + (y - 2ri) * rand()
      overlap = false
      if BORDER_SHAPE == "Ellipse"
        cell = Cell(string(i), Point(xi, yi), ri, 0, 0, "Alive", 0)
        in_ellipse(cell) ? overlap = true : nothing
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
        cell = Cell(string(i), Point(xi, yi), ri, 0, 0, "Alive", 0, cell_cat)
        push!(cells, cell)
        placed = true
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
