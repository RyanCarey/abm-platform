include("angle.jl")
include("borders.jl")
include("cell_type.jl")

using Distributions

function propose_move_x(cell::Cell, speed_param::Float64)
  Y = deepcopy(cell)
  Y.speed = -2*log(rand())*speed_param/5
  Y.angle = angle_from_both(cell)
  Y.loc.x += Y.speed * cos(Y.angle)
  Y.loc.y += Y.speed * sin(Y.angle) 
  return Y
end

function move_any!(alive_cells::Array, max_speed::Float64)
  # moves a random cell
  n = length(alive_cells)
  m = rand(1:n)	
	move_cell_x!(alive_cells, dead_cells, m, max_speed)	
  return alive_cells
end

function move_cell_x!(alive_cells::Array, dead_cells::Array, m::Int, max_speed::Float64)
  # takes cell list and (attempts to) move specified cell
	startloc = Point(alive_cells[m].loc.x, alive_cells[m].loc.y)
	alive_cells[m] = propose_move_x(alive_cells[m], max_speed)
	check_borders!(alive_cells,dead_cells,m,startloc)
	if is_overlap(alive_cells, m)
	  alive_cells[m].loc = Point(startloc.x,startloc.y)
	  alive_cells[m].angle = 0.
	  alive_cells[m].speed = 0.
	  #move_cell_x!(alive_cells,dead_cells,m,max_speed) # include this to retry moving cell
	end
end

function is_overlap(alive_cells::Array, m::Int)
  n = length(alive_cells)
  for i in 1:n
    if (alive_cells[i].loc.x - alive_cells[m].loc.x)^2 + (alive_cells[i].loc.y - alive_cells[m].loc.y)^2< (alive_cells[i].r + alive_cells[m].r) ^ 2
      if i != m
        return true
      end
    end
  end
  return false
end

function is_overlap(cells::Array, point::Point, radius::Real)
	n = length(cells)
		for i in 1:n
			if (cells[i].loc.x - point.x) ^ 2 + (cells[i].loc.y - point.y) ^ 2 < (cells[i].r + radius) ^ 2
        return true
			end
		end
	return false
end

function is_overlap(cells::Array, index::Int, point::Point, radius::Real)
  n = length(cells)
    for i in 1:n
      if (cells[i].loc.x - point.x) ^ 2 + (cells[i].loc.y - point.y) ^ 2 < (cells[i].r + radius) ^ 2 && i != index
        return true
      end
    end
  return false
end


