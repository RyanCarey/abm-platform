# find whether a circle is entirely contained within an ellipse
#include("cell_type.jl")
#include("show.jl")

function ellipse_borders!(cell::Cell,source::Point)
  if in_ellipse(cell)
    nothing
  else
    cell.loc = source
  end
end

function in_ellipse(cell::Cell)
  xo = cell.loc.x
  yo = cell.loc.y
  r = cell.r
  x = X_SIZE/2
  y = Y_SIZE/2
  a = X_SIZE/2
  b = Y_SIZE/2
  return (x-xo)^2/(a-r)^2 + (y-yo)^2/(b-r)^2 < 1
end

