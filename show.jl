using Winston

function show_agents(M::Array,X::Array)
  locations = zeros(length(X),3)
  for i in 1:length(X)
		locations[i,:] = [X[i].loc.x X[i].loc.y X[i].r]
  end
  display_circles(locations)
end

function display_circles(locations::Array)
  x = locations[:, 1]
  y = locations[:, 2]
  r = locations[:, 3]
  xlim(0,X_SIZE)
  ylim(0,Y_SIZE)
  p = scatter(x,y,r/X_SIZE.*70,colour)
  display(c,p)
end

function display_two(locations::Array, bools::BitArray)
  x = locations[:, 1][bools]
  y = locations[:, 2][bools]
  r = locations[:, 3][bools]
  p = scatter(x,y,r,"r")
  display(p)
  hold(true)
  x2 = locations[:,1][!bools]
  y2 = locations[:,2][!bools]
  r2 = locations[:,3][!bools]
  q = scatter(x2,y2,r2,"b")
  display(q)
  hold(false)
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
