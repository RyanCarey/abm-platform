module Show_cells
export show_cells
# Module to display cells
using Winston

function show_cells(locations,x_size,y_size)
x = locations[:, 1]
y = locations[:, 2]
p = plot(x, y, "ro")
xlim(0,x_size)
ylim(0,y_size)

display(p)
end

#locations = rand(10, 2)
#display(locations)




end
