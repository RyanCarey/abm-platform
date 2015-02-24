# include radius

function put_at_border!(n::Int,source::Point)
  x = alive_cells[n].x
  y = alive_cells[n].y
  angle = alive_cells[n].angle
  speed = alive_cells[n].speed
  xi = source.x
  yi = source.y
  println("start x: ", alive_cells[n].x, ", start y: ",alive_cells[n].y)
  x, y, xi, yi, angle, speed = check_borders(x,y,xi,yi,angle,
                                             speed,0.,0.,X_SIZE,Y_SIZE,border_settings)
  alive_cells[n].x = x
  alive_cells[n].y = y
  alive_cells[n].angle = angle
  alive_cells[n].speed = speed
  println("cells after border check: ", alive_cells)
  if !((0 <= alive_cells[n].x <= X_SIZE) && (0 <= alive_cells[n].y <= Y_SIZE))
    println("out of bounds")
    println("desired cell location: ",alive_cells[n])
    println("source: ", source)
    quit()
  end
  return Point(xi,yi)
end


function check_borders(x::Real,
                       y::Real,
                       xi::Real,
                       yi::Real,
                       angle::Real,
                       speed::Real,
                       wlim::Real,
                       slim::Real,
                       elim::Real,
                       nlim::Real,
                       settings::Array)
  x,y, xi, yi, angle, speed = check_borders_iter(x,y,xi,yi, angle, speed, wlim, slim, elim, nlim, settings)
  x,y, xi, yi, angle, speed = check_borders_iter(x,y,xi,yi, angle, speed, wlim, slim, elim, nlim, settings)
  return x,y,xi,yi,angle,speed
end

function check_borders_iter(x::Real,
                            y::Real,
                            xi::Real,
                            yi::Real,
                            angle::Real,
                            speed::Real,
                            wlim::Real,
                            slim::Real,
                            elim::Real,
                            nlim::Real,
                            settings::Array)
  hits, intercept, limit = hits_east(x,y,xi,yi,elim,slim,nlim)
  if hits
    x, xi, yi, angle, speed = reflect_horizontal(x,y,xi,yi,angle,speed,intercept,limit,settings[1])
    return x,y,xi,yi,angle,speed
  end
  hits, intercept, limit = hits_west(x,y,xi,yi,wlim,slim,nlim)
  if hits
    x, xi, yi, angle, speed = reflect_horizontal(x,y,xi,yi,angle,speed,intercept,limit,settings[2])
    println("after reflection x: ",x,", y: ",y,", xi: ",xi," yi: ",yi)
    return x,y,xi,yi,angle,speed
  end
  hits, intercept, limit = hits_north(x,y,xi,yi,nlim,wlim,elim)
  if hits
    println("hits north")
    y, xi, yi, angle, speed = reflect_vertical(x,y,xi,yi,angle,speed,intercept,limit,settings[3])
    println("after reflection x: ",x,", y: ",y,", xi: ",xi," yi: ",yi)
    return x,y,xi,yi,angle,speed
  end
  hits, intercept, limit = hits_south(x,y,xi,yi,slim,wlim,elim)
  if hits
    println("hits south")
    y, xi, yi, angle, speed = reflect_vertical(x,y,xi,yi,angle,speed,intercept,limit,settings[4])
    println("after reflection x: ",x,", y: ",y,", xi: ",xi," yi: ",yi)
    return x,y,xi,yi,angle,speed
  end
  return x,y,xi,yi,angle,speed
end

function hits_east(x::Real,y::Real,xi::Real,yi::Real,elim::Real,slim::Real,nlim::Real, setting)
  if x - xi > 0 
    m = (y-yi)/(x-xi)
    efar = x >= elim
    eint = yi + m*(elim-xi)
    etargeting = slim <= eint <= nlim
    hits = efar && etargeting
    return hits, eint, elim
  else
    return false, nothing, nothing
  end
end

function hits_west(x::Real,y::Real,xi::Real,yi::Real,wlim::Real,slim::Real,nlim::Real,setting)
  if x - xi < 0
    m = (y-yi)/(x-xi)
    wfar = x <= wlim
    wint = yi + m*(wlim-xi)
    wtargeting = slim <= wint <= nlim
    hits = wfar && wtargeting
    return hits, wint, wlim
  else
    return false, nothing, nothing
  end
end

function hits_north(x::Real,y::Real,xi::Real,yi::Real,nlim::Real,wlim::Real,elim::Real,setting)
  if y - yi > 0
    m = (y-yi)/(x-xi) # may equal Inf or -Inf
    nfar = y >= nlim
    nint = (nlim-yi)/m + xi
    ntargeting = wlim <= nint <= elim
    hits = nfar && ntargeting
    return hits, nint, nlim 
  else
    return false, nothing, nothing
  end
end

function hits_south(x::Real,y::Real,xi::Real,yi::Real,slim::Real,wlim::Real,elim::Real,setting)
  if y - yi < 0
    m = (y-yi)/(x-xi) # may equal Inf or -Inf
    sfar = y <= slim
    sint = (slim-yi)/m + xi
    stargeting = wlim <= sint <= elim
    hits = sfar && stargeting
    return hits, sint, slim
  else
    return false, nothing, nothing
  end
end

function reflect_horizontal(x::Real,y::Real,xi::Real,yi::Real,angle::Real,speed::Real,intercept::Real,lim::Real)
  speed = distance(x,y,xi,yi) - distance(xi,yi,lim,intercept)
  x = 2 * lim - x
  angle = pi - angle
  xi = lim
  yi = intercept
  return x, xi, yi, angle, speed 
end

function reflect_vertical(x::Real,y::Real,xi::Real,yi::Real,angle::Real,speed::Real,intercept::Real,lim::Real)
  speed = distance(x,y,xi,yi) - distance(xi,yi,intercept,lim)
  y = 2 * lim - y
  angle = - angle
  xi = intercept
  yi = lim
  return y, xi, yi, angle, speed
end

function absorb_horizontal(x::Real,y::Real,xi::Real,yi::Real,angle::Real,speed::Real,intercept::Real,opplim::Real,lim::Real)
  speed = 0
  x = lim + .001(mean(opplim,lim) - x)  # move a fraction toward the centre
  angle = pi - angle
  xi = lim
  yi = intercept
  return y, xi, yi, angle, speed
end

function absorb_vertical(x::Real,y::Real,xi::Real,yi::Real,angle::Real,speed::Real,intercept::Real,opplim::Real,lim::Real)
  speed = 0
  y = lim + .001(mean(opplim,lim) - x)  # move a fraction toward the centre
  angle = - angle
  xi = intercept
  yi = lim
  return y, xi, yi, angle, speed
end

function kill_if_wandering(m)
  r = alive_cell[m].r
  wlim = -r
  elim = X_SIZE - r
  slim = -r
  nlim = Y_SIZE - r
  killed_wanderer = false
  if !((wlim <= alive_cells[m].x <= elim) && (slim <= alive_cells[m].y <= nlim))
    cell_death(alive_cells, dead_cells, m)
    killed_wanderer = true
  end
  return killed_wanderer
end

# for move
function blah()
  put_at_border()
  killed = kill_if_wandering
  if !killed
    nothing
  end
end

# inside hits south
function pick response()
  if setting = "r"
    reflect_horizontal(x,y,xi,yi,angle,speed,intercept,lim)
  elseif setting = "a"
    reflect_vertical(x,y,xi,yi,angle,speed,intercept,lim)
  elseif setting = "k"
    nothing
  end
end



distance(x::Real,y::Real,xi::Real,yi::Real) = sqrt((x-xi)^2 + (y-yi)^2)
