dir = pwd()
using Winston
include("$dir/init.jl")
include("$dir/propose_move.jl")
include("$dir/show_cells.jl")
include("$dir/pausing.jl")
include("$dir/optional_arg.jl")
#reload("$dir/propose_move.jl")
#reload("$dir/show_cells.jl")
using Init
using Propose_move
using Show_cells
using Pausing
using Optional_arg


cells = int(optional_arg(1,"Enter initial number of cells: "))
cell_speed = float(optional_arg(2,"Enter speed of cells: "))
cell_radius = float(optional_arg(3,"Enter radius of cells: "))
const steps = int(optional_arg(4,"Enter number of timesteps: "))
const x_size = int(optional_arg(5,"Enter width of environment: "))
const y_size = int(optional_arg(6,"Enter height of environment: "))


println("building environment")
a = init(cells,x_size,y_size,cell_radius) 
show_cells(a,x_size,y_size)
println("press any key to go")
junk = readline(STDIN)
for i = 1:steps
  a = propose_move_one(a, cell_speed)
  show_cells(a,x_size,y_size)
  pausing(false)
end







