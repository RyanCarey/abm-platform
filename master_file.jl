dir = pwd()
include("$dir/propose_move.jl")
using Propose_move
include("$dir/display.jl")
using Display


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

a = [0.0 0.0;0.0 0.0;0.0 0.0]
for i = 1:steps
  for i in 1:5
  a = propose_describe_move(a, 2.0)
  display(a) 
  end
end

