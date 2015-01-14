function propose_move(x::Array,max_speed::Float64)
  # takes n*2 matrix of positions and returns new position
  n = size(x,1)
  speeds = max_speed*rand(n,1)
  dirs = 2*rand(n,1) 
  x += [sinpi(dirs) cospi(dirs)]
  return x
end

function list_locations(x::Array)
  println(x)
end
  
a = [0 0;0 0; 0 0]
b = propose_move(a,1.0)
list_locations(b-a)

b = propose_move(a,1.0)
list_locations(b-a)

b = propose_move(a,1.0)
list_locations(b-a)

b = propose_move(a,1.0)
list_locations(b-a)
