# Module to evaluate border - cell interactions.
# Receives the original location and desired location of a cell as an array [x, y].
# Call with Cell, false to use sticking behaviour.
# Needs the bounds of the environment explicitly stated globally.

include("cell_type.jl")
include("ellipse.jl")

function check_borders!(alive_cells, dead_cells,n::Int, source)
  if BORDER_SHAPE == "Ellipse"
    ellipse_borders!(alive_cells[n]::Cell, source)
  else
    if BORDER_BEHAVIOUR == "Reflecting"
      bounce_if_req!(alive_cells[n])
    elseif BORDER_BEHAVIOUR == "Absorbing"
      stick_if_req!(alive_cells[n],source)
    elseif BORDER_BEHAVIOUR == "Killing"
      killing_borders!(alive_cells, dead_cells, source)
    end
  end
end

function killing_borders!(alive_cells, dead_cells, n::Int )
  r = cell.r
  in_bounds = true
  in_bounds = (0 < alive_cells[n].loc.x < X_SIZE) ? in_bounds : false
  in_bounds = (0 < alive_cells[n].loc.y < Y_SIZE) ? in_bounds : false
  if !in_bounds
    cell_death(alive_cells, dead_cells, n)
  end
	return alive_cells, dead_cells
end

function stick_if_req!(cell::Cell,source)
  r = cell.r
  x_bound = (cell.loc.x < r ? r : X_SIZE - r)
  y_bound = (cell.loc.y < r ? r : Y_SIZE - r)
  grad = (cell.loc.y - source.y) / (cell.loc.x - source.x)
  offset = source.y - (grad * source.x)
  x_intersect = (grad * x_bound) + offset
  y_intersect = (y_bound - offset) / grad

  if !(r <= cell.loc.x <= X_SIZE - r) && (0 <= x_intersect <= Y_SIZE)
    stick_cell_y!(cell, source, x_bound, x_intersect)
  end
  if !(r <= cell.loc.y <= Y_SIZE - r)
    stick_cell_x!(cell, source, y_bound, y_intersect)
  end

  # maybe need to add pi here sometimes
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
