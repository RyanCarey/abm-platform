using Winston
include("init.jl")
include("move.jl")
include("show.jl")
include("pause.jl")
include("optional_arg.jl")
include("diffusion.jl")
include("cell_division.jl")
include("cell_type.jl")

global DIVIDE_THRESHOLD = 0.1
global DIE_THRESHOLD = 0.01


function main()
  n_cell = int(v[1])
  cell_speed = v[2]
  radius = v[3]
  const steps = int(v[4])
  global X_SIZE = v[5]
  global Y_SIZE = v[6]
  const diffusion_rate = .1

  # at this stage, it's silly to have different height and width because it won't be graphed correctly
  csv_output = true

  println("building environment")
  conc_map = init_diffusion(X_SIZE,Y_SIZE)
  alive_cells = init(n_cell,X_SIZE,Y_SIZE,radius)
  dead_cells = Cell[]
  show_agents(alive_cells, X_SIZE, Y_SIZE)


  #if csv_output
    #t = strftime(time())[5:27] #store date and time as string
    #file = "out_$t.txt"
    # should also print diffusion parameter
    #start_output(file, t, cell_speed, radius, conc_map, X, diffusion_rate)
  #end

  for i = 1:steps
    diffusion!(conc_map,diffusion_rate) # turn diffusion on or off
		n = length(alive_cells)
		i = rand(1:n)
		alive_cells, dead_cells = life_or_death(alive_cells, dead_cells, i, DIVIDE_THRESHOLD, DIE_THRESHOLD)
    move_any!(conc_map, alive_cells, cell_speed)
    show_agents(alive_cells, X_SIZE, Y_SIZE)
    
    # for speed, it will be necessary to batch these outputs in groups of 100
    #if csv_output
      #j = [repmat([i],size(X,1),1) X[:,1:2] X[:,5]]
      #csv_out(file,j)
    #end
  pause(0.1)
  end
end

