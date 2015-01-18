module Show_cells
export show_cells
# Module to display cells
using Winston

function show_cells(locations::Array, radius::Float64, x_size::Float64, y_size::Float64)
x = locations[:, 1]
y = locations[:, 2]
p = scatter(x,y,radius/x_size*70,"ro")

#p = plot(x, y, "ro")
xlim(0,x_size)
ylim(0,y_size)

display(p)
end

#locations = rand(10, 2)
#display(locations)




end
