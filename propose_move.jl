module Propose_move
export propose_move_all, list_locations, propose_move_any, describe_move, propose_describe_move
export move_many_times, propose_move_x, propose_describe_move, is_overlap, move_cell_x!
export move_any


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
  cell_index = rand(1:n)
  d = propose_move_x(i[cell_index,:], max_speed)
  f[cell_index,:]=d
  return f
end

function propose_move_x(pos::Array, max_speed::Float64)
  f = copy(pos)
  speed = max_speed*rand()
  dir = 2*rand()
  f += speed*[sinpi(dir) cospi(dir)]
  return f
end


function move_any(i::Array, max_speed::Float64, radius::Float64)
  f = copy(i)
  n = size(i,1)
  x = rand(1:n)
  println("move cell $n")
  move_cell_x!(f,x, max_speed, radius)
  return f      #this could be made a mutator method
end

function move_cell_x!(i::Array, cell_index::Int, max_speed::Float64, radius::Float64)
  #takes all cell positions and returns the whole matrix with a valid move or no move
  println("move cell from")
  println(i[cell_index,:])
  pos = i[cell_index,:]
  i[cell_index,:] = propose_move_x(pos, max_speed)
  if is_overlap(i, cell_index, radius)
    println("overlap")
    i[cell_index,:] = pos
    return i
    #move_cell_x(i,cell_index,max_speed,radius) # include this to retry moving cell
  else
    println("move cell to")
    println(i[cell_index,:])
    return i
  end
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

function is_overlap(i::Array, cell_index::Int, radius::Float64)  # will later need to add multiple radii
  distance_mat = i - repmat(i[cell_index,:],size(i,1),1)
  nearby = [distance_mat - repmat(i[cell_index,:],size(i,1),1) .< 2*radius]
  nearby[cell_index] = false    #exclude the cell itself
  possible_overlappers = i[nearby]
  println(possible_overlappers)
  overlappers = sqrt(sum(possible_overlappers.^2,2))-2*radius .< 0.0
  if sum(overlappers) > 0
    return true
  else
    return false
  end
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

end
