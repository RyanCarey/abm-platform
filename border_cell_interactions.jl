# Module to evaluate border - cell interactions

global_x = 10
global_y = 10

function checkBorders(original_loc, desired_loc)
origin_x = original_loc[1]
origin_y = original_loc[2]

desired_x = desired_loc[1]
desired_y = desired_loc[2]

# Need a global variable to denote which type of interaction to use
# Also need global x and y bounds.

if desired_x >= global_x || desired x <= 0
reflectCell_x(original_loc, desired_loc)
end

if desired_y >= global_y || desired_y <= 0
reflectCell_y(original_loc, desired_loc)
end

end

function reflectCell_x(original_loc, desired_loc)
origin_x = original_loc[1]
origin_y = original_loc[2]

desired_x = desired_loc[1]
desired_y = desired_loc[2]

desired_x = 2(global_x) - desired_x
return desired_x, desired_y

end

function reflectCell_y(original_loc, desired_loc)
origin_x = original_loc[1]
origin_y = original_loc[2]

desired_x = desired_loc[1]
desired_y = desired_loc[2]

desired_y = 2(global_y) - desired_y

return desired_x, desired_y
end


function stickCell_x(original_loc, desired_loc)
end

function stickCell_y(original_loc, desired_loc)
end
