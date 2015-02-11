include("angle.jl")
include("borders.jl")
include("cell_type.jl")

using Distributions

function propose_move_x(cell::Cell, speed_param::Float64)
  Y = deepcopy(cell)
  Y.speed = -2*log(rand())*speed_param/5
  #Y.angle = angle_from_both(cell)
  Y.angle = rand() * 2 * pi
  Y.loc.x += Y.speed * cos(Y.angle)
  Y.loc.y += Y.speed * sin(Y.angle) 
  return Y
end

function move_any!(X::Array, max_speed::Float64)
  # moves a random cell
  n = length(X)
  m = rand(1:n)	
	move_cell_x!(X, m, max_speed)	
  return X
end


function move_cell_x!(X::Array, m::Int, max_speed::Float64)
  # takes cell list and (attempts to) move specified cell
	startloc = Point(X[m].loc.x, X[m].loc.y)
	X[m] = propose_move_x(X[m], max_speed)
	check_borders!(X[m],startloc)
	if is_overlap(X, m)
	  X[m].loc = Point(startloc.x,startloc.y)
	  X[m].angle = 0.
	  X[m].speed = 0.
	  #move_cell_x!(X,m,max_speed) # include this to retry moving cell
	end
end

function is_overlap(X::Array, m::Int)
  n = length(X)
  for i in 1:n
    if (X[i].loc.x - X[m].loc.x)^2 + (X[i].loc.y - X[m].loc.y)^2< (X[i].r + X[m].r) ^ 2
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


