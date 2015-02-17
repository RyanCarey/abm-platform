using Winston

include("init.jl")
include("move.jl")
include("show.jl")
include("pause.jl")
include("diffusion.jl")
include("birth_and_death.jl")
include("cell_type.jl")
include("cell_growth.jl")
#include("pickle.jl")

function main()
  n_cell = int(v[1])
  const steps = int(v[2])
  global X_SIZE = v[3]
  global Y_SIZE = v[4]
  walls = [0,X_SIZE]
  fc = [0,Y_SIZE]
  global STEM_THRESHOLD = v[5]
  global DIE_THRESHOLD = v[6]
  global categories = Cell_type[Cell_type(v8[1], v8[2], v8[3], v8[4], v8[5], v8[6], v9[1], v9[2], v9[3]),
              Cell_type(v8[7], v8[8], v8[9], v8[10], v8[11], v8[12], v9[4], v9[5], v9[6]),
              Cell_type(v8[13], v8[14], v8[15], v8[16], v8[17], v8[18], v9[7], v9[8], v9[9]),
              Cell_type(v8[19], v8[20], v8[21], v8[22], v8[23], v8[24], v9[10], v9[11], v9[12])]

  global const probability_persistent=v2[1]
  global const nb_ligands= int(v2[2])
  global RANDOMNESS = v2[3]
  global const nb_source= int(v2[7])

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
  global alive_cells = init(n_cell, categories)
  global dead_cells = Cell[]

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
    start_output(filename::String, t::String, v::Array, alive_cells::Array)
  end

  alive_cells, dead_cells = iter_sim(alive_cells, dead_cells, steps,walls,fc)
  println("simulation finished")
end

function iter_sim(alive_cells::Array, dead_cells::Array, steps::Int,walls,fc)
  global iter
  for i = 1:steps
    iter = i
    if length(alive_cells) == 0
      println("All cells have died after $i iterations")
      return alive_cells, dead_cells 
    end

    index = rand(1 : length(alive_cells))
    # Does all cell functions
    # First checks to see if the cell dies; if not, it moves, grows, and if necessary divides
    cell_died = false
    alive_cells, dead_cells, cell_died = chance_to_die(alive_cells, dead_cells, index)
    if !cell_died
    	move_any!(wall_behaviour,fc_behaviour,walls,fc)
    #end
    #if !cell_died
    	alive_cells = cell_growth!(alive_cells, index)

    	alive_cells = division_decision!(alive_cells, index)
    end

    if DISPLAY_OUTPUT
      show_sim(alive_cells)
    end
    # for speed, it will be necessary to batch these outputs in groups of 100+
    if TXT_OUTPUT
      ## call pickle output here
    end
    if i % 1000 == 0
      println("$i iterations completed")
    end
    #pause(0)
  end
  return alive_cells, dead_cells
end
