dir = pwd()
using Winston
include("$dir/propose_move.jl")
include("$dir/show_cells.jl")
include("$dir/pausing.jl")
#reload("$dir/propose_move.jl")
#reload("$dir/show_cells.jl")
using Propose_move
using Show_cells
using Pausing

#println("Enter X size of environment: ")
#x_size = int(readline(STDIN))
x_size = 5 #delete this later
#println("Enter Y size of environment: ")
#y_size = int(readline(STDIN))
#println("Enter amount of starting cells: ")
#cells = int(readline(STDIN))
#println("Enter proposed speed of cells: ")
#speed = float(readline(STDIN))
#println("Enter amount of timesteps: ")
#steps = int(readline(STDIN))
steps = 3 #delete this later

a = [2.0 2.0;2.0 2.0;2.0 2.0]
for i = 1:steps
  for i in 1:5
  a = propose_describe_move(a, 2.0)
  show_cells(a)
  pausing(false)
  end
end







