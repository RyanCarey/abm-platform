# Module to evaluate border - cell interactions.
# Receives the original location and desired location of a cell as an array [x, y].
# Call with x, y, false to use sticking behaviour.
# Needs the bounds of the environment explicitly stated globally.


function check_borders(initial, final, reflect = true)
  r = initial[3]
	if final[2] < r
		y_bound = r
	else
		y_bound = y_size - r
	end
	if final[1] < r 
		x_bound = r
	else
		x_bound = x_size - r
	end
	grad = (final[2] - initial[2]) / (final[1] - initial[1])
	offset = initial[2] - (grad * initial[1])
	intersect_y_bound = (y_bound - offset) / grad
	intersect_x_bound = (grad * x_bound) + offset
	if (final[1] > x_size - r || final[1] < r) && (final[2] > y_size - r|| final[2] < r)
		if r < intersect_y_bound < y_size - r
			if reflect
				initial[1:2], final[1:2] = reflect_cell_y(initial[1:2], final[1:2], y_bound, intersect_y_bound)
			else
				final = stick_cell_y(initial, final, y_bound, intersect_y_bound)
			end			
		else
			if reflect
	     	initial[1:2], final[1:2] = reflect_cell_x(initial[1:2], final[1:2], x_bound, intersect_x_bound)
			else
				final = stick_cell_x(initial[1:2] , final[1:2] , x_bound, intersect_x_bound)
			end	
		end
	elseif final[1] > x_size - r|| final[1] < r
		if reflect
			initial[1:2], final[1:2] = reflect_cell_x(initial[1:2], final[1:2], x_bound, intersect_x_bound)
		else
			final = stick_cell_x(initial[1:2] , final[1:2] , x_bound, intersect_x_bound)
		end
		else final[2] > y_size - r|| final[2] < 0
			if reflect
				initial[1:2], final[1:2] = reflect_cell_y(initial[1:2], final[1:2], y_bound, intersect_y_bound)
			else
				final[1:2] = stick_cell_y(initial[1:2], final[1:2], y_bound, intersect_y_bound)
			end
		end
	angle = atan((final[2] - initial[2]) / (final[1] - initial[1]))
	if final[1] > x_size - r || final[1] < r || final[2] > y_size - r || final[2] < r
		final = check_borders(initial, final)
	end
	return final
end

function reflect_cell_x(initial, final, x_bound, x_intersect)
	origin_x = initial[1]
	origin_y = initial[2]
	desired_x = final[1]
	desired_y = final[2]
	desired_x = 2(x_bound) - desired_x
	final = [desired_x, desired_y]
	if isequal(x_intersect, NaN)
		x_intersect = final[2]
	end
	initial = [x_bound, x_intersect]
	return initial, final
end

function reflect_cell_y(initial, final, y_bound, y_intersect)
	origin_x = initial[1]
	origin_y = initial[2]
	desired_x = final[1]
	desired_y = final[2]
	desired_y = 2(y_bound) - desired_y
	final = [desired_x, desired_y]
	if isequal(y_intersect, NaN)
		y_intersect = final[1]
	end
	initial = [y_intersect, y_bound]
	return initial, final
end

function stick_cell_x(initial, final, x_bound, x_intersect)
	final = [x_bound, x_intersect]
	return final
end

function stick_cell_y(initial, final, y_bound, y_intersect)
	final = [y_intersect, y_bound]
	return final
end
