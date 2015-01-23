using Winston
include("init.jl")
include("move.jl")
include("show.jl")
include("pause.jl")
include("optional_arg.jl")
include("diffusion.jl")
include("entry.jl")

recieved_entry = false
while !recieved_entry
  recieved_entry, v = init_window()
end

n_cell = int(v[1])
cell_speed = v[2]
radius = v[3]
const steps = int(v[4])
const x_size = v[5]
const y_size = v[6]
print(n_cell,cell_speed,"number of cells and cell speed")

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
  show_agents(X, x_size, y_size)
  
  # for speed, it will be necessary to batch these outputs in groups of 100
  #if csv_output
    #j = [repmat([i],size(X,1),1) X[:,1:2] X[:,5]]
    #csv_out(file,j)
  #end
  pause(0)
end


