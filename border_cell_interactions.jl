# Module to evaluate border - cell interactions.
# Receives the original location and desired location of a cell as an array [x, y].
# Call with x, y, false to use sticking behaviour.
# Needs the bounds of the environment explicitly stated globally.

global_x = 10
global_y = 10

function checkBorders(original_loc, desired_loc, reflect = true)

	println("Original Loc: " , original_loc)

	println("Desired Loc: " , desired_loc)

	if desired_loc[2] < 0
		y_bound = 0
	else
		y_bound = global_y
	end
	println("Y Bound is: ", y_bound)

	if desired_loc[1] < 0
		x_bound = 0
	else
		x_bound = global_x
	end
	println("X Bound is: ", x_bound)

	gradient = (desired_loc[2] - original_loc[2]) / (desired_loc[1] - original_loc[1])
	offset = original_loc[2] - (gradient * original_loc[1])
	intersect_y_bound = (y_bound - offset) / gradient
	intersect_x_bound = (gradient * x_bound) + offset

	if (desired_loc[1] > global_x || desired_loc[1] < 0) && (desired_loc[2] > global_y || desired_loc[2] < 0)
		

		println("Y Bound Violated: " , y_bound)
		
		println("Intersects at: [" , intersect_y_bound, ", ", y_bound, "]")


		println("X Bound Violated: " , x_bound)
		
		println("Intersects at: [" , x_bound, ", ", intersect_x_bound, "]")

		if 0 < intersect_y_bound < 10
			println("Therefore reflecting Y first!")
			println("At this point...")
			println("Current location: ", original_loc)
			println("Desired location: ", desired_loc)
			if reflect
				original_loc, desired_loc = reflectCell_y(original_loc, desired_loc, y_bound, intersect_y_bound)
			else
				desired_loc = stickCell_y(original_loc, desired_loc, y_bound, intersect_y_bound)
			end			
		else
		      	println("Therefore reflecting X first!")
		      	println("At this point...")
		      	println("Current location: ", original_loc)
		      	println("Desired location: ", desired_loc)
			if reflect
			      	original_loc, desired_loc = reflectCell_x(original_loc, desired_loc, x_bound, intersect_x_bound)
			else
				desired_loc = stickCell_x(original_loc, desired_loc, x_bound, intersect_x_bound)
			end	
		 	
		end
	
	elseif desired_loc[1] > global_x || desired_loc[1] < 0
		println("X Bound Violated: " , x_bound)
		println("Therefore reflecting X!")
		println("At this point...")
		println("Current location: ", original_loc)
		println("Desired location: ", desired_loc)

		if reflect
			original_loc, desired_loc = reflectCell_x(original_loc, desired_loc, x_bound, intersect_x_bound)
		else
			desired_loc = stickCell_x(original_loc, desired_loc, x_bound, intersect_x_bound)
		end

		else desired_loc[2] > global_y || desired_loc[2] < 0
			println("Y Bound Violated: " , y_bound)
		
			if reflect
				original_loc, desired_loc = reflectCell_y(original_loc, desired_loc, y_bound, intersect_y_bound)
			else
				desired_loc = stickCell_y(original_loc, desired_loc, y_bound, intersect_y_bound)
			end
		end

	println("Calculating angle of travel...")
	println("Locations used to compute angle:")
	println("Starting Loc: ", original_loc)
	println("Desired Loc: ", desired_loc)
	angle = atan((desired_loc[2] - original_loc[2]) / (desired_loc[1] - original_loc[1]))
	println("Angle is: ", angle)
	
	println("End of Iteration")
	println()

	if desired_loc[1] > global_x || desired_loc[1] < 0 || desired_loc[2] > global_y || desired_loc[2] < 0
		println("Repeating Check Borders")
		desired_loc = checkBorders(original_loc, desired_loc)
	end

	return desired_loc

end

function reflectCell_x(original_loc, desired_loc, x_bound, x_intersect)
	println("Reflecting X...")
	println("Inside Reflect Cell X")
	println("Original Loc is: ", original_loc)
	origin_x = original_loc[1]
	origin_y = original_loc[2]

	desired_x = desired_loc[1]
	desired_y = desired_loc[2]

	desired_x = 2(x_bound) - desired_x
	desired_loc = [desired_x, desired_y]

	if isequal(x_intersect, NaN)
		x_intersect = desired_loc[2]
	end

	original_loc = [x_bound, x_intersect]

	println("Place of Reflection: " , original_loc)
	println("New Desired Location: " , desired_loc)
  
	return original_loc, desired_loc
end

function reflectCell_y(original_loc, desired_loc, y_bound, y_intersect)
	println("Reflecting Y...")
	println("Inside Reflect Cell Y")
	println("Original Loc is: ", original_loc)

	origin_x = original_loc[1]
	origin_y = original_loc[2]

	desired_x = desired_loc[1]
	desired_y = desired_loc[2]

	desired_y = 2(y_bound) - desired_y
	desired_loc = [desired_x, desired_y]
	
	if isequal(y_intersect, NaN)
		y_intersect = desired_loc[1]
	end

	original_loc = [y_intersect, y_bound]

	println("Place of Reflection: " , original_loc)
	println("New Desired Location: " , desired_loc)
  
	return original_loc, desired_loc
end


function stickCell_x(original_loc, desired_loc, x_bound, x_intersect)
		
	desired_loc = [x_bound, x_intersect]
	return desired_loc

end

function stickCell_y(original_loc, desired_loc, y_bound, y_intersect)
	
	desired_loc = [y_intersect, y_bound]
	return desired_loc

end
