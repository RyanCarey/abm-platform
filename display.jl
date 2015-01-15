# Module to display cells

function display(locations)

x = locations[:, 1]
y = locations[:, 2]
plot(x, y, "ro")
end

# locations = rand(10, 2)

using Winston
display(locations)

