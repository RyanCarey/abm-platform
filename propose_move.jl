module propose_move
export propose_move_all, list_locations, propose_move_one, describe_move, propose_describe_move, move_many_times



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

function propose_move_one(i::Array,max_speed::Float64)
  n = size(i,1)
  moving = rand(1:n)
  speed = max_speed*rand()
  dir = 2*rand()
  f = copy(i)
  f[moving,:] += speed*[sinpi(dir) cospi(dir)]
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
  f = propose_move_one(i,max_speed)
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
    f = propose_move_one(f,max_speed)
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
