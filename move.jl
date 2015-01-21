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


# from here down is a bunch of old functions that we're not currently using

generate_exp(rate::Float64) = -1/rate*log(1-rand())

function propose_move_all(x::Array,max_speed::Float64)
  # moves all cells. Takes n*2 matrix, returns n*2 matrix
  n = size(x,1)
  speeds = max_speed*rand(n,1)
  dirs = 2*rand(n,1) 
  x += speeds.*[sinpi(dirs) cospi(dirs)]
  return x
end

function list_locations(x::Array)
  println(x)
end

function propose_move_any(i::Array,max_speed::Float64)
  f = copy(i)
  n = size(i,1)
  m = rand(1:n)
  d = propose_move_x(i[m,:], max_speed)
  f[m,:]=d
  return f
end


function describe_move(initial::Array, final::Array)
  println("start pos")
  println(initial)
  println("diff")
  println(final-initial)
  println("proposed pos")
  println(final)
end

function propose_describe_move(i::Array,max_speed::Float64)
  # returns proposed move, prints proposed pos and difference
  f = propose_move_any(i,max_speed)
  describe_move(i,f)
  return f
end


function move_many_times(i::Array, max_speed::Float64, rate::Float64, time::Float64)
  f = copy(i)
  println(i)
  time_rem = time
  steps = 0
  while time_rem > 0
    time_rem -= generate_exp(rate)
    f = propose_move_any(f,max_speed)
    steps += 1
  end
  describe_move(i,f)
  println("$steps steps taken")
  return f 
end

#a = [0.0 0.0;0.0 0.0;0.0 0.0]
#for i in 1:5
  #move_many_times(a, 2.0, 1.0, 10.0)
#end

#a = propose_describe_move(a,1.0)
#a = propose_describe_move(a,1.0)
#a = propose_describe_move(a,2.0)

