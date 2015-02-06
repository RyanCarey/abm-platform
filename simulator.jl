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
  global const source_abscisse_ligand=v[9]
  global const source_ordinate_ligand=v[10]
  global const probability_persistent=v[11]
  global const Diffusion_coefficient = v[12]
  global const A_coefficient= v[13]
  global const tau0= v[14]
  global const nb_ligands= int(v[15])
  

  println("building environment")
  alive_cells = init(n_cell,radius)
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
    move_any!(alive_cells, cell_speed)
    alive_cells, dead_cells = life_or_death(alive_cells, dead_cells)
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
    #pause(0.0001)
  end
  return alive_cells, dead_cells
end
