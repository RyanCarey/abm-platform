using Winston

function show_agents(X::Array,colour = "ro")
  locations = zeros(length(X),3)
  for i in 1:length(X)
		locations[i,:] = [X[i].loc.x X[i].loc.y X[i].r]
  end
  display_circles(locations, colour)
end

function display_circles(locations::Array, colour = "ro")
  x = locations[:, 1]
  y = locations[:, 2]
  r = locations[:, 3]
  xlim(0,X_SIZE)
  ylim(0,Y_SIZE)
  p = scatter(x,y,r/X_SIZE.*70,colour)
  display(p)
  # display(c,p)
end

function display_two(locs::Array, bools::BitArray)
  print(" locs: ",locs)
  print(" bools: ",bools)
  if sum(bools) > 0
    x = locs[:,1][bools]
    println("x: ",x)
    y = locs[:,2][bools]
    println("y: ",y)
    r = locs[:,3][bools]
    println("r: ",r)
    p = scatter(x,y,r/X_SIZE.*70,"ro")
    xlim(0,X_SIZE)
    ylim(0,Y_SIZE)
    display(p)
    hold(true)
  end
  if sum(bools) < length(bools)
    xx = locs[:,1][!bools]
    println("xx: ",xx)
    yy = locs[:,2][!bools]
    println("yy: ",yy)
    rr = locs[:,3][!bools]
    q = scatter(xx,yy,5*rr,"bo")
    xlim(0,X_SIZE)
    ylim(0,Y_SIZE)
    display(q)
    hold(false)
  end
end

function show_ellipse(a::Real,b::Real,n=36)
  hold(true)
  t = [1/n:1/n:1]*2pi
  X = [a*cos(t) b*sin(t)]
  r = scatter(X[:,1],X[:,2],.2,"go")
  display(r)
  hold(false)
end

function display_cell_sets(X::Array, bools::BitArray)
  locations = zeros(length(X),3)
  for i in 1:length(X)
    locations[i,:] = [X[i].loc.x X[i].loc.y X[i].r]
  end
  display_two(locations,bools)
end

function csv_out(filename::String,output::String)
  f = open(filename,"a")
  write(f,output)
  close(f)
end

function csv_out(filename::String, alive_cells::Array, dead_cells::Array)
  f = open(filename,"a")
  write(f, "> New Time Step\n")
  for i in 1:size(alive_cells,1)
    write(f,string(alive_cells[i])[6:end-1],"\n")
  end
  close(f)
end

# 
function start_output(filename::String, t::String, v::Array, conc_map::Array, alive_cells::Array, diffusion_rate::Float64)
  f = open(filename,"a")
  write(f, "> Time, Diffusion Rate\n")
  write(f, "> $t,$diffusion_rate\n")
  write(f, ">", string(join(prompts,","),"\n"))
  write(f, ">", string(join(v,","),"\n"))
  write(f, "> Starting Concentration Map\n")
  write(f, array_to_string(conc_map))
  write(f, "\n")
  write(f, ">Starting Cell Matrix\n")
  for i in 1:size(alive_cells,1)
    write(f, string(alive_cells[i])[6:end-1],"\n")
  end
  write(f, "> Subsequent Cell Matrices\n")
  close(f)
end

function array_to_string(X::Array)
  rows_as_strings = repmat([""],size(X,1),1)
  for i in 1:size(X,1)
    rows_as_strings[i] = join(X[i,:],",")
  end
  join(rows_as_strings,"\n")
end

