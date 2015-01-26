using Winston
include("init.jl")
include("move.jl")
include("show.jl")
include("pause.jl")
include("optional_arg.jl")
include("diffusion.jl")


function main()
  println("recieved entry")

  n_cell = int(v[1])
  cell_speed = v[2]
  radius = v[3]
  const steps = int(v[4])
  global x_size = v[5]
  global y_size = v[6]
  const diffusion_rate = .1

  # at this stage, it's silly to have different height and width because it won't be graphed correctly
  csv_output = true

  println("building environment")
  conc_map = init_diffusion(x_size,y_size)
  X = init(n_cell,x_size,y_size,radius) 
  show_agents(X, x_size, y_size)


  #if csv_output
    #t = strftime(time())[5:27] #store date and time as string
    #file = "out_$t.txt"
    # should also print diffusion parameter
    #start_output(file, t, cell_speed, radius, conc_map, X, diffusion_rate)
  #end

  for i = 1:steps
    diffusion!(conc_map,diffusion_rate) # turn diffusion on or off
    move_any!(conc_map, X, cell_speed)
    show_agents(X, x_size, y_size)
    
    # for speed, it will be necessary to batch these outputs in groups of 100
    #if csv_output
      #j = [repmat([i],size(X,1),1) X[:,1:2] X[:,5]]
      #csv_out(file,j)
    #end
  pause(0.2)
  end
end

