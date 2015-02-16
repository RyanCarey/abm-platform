# Module to evaluate border - cell interactions.
# Receives the original location and desired location of a cell as an array [x, y].
# Call with Cell, false to use sticking behaviour.
# Needs the bounds of the environment explicitly stated globally.

include("cell_type.jl")
include("ellipse.jl")

function check_borders!(alive_cells, dead_cells,n::Int, source::Point)
  cell_died = false
  if BORDER_SHAPE == "Ellipse"
    ellipse_borders!(alive_cells[n], source)
  else
    if BORDER_BEHAVIOUR == "Reflecting"
      bounce_if_req!(alive_cells[n])
    elseif BORDER_BEHAVIOUR == "Absorbing"
      stick_if_req!(alive_cells[n],source)
    elseif BORDER_BEHAVIOUR == "Killing"
      cell_died = killing_borders!(alive_cells, dead_cells, n)
    end
  end
  return cell_died
end

function killing_borders!(alive_cells, dead_cells, n::Int )
  r = alive_cells[n].r
  cell_died = false
  in_bounds = true
  in_bounds = (-r < alive_cells[n].loc.x < X_SIZE+r) ? in_bounds : false
  in_bounds = (-r < alive_cells[n].loc.y < Y_SIZE+r) ? in_bounds : false
  if !in_bounds
    cell_death(alive_cells, dead_cells, n)
    cell_died = true
  end
	return alive_cells, dead_cells, cell_died
end

function stick_if_req!(cell::Cell,source::Point)
  r = cell.r
  x_bound = (cell.loc.x < r ? r : X_SIZE - r)
  y_bound = (cell.loc.y < r ? r : Y_SIZE - r)
  grad = (cell.loc.y - source.y) / (cell.loc.x - source.x)
  offset = source.y - (grad * source.x)
  wall_hit = (grad * x_bound) + offset
  fc_hit = (y_bound - offset) / grad

  if !(r <= cell.loc.x <= X_SIZE - r) && (r <= wall_hit <= Y_SIZE-r)
    wall_stick!(cell, source, x_bound, wall_hit)
  end
  if !(r <= cell.loc.y <= Y_SIZE - r)
    fc_stick!(cell, source, y_bound, fc_hit)
  end

  # maybe need to add pi here sometimes
  cell.angle = atan((cell.loc.y - source.y) / (cell.loc.x - source.x))
end

function bounce_if_req!(cell)
  r = cell.r
  x_bound = (cell.loc.x < r ? r : X_SIZE - r)
  y_bound = (cell.loc.y < r ? r : Y_SIZE - r)
  r <= cell.loc.x <= X_SIZE - r ? nothing : wall_reflect!(cell,x_bound,wall_hit)
  r <= cell.loc.y <= Y_SIZE - r ? nothing : fc_reflect!(cell,y_bound,fc_hit)

  # if out of bounds, redo
  (r <= cell.loc.x <= X_SIZE - r) && (r <= cell.loc.y <= Y_SIZE - r) ? nothing : bounce_if_req!(cell) 
end

function wall_reflect!(cell::Cell, x_bound)
	cell.loc.x = 2(x_bound) - cell.loc.x
  cell.angle = pi - cell.angle
end

function fc_reflect!(cell::Cell, y_bound)
  cell.loc.y = 2(y_bound) - cell.loc.y
  cell.angle = - cell.angle
end

function fc_stick!(cell::Cell, source::Point, y_bound, fc_hit)
  source = Point(cell.loc.x, cell.loc.y)
	cell.loc = Point(fc_hit, y_bound)
  cell.angle = 0.
  cell.speed = 0.
end

function wall_stick!(cell::Cell, source::Point, x_bound, wall_hit)
  source = Point(cell.loc.x, cell.loc.y)
  cell.loc = Point(x_bound, wall_hit)
  cell.angle = 0.
  cell.speed = 0.
end
