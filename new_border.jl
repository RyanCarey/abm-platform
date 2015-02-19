#wall_behaviour = ["r","a"]
#fc_behaviour = ["a","r"]

# still need to make border mutate the cell's angle
# still need to make another method that kills cells if they run off the field

function check_borders!(cell::Cell,
                        source::Point,
                        wall_behaviour::Array,
                        fc_behaviour::Array,
                        wall::Real,
                        ceil::Real)
  x = cell.x
  y = cell.y
  r = cell.r
  xi = source.x
  yi = source.y
  x,y,xi,yi = border(x,y,xi,yi,r,wall_behaviour,fc_behaviour,wall,ceil)
  cell.x, cell.y = x,y
  source = Point(xi,yi)
  println("final cell loc: ", cell.x,", ",cell.y)
  println("final cell loc within borders: ", (r < x < wall - 2) && (r < y < ceil - r))
end

function border(x::Real,
                y::Real,
                xi::Real,
                yi::Real,
                r::Real,
                wall_behaviour::Array,
                fc_behaviour::Array,
                wall::Real,
                ceil::Real)
  wall_lims = [0, wall] + [r,-r]
  fc_lims = [0, ceil] + [r,-r]

  wall_ints, wall_hit = find_wall_hit(x,y,xi,yi,wall_lims)
  if wall_hit > 0.5
    println("source: ",xi,", ",yi)
    println("target: ",x,", ",y)
    println("wall_ints: ",wall_ints)
    println("wall lims: ",wall_lims)
    println("wall hit: ",wall_hit)
    println("hits wall at ",wall_lims[wall_hit],", ",wall_ints[wall_hit])
    println("kind of collision: ",wall_behaviour[wall_hit])
    println("reflecting = ",wall_behaviour[wall_hit]=="reflecting")
    if wall_behaviour[wall_hit]=="reflecting"
      x,y = wall_reflect(x,y,xi,yi,wall_lims,wall_ints,wall_hit)
    elseif wall_behaviour[wall_hit]=="absorbing"
      x,y = wall_absorb(x,y,wall_lims,wall_ints,wall_hit)
    end
    println("target after wall interaction: ",x,", ",y)
  end

  fc_ints, fc_hit = find_fc_hit(x,y,xi,yi,fc_lims)
  if fc_hit > 0.5
    println("source: ",xi,", ",yi)
    println("target: ",x,", ",y)
    println("fc_ints: ",fc_ints)
    println("fc lims: ",fc_lims)
    println("fc hit: ",fc_hit)
    println("hits ceil/floor at ",fc_ints[fc_hit],", ",fc_lims[fc_hit])
    println("kind of collision: ",wall_behaviour[fc_hit])
    println("reflecting = ",wall_behaviour[fc_hit]=="reflecting")
    if fc_behaviour[fc_hit]=="reflecting"
      x,y = fc_reflect(x,y,xi,yi,fc_lims,fc_ints,fc_hit)
    elseif fc_behaviour[fc_hit]=="absorbing"
      x,y = fc_absorb(x,y,fc_lims,fc_ints,fc_hit)
    end
  end

  wall_ints, wall_hit = find_wall_hit(x,y,xi,yi,wall_lims)
  if wall_hit > 0.5
    println("source: ",xi,", ",yi)
    println("target: ",x,", ",y)
    println("hits wall at ",wall_lims[wall_hit],", ",wall_ints[wall_hit])
    println("wall_ints: ",wall_ints)
    println("wall lims: ",wall_lims)
    println("wall hit: ",wall_hit)
    println("kind of collision: ",wall_behaviour[wall_hit])
    println("reflecting = ",wall_behaviour[wall_hit]=="reflecting")
    if wall_behaviour[wall_hit]=="reflecting"
      x,y = wall_reflect(x,y,xi,yi,wall_lims,wall_ints,wall_hit)
    elseif wall_behaviour[wall_hit]=="absorbing"
      x,y = wall_absorb(x,y,wall_lims,wall_ints,wall_hit)
    end
  end
  return float(x),float(y), float(xi), float(yi)
