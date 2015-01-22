include("angle.jl")
include("border_cell_interactions.jl")
using Distributions

function propose_move_x(conc_map, X::Array{Float64,2}, speed_param::Float64)
  @assert size(X,1)==1
  Y = copy(X)
  speed = rand()*speed_param
  angle = angleBRW(conc_map,Y[1,:]) #elaborate this
  Y[1,1:2] += speed*[cos(angle) sin(angle)]
  Y[1,4:5] = [angle speed]
  return Y
end

function move_any!(conc_map, X::Array, max_speed::Float64)
  n = size(X,1)
  m = rand(1:n)
  move_cell_x!(conc_map, X, m, max_speed)
  return X
end

function move_cell_x!(conc_map, X::Array, m::Int, max_speed::Float64)
  #takes all cell positions and returns the whole matrix with a valid move or no move
  S = X[m,:]
  X[m,:] = propose_move_x(conc_map, S, max_speed)
  X[m,:] = checkBorders(S[1,:],X[m,:])
  if is_overlap(X, m)
    X[m,:] = S
    X[m,4:5] = [0.,0.]
    #move_cell_x!(conc_map, X,m,max_speed) # include this to retry moving cell
  end
end

function is_overlap(X::Array, m::Int)  # will later need to add multiple radii
  n = size(X,1)
  distances = zeros(n,3)
  distances[:,1:2] = abs(X[:,1:2] - repmat(X[m,1:2],n,1))
  distances[:,3] = X[:,3]
  is_nearby = (distances[:,1] .< (distances[:,3]+X[m,3])) & (distances[:,2] .< (distances[:,3]+X[m,3]))
  is_nearby[m] = false    #exclude the cell itself
  small_distances = distances[is_nearby,:]
  overlap_bools = sqrt(sum(small_distances[:,1:2].^2,2)) .< (small_distances[:,3].+X[m,3])
  if sum(overlap_bools) > 0
    return true
  else
    return false
  end
end
