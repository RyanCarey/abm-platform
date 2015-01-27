using Winston

function show_agents(X::Array, x_size::Float64, y_size::Float64)
  locations = zeros(length(X),3)
  for i in 1:length(X)
		if X[i].state == "Alive"
   	 locations[i,:] = [X[i].loc.x X[i].loc.y X[i].r]
		end
  end
  x = locations[:, 1]
  y = locations[:, 2]
  r = locations[:, 3]
  p = scatter(x,y,r/x_size.*70,"ro")
  xlim(0,x_size)
  ylim(0,y_size)
  display(c,p)
end

function csv_out(filename::String,output::String)
  f = open(filename,"a")
  write(f,output)
  close(f)
end

function csv_out(filename::String, out::Array)
  f = open(filename,"a")
  for i in 1:size(out,1)
    g = tuple(out[i,:]...)
    write(f,join(g,","),"\n")
  end
  close(f)
end

function start_output(filename::String, t::String, cell_speed::Float64, radius::Float64, conc_map::Array, X::Array, diffusion_rate::Float64)
  csv_out(filename,"time,cells,cell speed,radius,steps,x_size,y_size,diffusion rate\n")
  csv_out(filename,"$t,$cells,$cell_speed,$radius,$steps,$x_size,$y_size,$diffusion_rate\n")
  csv_out(filename,"starting concentration map\n")
  csv_out(filename,conc_map)
  csv_out(filename,"starting position matrix\n")
  csv_out(filename,X)
  csv_out(filename,"subsequent position matrices\n")
end

