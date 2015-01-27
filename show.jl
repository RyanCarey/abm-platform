using Winston

function show_agents(X::Array, X_SIZE::Float64, Y_SIZE::Float64)
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
  for i in 1:size(alive_cells,1)
    write(f,string(alive_cells[i])[6:end-1],"\n")
  end
  close(f)
end

# 
function start_output(filename::String, t::String, v::Array, conc_map::Array, alive_cells::Array, diffusion_rate::Float64)
  f = open(filename,"a")
  write(f, "time,diffusion rate\n")
  write(f, "$t,$diffusion_rate\n")
  write(f, string(join(prompts,","),"\n"))
  write(f, string(join(v,","),"\n"))
  write(f, "starting concentration map\n")
  write(f, array_to_string(conc_map))
  write(f, "\n")
  write(f, "starting cell matrix\n")
  for i in 1:size(alive_cells,1)
    write(f, string(alive_cells[i])[6:end-1],"\n")
  end
  write(f, "subsequent cell matrices\n")
  close(f)
end

function array_to_string(X::Array)
  rows_as_strings = repmat([""],size(X,1),1)
  for i in 1:size(X,1)
    rows_as_strings[i] = join(X[i,:],",")
  end
  join(rows_as_strings,"\n")
end
