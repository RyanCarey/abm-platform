# include radius

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
    x, xi, yi, angle, speed = reflect_horizontal(x,y,xi,yi,angle,speed,intercept,limit)
    return x,y,xi,yi,angle,speed
  end
  hits, intercept, limit = hits_west(x,y,xi,yi,wlim,slim,nlim)
  if hits
    x, xi, yi, angle, speed = reflect_horizontal(x,y,xi,yi,angle,speed,intercept,limit)
    return x,y,xi,yi,angle,speed
  end
  hits, intercept, limit = hits_north(x,y,xi,yi,nlim,wlim,elim)
  if hits
    println("hits north")
    y, xi, yi, angle, speed = reflect_vertical(x,y,xi,yi,angle,speed,intercept,limit)
    return x,y,xi,yi,angle,speed
  end
  hits, intercept, limit = hits_south(x,y,xi,yi,slim,wlim,elim)
  if hits
    println("hits south")
    y, xi, yi, angle, speed = reflect_vertical(x,y,xi,yi,angle,speed,intercept,limit)
    return x,y,xi,yi,angle,speed
  end
  return x,y,xi,yi,angle,speed
end

function hits_east(x::Real,y::Real,xi::Real,yi::Real,elim::Real,slim::Real,nlim::Real)
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

function hits_west(x::Real,y::Real,xi::Real,yi::Real,wlim::Real,slim::Real,nlim::Real)
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

function hits_north(x::Real,y::Real,xi::Real,yi::Real,nlim::Real,wlim::Real,elim::Real)
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

function hits_south(x::Real,y::Real,xi::Real,yi::Real,slim::Real,wlim::Real,elim::Real)
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

distance(x::Real,y::Real,xi::Real,yi::Real) = sqrt((x-xi)^2 + (y-yi)^2)
