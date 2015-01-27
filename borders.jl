# Module to evaluate border - cell interactions.
# Receives the original location and desired location of a cell as an array [x, y].
# Call with Cell, false to use sticking behaviour.
# Needs the bounds of the environment explicitly stated globally.

include("cell_type.jl")

global BORDER_BEHAVIOUR = "Bounce"

function check_borders!(cell::Cell, final)
	
	r = cell.r
	if final[2] < r
		y_bound = r
	else
		y_bound = Y_SIZE - r
	end
	if final[1] < r 
		x_bound = r
	else
		x_bound = X_SIZE - r
	end
	grad = (final[2] - cell.loc.y) / (final[1] - cell.loc.x)
	offset = cell.loc.y - (grad * cell.loc.x)
	intersect_y_bound = (y_bound - offset) / grad
	intersect_x_bound = (grad * x_bound) + offset
	if (final[1] > X_SIZE - r || final[1] < r) && (final[2] > Y_SIZE - r|| final[2] < r)
		
		if r < intersect_y_bound < Y_SIZE - r
			
			if BORDER_BEHAVIOUR == "Bounce"
				cell, final = reflect_cell_y(cell, final, y_bound, intersect_y_bound)
			else
				final = stick_cell_y(final, y_bound, intersect_y_bound)
			end			
		else
			
			if BORDER_BEHAVIOUR == "Bounce"
	     			cell, final = reflect_cell_x(cell, final, x_bound, intersect_x_bound)
			else
				final = stick_cell_x(final, x_bound, intersect_x_bound)
			end	
		end
	elseif final[1] > X_SIZE - r|| final[1] < r
		
		if BORDER_BEHAVIOUR == "Bounce"
			cell, final = reflect_cell_x(cell, final, x_bound, intersect_x_bound)
		else
			final = stick_cell_x(final, x_bound, intersect_x_bound)
		end
		elseif final[2] > Y_SIZE - r || final[2] < r
			
			if BORDER_BEHAVIOUR == "Bounce"
				cell, final = reflect_cell_y(cell, final, y_bound, intersect_y_bound)
			else
				final = stick_cell_y(final, y_bound, intersect_y_bound)
			end
		end
	angle = atan((final[2] - cell.loc.y) / (final[1] - cell.loc.x))
	cell.loc.x = final[1]
	cell.loc.y = final[2]
	cell.angle = angle
	
	if final[1] > X_SIZE - r || final[1] < r || final[2] > Y_SIZE - r || final[2] < r
		cell = check_borders!(cell, final)
	end
	return cell
end

function reflect_cell_x(cell, final, x_bound, x_intersect)
	
	origin_x = cell.loc.x
	origin_y = cell.loc.y
	desired_x = final[1]
	desired_y = final[2]
	desired_x = 2(x_bound) - desired_x
	final = [desired_x, desired_y]
	if isequal(x_intersect, NaN)
		x_intersect = final[2]
	end
	cell.loc.x = x_bound
	cell.loc.y = x_intersect
	
	return cell, final
end

function reflect_cell_y(cell, final, y_bound, y_intersect)
	
	origin_x = cell.loc.x
	origin_y = cell.loc.y
	desired_x = final[1]
	desired_y = final[2]
	desired_y = 2(y_bound) - desired_y
	final = [desired_x, desired_y]
	if isequal(y_intersect, NaN)
		y_intersect = final[1]
	end
	cell.loc.x = y_intersect
	cell.loc.y = y_bound
	
	return cell, final
end

function stick_cell_x(final, x_bound, x_intersect)
	final = [x_bound, x_intersect]
	return final
end

function stick_cell_y(final, y_bound, y_intersect)
	final = [y_intersect, y_bound]
	return final
end
