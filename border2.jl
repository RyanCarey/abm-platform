# Module to evaluate border - cell interactions.
# Receives a cell and desired location of a cell as an array [x y].
# Call with cell, [x y], false to use sticking behaviour.
# Needs the bounds of the environment explicitly stated globally.

include("cell_type.jl")

function check_borders(cell::Cell, final, reflect = true)

	final = [final[1] final[2]]
	
	newcell = cell
	initial = [newcell.loc.x newcell.loc.y]
	radius = cell.r
	# Calculate bound(s) to be crossed

	# If final Y is less than 0, Y bound is bottom bound
	# Else is top bound
	if final[2] < radius
		y_bound = [0.0 0.0; x_size 0.0]
	else
		y_bound = [0.0 y_size; x_size y_size]
	end
	# If final X is less than 0, X bound is left bound
	# Else is right bound
	if final[1] < radius
		x_bound = [0.0 0.0; 0.0 y_size]
	else
		x_bound = [x_size 0.0; x_size y_size]
	end

	# Shrink environment by radius to check if circle ever touches a bound
	temp_x_left_bound = [radius radius; radius (y_size - radius)]
	temp_x_right_bound = [(x_size - radius) radius; (x_size - radius) (y_size - radius)]
	temp_y_upper_bound = [radius (y_size - radius); (x_size - radius) (y_size - radius)]
	temp_y_lower_bound = [radius radius; (x_size - radius) radius]

	if !(line_intersection(initial, final, temp_x_left_bound, radius)[2] || line_intersection(initial, final, temp_x_right_bound, radius)[2] || line_intersection(initial, final, temp_y_upper_bound, radius)[2] || line_intersection(initial, final, temp_y_lower_bound, radius)[2])
	println("Circle never touches a bound")
	cell.loc.x = final[1]
	cell.loc.y = final[2]
	return newcell
	end

	for i in 1:4
		if i == 1
			corner = [0 0]
		end
		if i == 2
			corner = [0 y_size]
		end
		if i == 3
			corner = [x_size y_size]
		end
		if i == 4
			corner = [x_size 0]
		end
		println("Corner being checked: ", corner)
		if corner == closest_point(corner, [initial; final])
			final[1] = float(final[1]) - e
		#	final[2] = float(final[2]) + e
		end
	end 

	println("Detected bounds are: ")
	println("X Bound: ", x_bound)
	println("Y Bound: ", y_bound)
	# Detect which bounds potential move violates
	# If movement vector intersects both bounds
	if (line_intersection(initial, final, y_bound, radius)[2])
		println("Y Bound Violated!")
		if reflect
			initial, final = circle_line_collision(initial, final, y_bound, radius)
		else
			initial, final = circle_line_collision(initial, final, y_bound, radius)
		end
	elseif (line_intersection(initial, final, x_bound, radius)[2])
		println("X Bound Violated!")
		if reflect
			initial, final = circle_line_collision(initial, final, x_bound, radius)
		else
			initial, final = circle_line_collision(initial, final, x_bound, radius)
		end
	else
		newcell.loc.x = final[1]
		newcell.loc.y = final[2]
		return newcell
	end
	
	angle = atan((final[2] - initial[2]) / (final[1] - initial[1]))
	if final[1] > x_size || final[1] < 0 || final[2] > y_size || final[2] < 0
		newcell = check_borders(newcell, final)
	end
	newcell.loc.x = final[1]
	newcell.loc.y = final[2]
	newcell.angle = angle
	return newcell
end
			

# Function to calculate point of intersection between two lines
# Syntax: Initial Point [x y], Final Point [x y], Line [x y; x y]
function line_intersection(initial, final, bound, radius)
	# For ease:
	x1 = initial[1]
	x2 = final[1]
	x3 = bound[1; 1]
	x4 = bound[2; 1]
	y1 = initial[2]
	y2 = final[2]
	y3 = bound[1; 2]
	y4 = bound[2; 2]
