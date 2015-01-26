include("angle.jl")
include("borders.jl")
include("cell_type.jl")
using Distributions

function propose_move_x(conc_map, cell::Cell, speed_param::Float64)
  Y = cell
  Y.speed = rand()*speed_param
  Y.angle = angleBRW(conc_map,cell)
  Y.loc.x += Y.speed * cos(Y.angle)
  Y.loc.y += Y.speed * sin(Y.angle) 
  return Y
end

function move_any!(conc_map::Array, X::Array, max_speed::Float64)
  n = length(X)
  m = rand(1:n)
  move_cell_x!(conc_map, X, m, max_speed)
  return X
end

function move_cell_x!(conc_map, X::Array, m::Int, max_speed::Float64)
  #takes all cell positions and returns the whole list with a valid move or no move
  start = deepcopy(X[m])
  X[m] = propose_move_x(conc_map, start, max_speed)
  X[m] = check_borders(start, X[m].loc)
  if is_overlap(X, m)
    println("overlap")
    println(X)
    X[m] = deepcopy(start)
    X[m].angle = 0.
    X[m].speed = 0.
    println(X)
    #move_cell_x!(conc_map, X,m,max_speed) # include this to retry moving cell
  end
end

function is_overlap(X::Array, m::Int)
  n = length(X)
  for i in 1:n
    if sqrt((X[i].loc.x - X[m].loc.x)^2 + (X[i].loc.y - X[m].loc.y)^2) < (X[i].r + X[m].r)
      if n != m
        return true
      end
    end
  end
  return false
end
