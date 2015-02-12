using Winston

include("init.jl")
include("move.jl")
include("show.jl")
include("pause.jl")
include("diffusion.jl")
include("birth_and_death.jl")
include("cell_type.jl")
include("cell_growth.jl")



function main()
  n_cell = int(v[1])
  cell_speed = v[2]

  radius = v[3]
  global AVG_RADIUS = radius
  const steps = int(v[4])
  global X_SIZE = v[5]
  global Y_SIZE = v[6]
  global GROWTH_RATE = v[7]
  global DIE_THRESHOLD = v[8]
  global RANDOMNESS = v[9]
  global const probability_persistent=v2[1]
  global const nb_ligands= int(v2[2])
  println("nb ligands: ", nb_ligands)
  global const nb_source= int(v2[6])

  global source_abscisse_ligand =[]
  global source_ordinate_ligand =[]
  global Diffusion_coefficient = []
  global A_coefficient= []
  global tau0 = []

  for i in 1:nb_source
	source_abscisse_ligand=[source_abscisse_ligand,v3[2*i-1]]
	source_ordinate_ligand=[source_ordinate_ligand,v3[2*i]]
	Diffusion_coefficient = [Diffusion_coefficient,v4[3*i-2]]
  A_coefficient = [A_coefficient,v4[3*i-1]]
	tau0 = [tau0,v4[3*i]]
  
  end
  

  println("building environment")
  alive_cells = init(n_cell,AVG_RADIUS)
  dead_cells = Cell[]

  if DISPLAY_OUTPUT
    canvas[:height] = 400
    canvas[:width] = 400 * X_SIZE/Y_SIZE
    w[:width] = 400 + int(canvas[:width])
    pack(frame, expand=true, fill="both")
    show_sim(alive_cells)
  end

  if TXT_OUTPUT
    t = strftime(time())[5:27] #store date and time as string
    file = "out_$t.txt"
    start_output(file, t, v, conc_map, alive_cells, diffusion_rate)
  end

  alive_cells, dead_cells = iter_sim(alive_cells, dead_cells, cell_speed, steps)
  println("simulation finished")
end

function iter_sim(alive_cells::Array, dead_cells::Array, cell_speed::Real, steps::Int)
  global iter
  for i = 1:steps
    iter = i
    if length(alive_cells) == 0
      println("all cells have died after $i iterations")
      return alive_cells, dead_cells 
    end

    index = rand(1 : length(alive_cells))
    # Does all cell functions
    cell_died = false
    alive_cells, dead_cells, cell_died = chance_to_die(alive_cells, dead_cells, index)
    if !cell_died
    	move_cell_x!(alive_cells, index, cell_speed)
    	alive_cells = cell_growth!(alive_cells, index)
    	alive_cells = division_decision!(alive_cells, index)
    end


    if DISPLAY_OUTPUT
      show_sim(alive_cells)
    end
    # for speed, it will be necessary to batch these outputs in groups of 100+
    if TXT_OUTPUT
      csv_out(file, alive_cells, dead_cells)
    end
    if i % 1000 == 0
      println("$i iterations completed")
    end
    #pause(0)
  end
  return alive_cells, dead_cells
end
