using Winston

function show_sim(X::Array)
  #show_agents(X)
  display_two(X)
  hold(true)
  #display(canvas,plot(ones(int(Y_SIZE)+1,1).*source_abscisse_ligand,[0:1:int(Y_SIZE)]))
  if BORDER_SHAPE == "Ellipse"
    show_elliptical_border()
  end
  hold(false)
end

function show_agents(X::Array,colour = "ro")
  locations = zeros(length(X),3)
  for i in 1:length(X)
  locations[i,:] = [X[i].loc.x X[i].loc.y X[i].r]
  end
  display_circles(locations, colour)
end

function display_circles(locations::Array, colour = "ro")
  x = locations[:, 1]
  y = locations[:, 2]
  # radius is adjusted so that cells are displayed at correct size for any window
  r = locations[:, 3].*70/sqrt(Y_SIZE*X_SIZE)*max(X_SIZE/Y_SIZE,Y_SIZE/X_SIZE)^.10
  p = scatter(x,y,r,colour)
  xlim(0,X_SIZE)
  ylim(0,Y_SIZE)
  display(canvas,p)
end

function show_elliptical_border()
  show_ellipse(X_SIZE/2,Y_SIZE/2,X_SIZE/2,Y_SIZE/2)
end

function show_ellipse(c::Real,d::Real,a::Real,b::Real,n=72)
  t = [0:1/n:1]*2pi
  X = [c+a*cos(t) d+b*sin(t)]
  r = plot(X[:,1],X[:,2])
  display(canvas,r)
end

# for showing two sets of cells in different colours
function display_cell_sets(X::Array, bools::BitArray)
  locations = zeros(length(X),3)
  for i in 1:length(X)
    locations[i,:] = [X[i].loc.x X[i].loc.y X[i].r]
  end
  display_two(locations,bools)
end


function display_two(cells::Array)
  
  locations1 = zeros(length(cells), 3)
  for i in 1 : length(cells)
    if cells[i].category == 1
      locations1[i,:] = [cells[i].loc.x cells[i].loc.y cells[i].r]
    end
  end
  p1 = scatter(locations1[:, 1], locations1[:, 2], locations1[:, 3].*70/sqrt(Y_SIZE*X_SIZE)*max(X_SIZE/Y_SIZE,Y_SIZE/X_SIZE)^.10, "ro")
  xlim(0, X_SIZE)
  ylim(0, Y_SIZE) 

  hold(true) 
  
  locations2 = zeros(length(cells), 3)
  for i in 1 : length(cells)
    if cells[i].category == 2
      locations2[i,:] = [cells[i].loc.x cells[i].loc.y cells[i].r]
    end
  end
  p2 = scatter(locations2[:, 1], locations2[:, 2], locations2[:, 3].*70/sqrt(Y_SIZE*X_SIZE)*max(X_SIZE/Y_SIZE,Y_SIZE/X_SIZE)^.10, "bo")
  hold(true)
  locations3 = zeros(length(cells), 3)
  for i in 1 : length(cells)
    if cells[i].category == 3
      locations3[i,:] = [cells[i].loc.x cells[i].loc.y cells[i].r]
    end
  end
  p3 = scatter(locations3[:, 1], locations3[:, 2], locations3[:, 3].*70/sqrt(Y_SIZE*X_SIZE)*max(X_SIZE/Y_SIZE,Y_SIZE/X_SIZE)^.10, "mo")
  hold(true)
  locations4 = zeros(length(cells), 3)
  for i in 1 : length(cells)
    if cells[i].category == 4
      locations4[i,:] = [cells[i].loc.x cells[i].loc.y cells[i].r]
    end
  end
  p4 = scatter(locations4[:, 1], locations4[:, 2], locations4[:, 3].*70/sqrt(Y_SIZE*X_SIZE)*max(X_SIZE/Y_SIZE,Y_SIZE/X_SIZE)^.10, "go")
  hold(true)
  display(canvas, p1)
  display(canvas, p2)
  display(canvas, p3)
  display(canvas, p4)
  
  hold(true)
end

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

# text output
function csv_out(filename::String,output::String)
  f = open(filename,"a")
  write(f,output)
  close(f)
end

function csv_out(filename::String, alive_cells::Array, dead_cells::Array)
  f = open(filename,"a")
  write(f, "> New Time Step\n")
  for i in 1:size(alive_cells,1)
    write(f,string(alive_cells[i])[6:end-1],"\n")
  end
  close(f)
end

function start_output(filename::String, t::String, v::Array, conc_map::Array, alive_cells::Array, diffusion_rate::Float64)
  f = open(filename,"a")
  write(f, "> Time, Diffusion Rate\n")
  write(f, "> $t,$diffusion_rate\n")
  write(f, ">", string(join(prompts,","),"\n"))
  write(f, ">", string(join(v,","),"\n"))
  write(f, "> Starting Concentration Map\n")
  write(f, array_to_string(conc_map))
  write(f, "\n")
  write(f, ">Starting Cell Matrix\n")
  for i in 1:size(alive_cells,1)
    write(f, string(alive_cells[i])[6:end-1],"\n")
  end
  write(f, "> Subsequent Cell Matrices\n")
  close(f)
end

function array_to_string(X::Array)
  rows_as_strings = repmat([""],size(X,1),1)
  for i in 1:size(X,1)
    rows_as_strings[i] = join(X[i,:],",")
  end
  join(rows_as_strings,"\n")
end

