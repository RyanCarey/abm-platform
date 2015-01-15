module Display
export display
# Module to display cells
using Winston

function display(locations)
x = locations[:, 1]
y = locations[:, 2]
plot(x, y, "ro")
end

locations = rand(10, 2)
display(locations)



end
