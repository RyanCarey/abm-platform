dir = pwd()
using Winston
include("$dir/init.jl")
include("$dir/propose_move.jl")
include("$dir/show_cells.jl")
include("$dir/pausing.jl")
#reload("$dir/propose_move.jl")
#reload("$dir/show_cells.jl")
using Init
using Propose_move
using Show_cells
using Pausing

#println("Enter X size of environment: ")
#x_size = int(readline(STDIN))
const x_size = 25 #delete this later
const y_size = 25 #delete this hard-coded part later
#println("Enter Y size of environment: ")
#y_size = int(readline(STDIN))
println("Enter amount of starting cells: ")
cells = int(readline(STDIN))
#println("Enter proposed speed of cells: ")
#speed = float(readline(STDIN))
speed = 3.0 #delete this hard-coded part later
#println("Enter amount of timesteps: ")
#steps = int(readline(STDIN))
steps = 100 #delete this later

cell_radius = 1 #radius is hardcoded here

a = init(cells,x_size,y_size,cell_radius) 
show_cells(a,x_size,y_size)
println("press any key to go")
junk = readline(STDIN)
for i = 1:steps
  a = propose_describe_move(a, speed)
  show_cells(a,x_size,y_size)
  pausing(false)
end







