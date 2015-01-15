# Module to display cells

function display(locations)
	 x = locations[:, 1]
	 y = locations[:, 2]
	 return x, y
	 end

locations = rand(10, 2)
x, y = display(locations)
using Gadfly
myplot = plot(x = x, y = y, Theme(default_point_size=2mm)
draw(myplot)
 