# Module to display cells

function display(locations)

x = locations[:, 1]
y = locations[:, 2]
myplot = plot(x = x, y = y)
return myplot
end

locations = rand(10, 2)

using Gadfly
draw(display(locations))