#	println("Calculating line intersection between lines ", initial, final, " and ", bound)
	A1 = y2 - y1
	B1 = x1 - x2
	C1 = (A1 * x1) + (B1 * y1)
	A2 = y4 - y3
	B2 = x3 - x4
	C2 = (A2 * x3) + (B2 * y3)
	det = A1 * B2 - A2 * B1
		
	# Check if lines ever cross, if taken to infinity
	if det == 0
		println("Lines do not ever intersect")
		return null, false

	else
		x = ((C1 * B2) - (B1 * C2)) / det
		y = ((A1 * C2) - (A2 * C1)) / det

		# Check that the point is on both lines
		# If on both, return point and true
		if min(x1, x2) <= x <= max(x1, x2) && min(x3, x4) <= x <= max(x3, x4) && min(y1, y2) <= y <= max(y1, y2) && min(y3, y4) <= y <= max(y3, y4)
			println("Line segments intersect at: ", [x y])
			return [x y], true

		# Else return point and false
		else
			println("Lines intersect at: ", [x y])
			println("Note that this point is not on both line segments")
			return [x y], false
		end

	end
end

# Function to calculate closest point on line to the first point
# Syntax: Point [x y], Line [x y; x y]
function closest_point(point, line)
	println("Calculating closest point to ", point, " on line between ", line[1;:], line[2;:])
	A = line[2; 2] - line[1; 2]
	B = line[1; 1] - line[2; 1]
	C1 = (A * line[1; 1]) + (B * line[1; 2])
	C2 = (-B * point[1]) + (A * point[2])
	det = (A * A) - (B * -B)

	if det != 0
		x = ((A * C1) - (B * C2)) / det
		y = ((A * C2) + (B * C1)) / det
	else
		x = point[1]
		y = point[2]
	end
	println("Closest point is: ", [x y])
	return [x y]
end

# Function to calculate collision response
# Syntax: Initial Point [x y], Point 2 [x y], Point 3 [x y]

function collision_response(initial, p2, p3)
	println("Calculating collision response...")
	direction_vector = initial - (2 * (p3 - p2) + p2)
	println("Direction vector is: ", direction_vector)

	norm_d_v = sqrt(sum(direction_vector.^2, 2))
	println("Norm D V is: ", norm_d_v)

	u_v = direction_vector ./ norm_d_v
	println("UV is: ", u_v)

	return u_v
end

# Function to calculate the outcome of a circle - line collision
# Syntax: Initial Point of Circle [x y], Final Point of Circle [x y], Bound Line [x y; x y], Radius R
function circle_line_collision(initial, final, bound, r)
	println("Calculating point at which circle collides with line")
	# Point 1
	p1 = closest_point(initial, bound)
	distance = sqrt((p1[1] - initial[1]) ^ 2 + (p1[2] - initial[2]) ^ 2)

	# A
	a = line_intersection(initial, final, bound, r)[1]

	# B
	b = closest_point(final, bound)

	# C
	c = closest_point(bound[1;:], [initial; final])

	# D
	d = closest_point(bound[2;:], [initial; final])

	# AC vector
	println("Initial Loc: ", initial)
	println("A: ", a)
	ac = sqrt(sum((initial - a).^2,2))

	#P1C vector
	p1c = sqrt(sum((initial - p1).^2, 2))

	movement = final - initial
	println("Movement: ", movement)
	norm_move = sqrt(sum(movement.^2,2))
	println("Norm Move: ", norm_move)
	term = movement ./ norm_move
	println("Term: ", term)
	println("AC is: ", ac)
	println("p1c is: ", p1c)
	println("a is: ", a)
	p2 = a - r * (ac / p1c) * term
	println("p2: ", p2)
	
	pc = closest_point(p2, bound)
	println("pc: ", pc)
	p3 = p2 + (p1 - pc)
	println("p3: ", p3)

	u_v = collision_response(initial, p2, p3)
	println("U V: ", u_v)
	difference = sqrt(sum((p2 - initial).^2, 2))
	println("Difference: ", difference)
	left_to_travel = norm_move - difference
	println("Left to travel: ", left_to_travel)
	collision_velocity = u_v .* left_to_travel
	println("Collision Velocity: ", collision_velocity)
	end_loc = p2 + collision_velocity
	return p2, end_loc

end
