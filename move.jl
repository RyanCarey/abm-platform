include("angle.jl")
include("borders.jl")
include("cell_type.jl")
using Distributions

function propose_move_x(conc_map, X::Cell, speed_param::Float64)
  Y = X
  Y.speed = rand()*speed_param
  Y.angle = angleBRW(conc_map,X)
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
  S = X[m]
  X[m] = propose_move_x(conc_map, S, max_speed)
  #X[m] = check_borders(S, X[m].loc)
  print(X)
  if is_overlap(X, m)
    X[m] = S
    X[m].angle = 0.
    X[m].speed = 0.
    #move_cell_x!(conc_map, X,m,max_speed) # include this to retry moving cell
  end
end

function is_overlap(X::Array, m::Int)  # will later need to add multiple radii
  n = length(X)
  distances = zeros(n,3)
  for i in 1:n
    if (X[n].loc.x - X[m].loc.x)^2 + (X[n].loc.y - X[m].loc.y)^2 < (X[n].r + X[m].r)^2
      if n != m
        return true
      end
    end
  end
  return false
end
