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

  global cell_speed = v[2]


  radius = v[3]
  avg_radius = radius
  const steps = int(v[4])
  global X_SIZE = v[5]
  global Y_SIZE = v[6]
  growth_rate = v[7]
  global DIE_THRESHOLD = v[8]
  global categories = [Category(v[9] * n_cell,"r",1,1,1,1,true,true,true),
              Category(v[10] * n_cell,"b",1,1,1,1,false,false,false),
              Category(v[11] * n_cell,"g",1,1,1,1,false,false,false),
              Category(v[12] * n_cell,"y",1,1,1,1,false,false,false)]

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

  global alive_cells = init(n_cell,avg_radius, categories)

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
    start_output(filename::String, t::String, v::Array, alive_cells::Array)
  end

  alive_cells, dead_cells = iter_sim(alive_cells, dead_cells, cell_speed, steps, avg_radius, growth_rate)
  println("simulation finished")
end

function iter_sim(alive_cells::Array, dead_cells::Array, cell_speed::Real, steps::Int, avg_radius::Real, growth_rate::Real)
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
#<<<<<<< HEAD
    	move_any!()
    	alive_cells = cell_growth!(alive_cells, index)
    	alive_cells = division_decision!(alive_cells, index, avg_radius)
##=======
#    	cell_died = move_cell_x!(alive_cells, dead_cells, index, cell_speed)
#    end
#    if !cell_died
##    	alive_cells = cell_growth!(alive_cells, index, growth_rate)
#    	alive_cells = division_decision!(alive_cells, index, avg_radius)
#>>>>>>> 284575dcab57ce2c88e33e39c199e21990ce2d58
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
