using Winston

function show_agents(M::Array,X::Array)
  locations = zeros(length(X),3)
  for i in 1:length(X)
		locations[i,:] = [X[i].loc.x X[i].loc.y X[i].r]
  end
  x = locations[:, 1]
  y = locations[:, 2]
  r = locations[:, 3]
  p = scatter(x,y,r/X_SIZE.*70,"ro")
  xlim(0,X_SIZE)
  ylim(0,Y_SIZE)
  display(c,p)
  hold(true)
  L=matrix_list(M)
  l=scatter(L[:,1],L[:,2],2*L[:,3]/maximum(L[:,3]),round(L[:,3]),"*")
  display(c,l)
  hold(false)
end

function show_cells(X::Array)
  locations = zeros(length(X),3)
  for i in 1:length(X)
		locations[i,:] = [X[i].loc.x X[i].loc.y X[i].r]
  end
  x = locations[:, 1]
  y = locations[:, 2]
  r = locations[:, 3]
  p = scatter(x,y,r/X_SIZE.*70,"ro")
  xlim(0,X_SIZE)
  ylim(0,Y_SIZE)
  display(c,p)
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
