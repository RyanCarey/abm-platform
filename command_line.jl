include("import_no_gui.jl")


function run_simulation(nb_iteration::Int64)

#The user can manually change the parameters below
#####################################################################################################################################################
#Parameters from the first window:
number_of_cell = 10
number_of_steps = 1000
environment_width = 30
environment_height = 30
bouncing_energy_loss_coefficient = 0.9 #(0-1)
type_of_diffusion = "Integrative" #"Integrative" or "Normal"
pickle_output = false
border_settings = ["Reflecting", "Relfecting", "Reflecting", "Reflecting"] # Border Settings can be: "Reflecting", "Absorbing", "Removing".


#Parameters from the diffusion window:
number_of_ligand_receptors = 8 #
number_of_sources = 1
type_of_source = "Line" #"Line" or "Point"


#Choice of source parameters (coefficients and locations)

#Array initialization: each row (of the table made by the following parameters) corresponds to a particular source
x_ordinate_sources = Array(Float64, number_of_sources)
y_ordinate_sources = Array(Float64, number_of_sources)
normal_gradient_coefficient = Array(Float64, number_of_sources)
normal_initial_concentration_coefficient = Array(Float64, number_of_sources)
integrative_gradient_coefficient = Array(Float64, number_of_sources)
integrative_initial_concentration_coefficient = Array(Float64, number_of_sources)
intgerative_upper_time_limit = Array(Float64, number_of_sources)

#The user needs to give manually the parameter. We nevertheless provide a initializiation for the coeeficients parameters given the type of source, 
#the number of source and the type of diffusion. The locations of the sources need to be changed manually. They are initialized at 0
#First case : type_of_source="Line"
if(type_of_diffusion == "Integrative")
  for i in 1 : number_of_sources
    x_ordinate_sources[i] = 0
    y_ordinate_sources[i] = 0
    integrative_gradient_coefficient[i] = 1
    integrative_initial_concentration_coefficient[i] = 100
    intgerative_upper_time_limit[i] = 10
  end
elseif(type_of_diffusion == "Normal")
  for i in 1 : number_of_sources
    x_ordinate_sources[i] = 0
	  y_ordinate_sources[i] = 0
  	normal_gradient_coefficient[i] = 1
  	normal_initial_concentration_coefficient[i] = 100
  end
end


# Choice of the cell characteristics

# The user needs to change manually the paramaters for every kind of cells found in the following table
# 1st row: Percentage of presence of this particular kind of cell at the beggining
# 2nd row: Growth rate at each step
# 3rd row: Ratio of current area to average area at which cells will divide.
# 4th row: Average speed for this particular kind of cell
# 5th row: Average radius for this particular kind of cell
# 6th row: Factor that multiplies cells preferred movement due to ligand concentration. [-1, 1], with 1 being attraction and -1 being repulsion.
# 7th row: Threshold for which any concentration higher will form a functional stem cell niche.
# 8th row: Death rate for this particular kind of cell
# 9th row: Persistence parameter for this particular kind of cell
# 10th row: Randomness parameter in the choice of the angle
# 11th row: Speed threshold that the cell needs to exceed to trigger a bouncing with another cell
# 12th row: Threshold that the ratio of the maximum concentration around the cell divided by the mean concentration around the cell need to exceed to make the cell choose accurately its angle
  v8 = Float64[1.0   0.05   2.0   1.0   1.0   1.0   1.5   .0001   .5   .5   .1   1.05;
               0.0   0.05   2.0   1.0   1.0  -1.0   1.5   .0001   .5   .5   .1   1.05;
               0.0   0.05   2.0   1.0   1.0   1.0   1.5   .0001   .5   .5   .1   1.05;
               0.0   0.05   2.0   1.0   1.0   1.0   1.5   .0001   .5   .5   .1   1.05]

# 1st row: Color of this cell ("ro" red,"bo" blue,"mo" magenta,"go" green) Not used in command line version due to lack of display.
# 2nd row: Are those type of cell located at the left at the beggining?
# 3rd row: Are those kind of cell stem cells? (Only the three first lign can answer true)
# 4th row: Should those cell stick to the source?
  v9 = ["ro"    false    true     false;
        "bo"    false    false    false;
        "mo"    false    false    false;
        "go"    false    false    false]
  
#####################################################################################################################################################
# Do not change the below.



# First window parameter
global nb_ligands = 8
global nb_source = number_of_sources  
global type_source =type_of_source
global type_diffusion = type_of_diffusion
# Source type
global source_abscisse_ligand = Array(Float64, nb_source)
global source_abscisse_ligand = x_ordinate_sources
global source_ordinate_ligand = Array(Float64, nb_source)
global source_ordinate_ligand = y_ordinate_sources
# Integrative
global Diffusion_coefficient = Array(Float64, nb_source)
global Diffusion_coefficient = integrative_gradient_coefficient
global A_coefficient = Array(Float64, nb_source)
global A_coefficient = integrative_initial_concentration_coefficient
global tau0 = Array(Float64, nb_source)
global tau0 = intgerative_upper_time_limit
# Normal
global diffusion_maximum = Array(Float64, nb_source)
global diffusion_maximum = normal_initial_concentration_coefficient
global diffusion_coefficient = Array(Float64, nb_source)
global diffusion_coefficient = normal_gradient_coefficient
# Cell type
  global categories = Cell_type[
          Cell_type(v8[1,1], v8[1,2], v8[1,3], v8[1,4], v8[1,5], v8[1,6], v8[1,7], v8[1,8], v8[1,9], v8[1,10], v8[1,11], v8[1,12],
                    v9[1,1], v9[1,2], v9[1,3], v9[1, 4]),
          Cell_type(v8[2,1], v8[2,2], v8[2,3], v8[2,4], v8[2,5], v8[2,6], v8[2,7], v8[2,8], v8[2,9], v8[2,10], v8[2,11], v8[2,12], 
                    v9[2,1], v9[2,2], v9[2,3], v9[2, 4]),
          Cell_type(v8[3,1], v8[3,2], v8[3,3], v8[3,4], v8[3,5], v8[3,6], v8[3,7], v8[3,8], v8[3,9], v8[3,10], v8[3,11], v8[3,12], 
                    v9[3,1], v9[3,2], v9[3,3], v9[3, 4]),
          Cell_type(v8[4,1], v8[4,2], v8[4,3], v8[4,4], v8[4,5], v8[4,6], v8[4,7], v8[4,8], v8[4,9], v8[4,10], v8[4,11], v8[4,12], 
                    v9[4,1], v9[4,2], false, v9[4, 4])]




for i in 1 : nb_iteration
  println("Simulation: ", i)
  t = strftime(time())[5:27] # Store date and time as string
  filename = "out_$t.pickle"
  alive_cells = initial_placement(number_of_cell, categories, environment_width, environment_height)
  dead_cells = Cell[]
  simulator(alive_cells, dead_cells, categories, number_of_steps, pickle_output, filename, environment_width, environment_height, border_settings, bouncing_energy_loss_coefficient)
end

end

