end

function find_wall_hit(x::Real,
                       y::Real,
                       xi::Real,
                       yi::Real,
                       wall_lims::Array)
  # returns: wall_ints - where the line would hit the wall if current trajectory extended forward and back
  #          wall_hit - whether the current arc will actually hit the walls [left right]
  m = (y-yi)/(x-xi)
  wall_ints = yi + m * (wall_lims - xi)
  wall_in_move = ((xi .<= wall_lims .<= x) | (x .< wall_lims .< xi))
  wall_hit = findfirst((wall_lims[1] .<= wall_ints .<= wall_lims[2]) &  wall_in_move)
  return wall_ints,wall_hit
end

function find_fc_hit(x::Real,
                     y::Real,
                     xi::Real,
                     yi::Real,
                     fc_lims::Array)
  # returns: fc_ints - where the line would hit the [floor ceiling] if current trajectory extended up and down 
  #          fc_hit - whether the current arc will actually hit the [floor ceiling]
  m = (y-yi)/(x-xi)
  fc_ints = xi + (fc_lims - yi)/m  
  fc_in_move = (yi .<= fc_lims .<= y) | (y .< fc_lims .< yi)
  fc_hit = findfirst((fc_lims[1] .< fc_ints .< fc_lims[2]) & fc_in_move)
  return fc_ints,fc_hit
end

function wall_reflect(x::Real,
                      y::Real,
                      xi::Real,
                      yi::Real,
                      wall_lims::Array,
                      wall_ints::Array,
                      wall_hit::Int)
  x = 2 * wall_lims[wall_hit] - x
  xi, yi = wall_lims[wall_hit], wall_ints[wall_hit]
  println("new pos after wall reflect : ",x,", ",y)
  return float(x),float(y),float(xi),float(yi)
end

function fc_reflect(x::Real,
                    y::Real,
                    xi::Real,
                    yi::Real,
                    fc_lims::Array,
                    fc_ints::Array,
                    fc_hit::Int)
  y = 2 * fc_lims[fc_hit] - y
  xi, yi = fc_lims[fc_hit], fc_ints[fc_hit]
  println("new pos after fc reflect : ",x,", ",y)
  return float(x),float(y),float(xi),float(yi)
end

function wall_absorb(x::Real,
                     y::Real,
                     wall_lims::Array,
                     wall_ints::Array,
                     wall_hit::Int)
  println("absorbing collision")
  println("mean of lims: ",mean(wall_lims),", expected hit: ",wall_lims[wall_hit])
  x = wall_lims[wall_hit
       ] +.001 * (mean(wall_lims) - (wall_lims[wall_hit])) # move a fraction to the centre
  y = wall_ints[wall_hit]
  println("new pos : ",x,", ",y)
  return float(x),float(y)
end

function fc_absorb(x::Real,
                   y::Real,
                   fc_lims::Array,
                   fc_ints::Array,
                   fc_hit::Array)
  println("absorbing collision")
  x = fc_ints[fc_hit]
  println("mean of lims: ",mean(fc_lims),", expected hit: ",fc_lims[fc_hit])
  y = fc_lims[fc_hit
       ] +.001 * (mean(fc_lims) - (fc_lims[fc_hit])) # move a fraction to the centre
  println("new pos : ",x,", ",y)
  return float(x),float(y)
end

function kill_if_deserting(alive_cells,dead_cells,m, border)
  if (wall_behaviour[1] == "d") && alive_cells[m].x < walls[1] - r
    cell_death(alive_cells,dead_cells,m)
  end

  if (wall_behaviour[2] == "d") && alive_cells[m].x > walls[2] + r
    cell_death(alive_cells,dead_cells,m)
  end

  if (fc_behaviour[1] == "d") && alive_cells[m].x < fc[1] - r
    cell_death(alive_cells,dead_cells,m)
  end

  if (fc_behaviour[2] == "d") && alive_cells[m].x < fc[2] + r
    cell_death(alive_cells,dead_cells,m)
  end
end

