function show_sim(X::Array{Cell,1}, x_size::Real, y_size::Real)
  display_two(X, x_size, y_size)
  hold(true)
  hold(false)
end

function show_agents(X::Array, colour::String = "ro")
  locations = zeros(length(X),3)
  for i in 1:length(X)
  locations[i,:] = [X[i].x X[i].y X[i].r]
  end
  display_circles(locations, colour)
end

function display_circles(locations::Array, colour::String = "ro")
  x = locations[:, 1]
  y = locations[:, 2]
  # Radius is adjusted so that cells are displayed at correct size for any window
  r = locations[:, 3].*70/sqrt(y_size*X_SIZE)*max(X_SIZE/y_size,y_size/X_SIZE)^.10
  p = scatter(x,y,r,colour)
  xlim(0,X_SIZE)
  ylim(0,y_size)
  display(canvas,p)
end

# Displays four types of cells, using each cells radius and the colour specified by its type
function display_two(cells::Array{Cell,1}, x_size::Real, y_size::Real)
  locations1 = zeros(length(cells), 3)
  for i in 1 : length(cells)
    if cells[i].cell_type == 1
      locations1[i,:] = [cells[i].x cells[i].y cells[i].r]
    end
  end
  p1 = scatter(locations1[:, 1], locations1[:, 2], locations1[:, 3].*70/sqrt(y_size*x_size)
               *max(x_size/y_size,y_size/x_size)^.10, categories[1].colour)
  xlim(0, x_size)
  ylim(0, y_size)
  hold(true) 
  locations2 = zeros(length(cells), 3)
  for i in 1 : length(cells)
    if cells[i].cell_type == 2
      locations2[i,:] = [cells[i].x cells[i].y cells[i].r]
    end
  end
  p2 = scatter(locations2[:, 1], locations2[:, 2], locations2[:, 3].*70/sqrt(y_size*x_size)
               * max(x_size/y_size,y_size/x_size)^.10, categories[2].colour)
  hold(true)
  locations3 = zeros(length(cells), 3)
  for i in 1 : length(cells)
    if cells[i].cell_type == 3
      locations3[i,:] = [cells[i].x cells[i].y cells[i].r]
    end
  end
  p3 = scatter(locations3[:, 1], locations3[:, 2], locations3[:, 3].*70/sqrt(y_size*x_size)
               * max(x_size/y_size,y_size/x_size)^.10, categories[3].colour)
  hold(true)
  locations4 = zeros(length(cells), 3)
  for i in 1 : length(cells)
    if cells[i].cell_type == 4
      locations4[i,:] = [cells[i].x cells[i].y cells[i].r]
    end
  end
  p4 = scatter(locations4[:, 1], locations4[:, 2], locations4[:, 3].*70/sqrt(y_size*x_size)
               * max(x_size/y_size,y_size/x_size)^.10, categories[4].colour)
  hold(true)
  display(canvas, p1)
  display(canvas, p2)
  display(canvas, p3)
  display(canvas, p4)  
  hold(true)
end

#=
function display_two(locs::Array, bools::BitArray)
  print(" locs: ",locs)
  print(" bools: ",bools)
  if sum(bools) > 0
    x = locs[:,1][bools]
    println("x: ",x)
    y = locs[:,2][bools]
    println("y: ",y)
    r = locs[:,3][bools]
    println("r: ",r)
    p = scatter(x,y,r/X_SIZE.*70,"ro")
    xlim(0,X_SIZE)
    ylim(0,Y_SIZE)
    display(p)
    hold(true)
  end
  if sum(bools) < length(bools)
    xx = locs[:,1][!bools]
    println("xx: ",xx)
    yy = locs[:,2][!bools]
    println("yy: ",yy)
    rr = locs[:,3][!bools]
    q = scatter(xx,yy,5*rr,"bo")
    xlim(0,X_SIZE)
    ylim(0,Y_SIZE)
    display(q)
    hold(false)
  end
end
=#

