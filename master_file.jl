using Winston
using Dates
include("init.jl")
include("move.jl")
include("show_cells.jl")
include("await_user.jl")
include("optional_arg.jl")
include("diffusion.jl")

file = "output.txt"
cells = int(optional_arg(1,"Enter initial number of cells: "))
cell_speed = float(optional_arg(2,"Enter speed of cells: "))
radius = float(optional_arg(3,"Enter radius of cells: "))
const steps = int(optional_arg(4,"Enter number of timesteps: "))
const x_size = float(optional_arg(5,"Enter width of environment: "))
const y_size = float(optional_arg(6,"Enter height of environment: "))
# at this stage, it's silly to have different height and width because it won't be graphed correctly

println("building environment")
conc_map = init_diffusion(x_size,y_size)
X = init(cells,x_size,y_size,radius) 

show_cells(X, x_size, y_size)
println("press any key to go")
junk = readline(STDIN)

t = strftime(time())
csv_out(file,"$t,$cells,$cell_speed,$radius,$steps,$x_size,$y_size\n")
for i = 1:steps
  diffusion!(conc_map,.1) # turn diffusion on or off
  move_any!(conc_map, X, cell_speed)
  show_cells(X, x_size, y_size)
  csv_out(file,"iteration $i concentration map\n")
  csv_out(file,conc_map)
  csv_out(file,"iteration $i position matrix\n")
  csv_out(file,X)
  await_user(.002)
end


