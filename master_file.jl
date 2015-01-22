using Winston
include("init.jl")
include("move.jl")
include("show.jl")
include("pause.jl")
include("optional_arg.jl")
include("diffusion.jl")

n_cell = int(optional_arg(1,"Enter initial number of cells: "))
cell_speed = float(optional_arg(2,"Enter speed of cells: "))
radius = float(optional_arg(3,"Enter radius of cells: "))
const steps = int(optional_arg(4,"Enter number of timesteps: "))
const x_size = float(optional_arg(5,"Enter width of environment: "))
const y_size = float(optional_arg(6,"Enter height of environment: "))
const diffusion_rate = .1
# at this stage, it's silly to have different height and width because it won't be graphed correctly
csv_output = true

println("building environment")
conc_map = init_diffusion(x_size,y_size)
X = init(n_cell,x_size,y_size,radius) 
show_agents(X, x_size, y_size)
println("press any key to go")
junk = readline(STDIN)


#if csv_output
  #t = strftime(time())[5:27] #store date and time as string
  #file = "out_$t.txt"
  # should also print diffusion parameter
  #start_output(file, t, cell_speed, radius, conc_map, X, diffusion_rate)
#end

for i = 1:steps
  diffusion!(conc_map,diffusion_rate) # turn diffusion on or off
  move_any!(conc_map, X, cell_speed)
  #show_agents(X, x_size, y_size)
  
  # for speed, it will be necessary to batch these outputs in groups of 100
  #if csv_output
    #j = [repmat([i],size(X,1),1) X[:,1:2] X[:,5]]
    #csv_out(file,j)
  #end
  #pause(.002)
end


