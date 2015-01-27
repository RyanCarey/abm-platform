using Winston
include("init.jl")
include("move.jl")
include("show.jl")
include("pause.jl")
include("diffusion.jl")
include("birth_and_death.jl")
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
  const diffusion_rate = 1.0

  # at this stage, it's silly to have different height and width because it won't be graphed correctly

  println("building environment")
  conc_map = init_diffusion()
  alive_cells = init(n_cell,radius)
  dead_cells = Cell[]
  if DISPLAY_OUTPUT
    show_agents(conc_map,alive_cells)
  end

  if TXT_OUTPUT
    t = strftime(time())[5:27] #store date and time as string
    file = "out_$t.txt"
    start_output(file, t, v, conc_map, alive_cells, diffusion_rate)
  end

  for i = 1:steps
    if i % 20 == 0
      println("$i iterations completed")
    end
    diffusion!(conc_map,diffusion_rate) # turn diffusion on or off
		alive_cells, dead_cells = life_or_death(alive_cells, dead_cells)
    move_any!(conc_map, alive_cells, cell_speed)
    if DISPLAY_OUTPUT
      show_agents(conc_map,alive_cells)
    end
    
    # for speed, it will be necessary to batch these outputs in groups of 100
    if TXT_OUTPUT
      csv_out(file, alive_cells, dead_cells)
    end
  pause(0.01)
  end
  println("simulation finished")
end
