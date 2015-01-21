# Module to display cells
using Winston

# should not need radius as argument anymore
function show_cells(locations::Array, x_size::Float64, y_size::Float64)
  x = locations[:, 1]
  y = locations[:, 2]
  r = locations[:, 3]
  p = scatter(x,y,r/x_size.*70,"ro")
  xlim(0,x_size)
  ylim(0,y_size)
  display(p)
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



