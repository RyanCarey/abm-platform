using Winston
include("init.jl")
include("move.jl")
include("show.jl")
include("pause.jl")
include("optional_arg.jl")
include("diffusion.jl")
include("cell_division.jl")
include("cell_type.jl")



function main()
  n_cell = int(v[1])
  cell_speed = v[2]
  radius = v[3]
  const steps = int(v[4])
  global X_SIZE = v[5]
  global Y_SIZE = v[6]
  global DIVIDE_THRESHOLD = v[7]
  global DIE_THRESHOLD = v[8]
  const diffusion_rate = .1

  # at this stage, it's silly to have different height and width because it won't be graphed correctly
  CSV_OUTPUT = true

  println("building environment")
  conc_map = init_diffusion(X_SIZE,Y_SIZE)
  alive_cells = init(n_cell,X_SIZE,Y_SIZE,radius)
  dead_cells = Cell[]
  show_agents(alive_cells, X_SIZE, Y_SIZE)

  if CSV_OUTPUT
    t = strftime(time())[5:27] #store date and time as string
    file = "out_$t.txt"
    start_output(file, t, v, conc_map, alive_cells, diffusion_rate)
  end

  for i = 1:steps
    diffusion!(conc_map,diffusion_rate) # turn diffusion on or off
		n = length(alive_cells)
		i = rand(1:n)
		alive_cells, dead_cells = life_or_death(alive_cells, dead_cells, i)
    move_any!(conc_map, alive_cells, cell_speed)
    show_agents(alive_cells, X_SIZE, Y_SIZE)
    
    #for speed, it will be necessary to batch these outputs in groups of 100
    if CSV_OUTPUT
      csv_out(file, alive_cells, dead_cells)
    end
  pause(0.01)
  end
  println("simulation finished")
end

