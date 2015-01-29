# find whether a circle is entirely contained within an ellipse
include("cell_type.jl")
include("show.jl")
include("init.jl")

global X_SIZE = global Y_SIZE = 10


function ellipse_test(n=3,ellipse = [6,4])
  cells = init(n,1)
  bools = falses(n)
  #blah = rand(10,3)
  for i in 1:length(cells)
    bools[i] = in_ellipse(cells[i],ellipse)
  end
  display_cell_sets(cells,bools)
  show_ellipse(ellipse[1],ellipse[2])
  #print(blah,bools)
end

function in_square(cell::Cell,square::Array)
  xo = cell.loc.x
  yo = cell.loc.y
  r = cell.r
  a = square[1]
  b = square[2]
  return (-a+r < xo < a-r) && (-b+r < yo < b-r)
end

function in_ellipse(cell::Cell,ellipse::Array)
  xo = cell.loc.x
  yo = cell.loc.y
  r = cell.r
  a = ellipse[1]
  b = ellipse[2]
  return xo^2/(a-r)^2 + yo^2/(b-r)^2 < 1
end

