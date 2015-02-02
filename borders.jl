# Module to evaluate border - cell interactions.
# Receives the original location and desired location of a cell as an array [x, y].
# Call with Cell, false to use sticking behaviour.
# Needs the bounds of the environment explicitly stated globally.

include("cell_type.jl")
include("ellipse.jl")

function check_borders!(cell::Cell, source)
  if ELLIPTICAL_BORDER
    ellipse_borders!(cell::Cell, source)
  else
    rectangle_borders!(cell::Cell, source)
  end
end

function rectangle_borders!(cell::Cell, source)
  if BORDER_BEHAVIOUR == "Bounce"
    bounce_if_req!(cell)
  elseif BORDER_BEHAVIOUR == "Stick"
    stick_if_req!(cell,source)
  end
end

function stick_if_req!(cell::Cell,source)
  r = cell.r
  x_bound = (cell.loc.x < r ? r : X_SIZE - r)
  y_bound = (cell.loc.y < r ? r : Y_SIZE - r)
  grad = (cell.loc.y - source.y) / (cell.loc.x - source.x)
  offset = source.y - (grad * source.x)
  x_intersect = (grad * x_bound) + offset
  y_intersect = (y_bound - offset) / grad
  r <= cell.loc.x <= X_SIZE - r ? nothing : stick_cell_y!(cell, source, x_bound, x_intersect)
  r <= cell.loc.y <= Y_SIZE - r ? nothing : stick_cell_x!(cell, source, y_bound, y_intersect)
  cell.angle = atan((cell.loc.y - source.y) / (cell.loc.x - source.x))

  # if out of bounds, redo
  (r <= cell.loc.x <= X_SIZE - r) && (r <= cell.loc.y <= Y_SIZE - r) ? nothing : stick_if_req!(cell,source)
end

function bounce_if_req!(cell)
  r = cell.r
  x_bound = (cell.loc.x < r ? r : X_SIZE - r)
  y_bound = (cell.loc.y < r ? r : Y_SIZE - r)
  r <= cell.loc.x <= X_SIZE - r ? nothing : reflect_cell_x!(cell,x_bound)
  r <= cell.loc.y <= Y_SIZE - r ? nothing : reflect_cell_y!(cell,y_bound)

  # if out of bounds, redo
  (r <= cell.loc.x <= X_SIZE - r) && (r <= cell.loc.y <= Y_SIZE - r) ? nothing : bounce_if_req!(cell) 
end

function reflect_cell_x!(cell::Cell, x_bound)
	cell.loc.x = 2(x_bound) - cell.loc.x
  cell.angle = pi - cell.angle
end

function reflect_cell_y!(cell::Cell, y_bound)
  cell.loc.y = 2(y_bound) - cell.loc.y
  cell.angle = - cell.angle
end

function stick_cell_x!(cell::Cell, source::Point, x_bound, x_intersect)
  source = Point(cell.loc.x, cell.loc.y)
	cell.loc = Point(x_intersect, x_bound)
  cell.angle = 0.
  cell.speed = 0.
end

function stick_cell_y!(cell::Cell, source::Point, y_bound, y_intersect)
  source = Point(cell.loc.x, cell.loc.y)
  cell.loc = Point(y_bound, y_intersect)
  cell.angle = 0.
  cell.speed = 0.
end
