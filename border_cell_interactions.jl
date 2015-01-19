# Module to evaluate border - cell interactions.
# Receives the original location and desired location of a cell as an array [x, y].
# Call with x, y, false to use sticking behaviour.
# Needs the bounds of the environment explicitly stated globally.

global_x = 10
global_y = 10

function checkBorders(original_loc, desired_loc, reflect = true)
  origin_x = original_loc[1]
  origin_y = original_loc[2]

  println("Original Loc: " , original_loc)

  desired_x = desired_loc[1]
  desired_y = desired_loc[2]

  println("Desired Loc: " , desired_loc)

  if desired_y <= 0
    y_bound = 0
  else
    y_bound = global_y
  end

  if desired_x <= 0
    x_bound = 0
  else
    x_bound = global_x
  end

  if (desired_x >= global_x || desired_x <= 0) && (desired_y >= global_y || desired_y <= 0)
    gradient = (desired_y - origin_y) / (desired_x - origin_x)
    offset = origin_y - (gradient * origin_x)

    println("Y Bound Violated: " , y_bound)
    intersect_y_bound = (y_bound - offset) / gradient
    println("Intersects at: " , intersect_y_bound)


    println("X Bound Violated: " , x_bound)
    intersect_x_bound = (gradient * x_bound) + offset
    println("Intersects at: " , intersect_x_bound)

    if intersect_y_bound < intersect_x_bound
      println("Therefore reflecting Y first!")
      println("At this point...")
      println("Current location: ", original_loc)
      println("Desired location: ", desired_loc)
      desired_loc = reflectCell_y(original_loc, desired_loc, y_bound)
      original_loc = [intersect_y_bound, y_bound]

    else
      println("Therefore reflecting X first!")
      println("At this point...")
      println("Current location: ", original_loc)
      println("Desired location: ", desired_loc)
      desired_loc = reflectCell_x(original_loc, desired_loc, x_bound)
      original_loc = [x_bound, intersect_x_bound]

    end

  end

  if desired_x >= global_x || desired_x <= 0
    println("X Bound Violated: " , x_bound)
    if reflect
      desired_x, desired_y = reflectCell_x(original_loc, desired_loc, x_bound)
    else
      desired_x, desired_y = stickCell_x(original_loc, desired_loc)
    end

  end

  if desired_y >= global_y || desired_y <= 0
    println("Y Bound Violated: " , y_bound)
    if reflect
      desired_x, desired_y = reflectCell_y(original_loc, desired_loc, y_bound)
    else
      desired_x, desired_y = stickCell_y(original_loc, desired_loc)
    end

  end

  if desired_x >= global_x || desired_x <= 0 || desired_y >= global_y || desired_y <= 0
    checkBorders(original_loc, desired_loc)
  end

  return desired_x, desired_y

end

function reflectCell_x(original_loc, desired_loc, bound)
  println("Reflecting X")
  origin_x = original_loc[1]
  origin_y = original_loc[2]

  desired_x = desired_loc[1]
  desired_y = desired_loc[2]

  desired_x = 2(bound) - desired_x
  desired_loc = [desired_x, desired_y]
  println("Place of Reflection:" , original_loc)
  println("New Desired Location: " , desired_loc)
  return desired_loc

end

function reflectCell_y(original_loc, desired_loc, bound)
  println("Reflecting Y")
  origin_x = original_loc[1]
  origin_y = original_loc[2]

  desired_x = desired_loc[1]
  desired_y = desired_loc[2]

  desired_y = 2(bound) - desired_y
  desired_loc = [desired_x, desired_y]
  println("Place of Reflection: " , original_loc)
  println("New Desired Location: " , desired_loc)
  return desired_loc

end


function stickCell_x(original_loc, desired_loc)
  origin_x = original_loc[1]
  origin_y = original_loc[2]

  desired_x = desired_loc[1]
  desired_y = desired_loc[2]

  gradient = (desired_y - origin_y) / (desired_x - origin_x)
  offset = origin_y - (gradient * origin_x)

  if desired_x < 0
    desired_x = 0
  else
    desired_x = global_x
  end


  desired_y = (gradient * global_x) + offset

  return desired_x, desired_y

end

function stickCell_y(original_loc, desired_loc)
  origin_x = original_loc[1]
  origin_y = original_loc[2]

  desired_x = desired_loc[1]
  desired_y = desired_loc[2]

  gradient = (desired_y - origin_y) / (desired_x - origin_x)
  offset = origin_y - (gradient * origin_x)

  desired_x = global_y - offset / gradient

  if desired_y < 0
    desired_y = 0
  else
    desired_y = global_y
  end

  return desired_x, desired_y

end
