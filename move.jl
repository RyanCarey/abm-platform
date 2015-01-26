include("angle.jl")
include("borders.jl")
include("cell_type.jl")
using Distributions

function propose_move_x(conc_map, cell::Cell, speed_param::Float64)
 # Y = X
 # Y.speed = rand()*speed_param
 # Y.angle = angleBRW(conc_map,X)
 # Y.loc.x += Y.speed * cos(Y.angle)
 # Y.loc.y += Y.speed * sin(Y.angle) 
 # return Y

	cell.speed = rand() * speed_param
	cell.angle = angleBRW(conc_map, cell)
	final = Point(cell.loc.x + (cell.speed * cos(cell.angle)), (cell.loc.y + cell.speed * sin(cell.angle)))
	return cell, final
end

function move_any!(conc_map::Array, X::Array, max_speed::Float64)
	n = length(X)
	m = rand(1:n)
	
	move_cell_x!(conc_map, X, m, max_speed)
	return X
end

function move_cell_x!(conc_map, X::Array, m::Int, max_speed::Float64)
  #takes all cell positions and returns the whole list with a valid move or no move
  cell = X[m]
  cell, final = propose_move_x(conc_map, cell, max_speed)
  cell = check_borders(cell, final)
  if is_overlap(X, m)
	#move_cell_x!(conc_map, X, m, 0.2) # include this to retry moving cell. Small speed so it only just moves a little.
	
  else
	X[m] = cell
	print(X)
	end
end

function is_overlap(X::Array, m::Int)  
	n = length(X)

	for i in 1:n
		if n != m && sqrt((X[n].loc.x - X[m].loc.x)^2 + (X[n].loc.y - X[m].loc.y)^2) < X[n].r + X[m].r
			return true
   		end
 	end
	return false
end
