include("import_run.jl")
function run_sim(nb_iteration::Int64; load = "")

  # The user can manually change the parameters below
  ################################################################################################################################
  # Parameters from the main menu:
  number_of_cells = 20
  steps = 3000
  environment_width = 30
  environment_height = 30
  bouncing_energy_loss_coefficient = 0.9 # (0-1)
  type_of_diffusion = "Integrative" # "Integrative" or "Normal"
  pickle_output = true
  pickle_interval = 250      # the interval at which pickle outputs are stored (must be an integer)
  border_settings = ["Reflecting", "Removing", "Removing", "Removing"]   # W, E, S, N borders
                                                                         # can be: "Reflecting", "Absorbing" or "Removing"

  # Parameters from the diffusion window:
  number_of_ligand_receptors = 8
  number_of_sources = 1
  type_of_source = "Triangle" # "Line" or "Point"

  # Choice of source parameters (coefficients and locations)

  # Array initialization: each row (of the table made by the following parameters) corresponds to a particular source
  x_ordinate_sources = Array(Float64, number_of_sources)
  y_ordinate_sources = Array(Float64, number_of_sources)
  normal_gradient_coefficient = Array(Float64, number_of_sources)
  normal_initial_concentration_coefficient = Array(Float64, number_of_sources)
  integrative_gradient_coefficient = Array(Float64, number_of_sources)
  integrative_initial_concentration_coefficient = Array(Float64, number_of_sources)
  intgerative_upper_time_limit = Array(Float64, number_of_sources)

  # The number of sources and the type of diffusion.
  # First case : type_of_source = "Line"
  # If sustained ligand production is desired, enter the desired characteristics for each source here.
  # For more than one source, copy and paste the following 5 lines and replace [1] with [2] etc.
    
      x_ordinate_sources[1] = 0
      y_ordinate_sources[1] = 0
      integrative_gradient_coefficient[1] = 100
      integrative_initial_concentration_coefficient[1] = 9
      intgerative_upper_time_limit[1] = 3000
    
  # If instantaneous pulse of ligand (Dirac) is desired, comment out the above lines and uncomment the following 4.
  # For more than one source, copy and paste the following 4 lines and replace [1] with [2] etc.
    
  #    x_ordinate_sources[1] = 0
  #    y_ordinate_sources[1] = 0
  #    normal_gradient_coefficient[1] = 1
  #    normal_initial_concentration_coefficient[1] = 100
    
  # Choice of cell type characteristics

  # The user can manually change parameters in the table below. Each row describes one cell type.
  # 1: The proportion of cells that are initialised to each type
  # 2: Growth rate
  # 3: The size at which cells divide
  # 4: Average speed for the given cell type
  # 5: Average radius for the given cell type
  # 6: Response to ligand. If 1, the cell is attracted to ligand. If -1, it is repelled
  # 7: Minimum detectable level of ligand
  # 8: Death rate
  # 9: Persistence. The proportion of the time that the cell moves in the same direction as previously.
  # 10: Randomness. The proportion of the time that the cell moves in a random direction
  # 11: Speed threshold that the cell needs to exceed to push another cell
  # 12: Minimum ratio between max and mean concentration that a cell can detect (for deciding its movement)
  #               1      2     3     4     5     6     7      8      9   10   11    12
    v8 = Float64[1.0   0.10   2.0   0.5   0.5   1.0    1    .0001   .50  .25  .1   1.00;    #Cell type 1
                 0.0   0.05   2.0   1.0   1.0  -1.0   0.0   .0001   .0   1.0  .1   1.00;    #Cell type 2
                 0.0   0.05   2.0   1.0   1.0   1.0   0.0   .0001   .5   .5   .1   1.00;    #Cell type 3
                 0.0   0.05   2.0   1.0   1.0   1.0   0.0   .0001   .5   .5   .1   1.00]    #Cell type 4

  # 1st column: Color of this cell ("ro" red,"bo" blue,"mo" magenta,"go" green) Not used in command line version due to lack of display.
  # 2st column: Are this type of cell located at the left at the beginning?
  # 3st column: Are this type of cell stem cells? (each row produces cells of the line below so the last line *must* not be set to false)
  # 4st column: Does this type of cell slow down when it reaches a high concentration of ligand?
    v9 = ["ro"    true     false    false;
          "bo"    false    false    false;
          "mo"    false    false    false;
          "go"    false    false    false]
    
    # Optional Presets
    # To create your own, copy and paste everything within the if statement below, and edit.
    if load == "random_niche_sim"
      number_of_cells = 10
      steps = 5000
      environment_width = 30
      environment_height = 30
      bouncing_energy_loss_coefficient = 0.9 # (0-1)
      #type_of_diffusion = "Integrative" # "Integrative" or "Normal"
      pickle_output = true
      border_settings = ["Absorbing", "Absorbing", "Absorbing", "Removing"]
      number_of_ligand_receptors = 8
      number_of_sources = 1
      type_of_source = "Triangle" # "Line" or "Point"
      x_ordinate_sources[1] = 0
      y_ordinate_sources[1] = 0
      integrative_gradient_coefficient[1] = 100
      integrative_initial_concentration_coefficient[1] = 1
      intgerative_upper_time_limit[1] = 5000
      v8 = Float64[1.0   0.10   2.0   1.0   1.0   1.0   25.0  .0001   .2   1.   .1   1.00;
                   0.0   0.20   2.0   2.0   1.0  -1.0   0.0   .0001   .5   1.0   .1   1.00;
                   0.0   0.05   2.0   1.0   1.0   1.0   0.0   .0001   .5   .5   .1   1.00;
                   0.0   0.05   2.0   1.0   1.0   1.0   0.0   .0001   .5   .5   .1   1.00]
      v9 = ["ro"    true    true    false;
            "bo"    false    false    false;
            "mo"    false    false    false;
            "go"    false    false    false]
    end

    if load == "niche_sim"
      number_of_cells = 10
      steps = 5000
      environment_width = 30
      environment_height = 30
      bouncing_energy_loss_coefficient = 0.9 # (0-1)
      #type_of_diffusion = "Integrative" # "Integrative" or "Normal"
      pickle_output = true
      border_settings = ["Absorbing", "Absorbing", "Absorbing", "Removing"]
      number_of_ligand_receptors = 8
      number_of_sources = 1
      type_of_source = "Triangle" # "Line" or "Point"
      x_ordinate_sources[1] = 0
      y_ordinate_sources[1] = 0
      integrative_gradient_coefficient[1] = 100
      integrative_initial_concentration_coefficient[1] = 1
      intgerative_upper_time_limit[1] = 5000
      v8 = Float64[1.0   0.10   2.0   1.0   1.0   1.0   25.0  .0001   .2   .7   .1   1.00;
                   0.0   0.20   2.0   2.0   1.0  -1.0   0.0   .0001   .5   1.0   .1   1.00;
                   0.0   0.05   2.0   1.0   1.0   1.0   0.0   .0001   .5   .5   .1   1.00;
                   0.0   0.05   2.0   1.0   1.0   1.0   0.0   .0001   .5   .5   .1   1.00]
      v9 = ["ro"    true    true    false;
            "bo"    false    false    false;
            "mo"    false    false    false;
            "go"    false    false    false]
    end

    if load == "migrate_non_random"
      number_of_cells = 50
      steps = 3000
      environment_width = 30
      environment_height = 30
      bouncing_energy_loss_coefficient = 0.9 # (0-1)
      type_of_diffusion = "Integrative" # "Integrative" or "Normal"
      pickle_output = true
      border_settings = ["Removing", "Removing", "Removing", "Removing"]
      number_of_ligand_receptors = 8
      number_of_sources = 1
      type_of_source = "Line" # "Line" or "Point"
      x_ordinate_sources[1] = 15
      y_ordinate_sources[1] = 0
      integrative_gradient_coefficient[1] = 100
      integrative_initial_concentration_coefficient[1] = 1
      intgerative_upper_time_limit[1] = 3000
      v8 = Float64[1.0   0.00   2.0   1.0   0.5   1.0   0.0   .0000   .3   1.   .1   1.00;
                   0.0   0.05   2.0   1.0   1.0  -1.0   0.0   .0001   .5   .5   .1   1.00;
                   0.0   0.05   2.0   1.0   1.0   1.0   0.0   .0001   .5   .5   .1   1.00;
                   0.0   0.05   2.0   1.0   1.0   1.0   0.0   .0001   .5   .5   .1   1.00]
      v9 = ["ro"    false    false    false;
            "bo"    false    false    false;
            "mo"    false    false    false;
            "go"    false    false    false]
    end
    if load == "migrate_random"
      number_of_cells = 50
      steps = 3000
      environment_width = 30
      environment_height = 30
      bouncing_energy_loss_coefficient = 0.9 # (0-1)
      type_of_diffusion = "Integrative" # "Integrative" or "Normal"
      pickle_output = true
      border_settings = ["Removing", "Removing", "Removing", "Removing"]
      number_of_ligand_receptors = 8
      number_of_sources = 1
      type_of_source = "Line" # "Line" or "Point"
      x_ordinate_sources[1] = 15
      y_ordinate_sources[1] = 0
      integrative_gradient_coefficient[1] = 100
      integrative_initial_concentration_coefficient[1] = 1
      intgerative_upper_time_limit[1] = 3000
      v8 = Float64[1.0   0.00   2.0   1.0   0.5   1.0   0.0   .0000   .5   1.0  .1   1.00;
                   0.0   0.05   2.0   1.0   1.0  -1.0   0.0   .0001   .5   .5   .1   1.00;
                   0.0   0.05   2.0   1.0   1.0   1.0   0.0   .0001   .5   .5   .1   1.00;
                   0.0   0.05   2.0   1.0   1.0   1.0   0.0   .0001   .5   .5   .1   1.00]
      v9 = ["ro"    false    false    true;
            "bo"    false    false    false;
            "mo"    false    false    false;
            "go"    false    false    false]
    end
    if load == "stem"
      number_of_cells = 20
      steps = 3000
      environment_width = 30
      environment_height = 30
      bouncing_energy_loss_coefficient = 0.9 # (0-1)
      type_of_diffusion = "Integrative" # "Integrative" or "Normal"
      pickle_output = true
      border_settings = ["Reflecting", "Removing", "Removing", "Removing"]
      number_of_ligand_receptors = 8
      number_of_sources = 1
      type_of_source = "Line" # "Line" or "Point"
      x_ordinate_sources[1] = 0
      y_ordinate_sources[1] = 0
      integrative_gradient_coefficient[1] = 100
      integrative_initial_concentration_coefficient[1] = 1
      intgerative_upper_time_limit[1] = 3000
      v8 = Float64[1.0   0.10   2.0   1.0   0.5   1.0    1    .0001   .5   .33  .1   1.00;
                   0.0   0.25   2.0   1.0   0.5  -1.0   0.0   .0001   .5   1.0  .1   1.00;
                   0.0   0.05   2.0   1.0   1.0   1.0   0.0   .0001   .5   .5   .1   1.00;
                   0.0   0.05   2.0   1.0   1.0   1.0   0.0   .0001   .5   .5   .1   1.00]
      v9 = ["ro"    true     true     false;
            "bo"    false    false    false;
            "mo"    false    false    false;
            "go"    false    false    false]
    end
  #####################################################################################################################
  # Don't change below unless you know what you're doing

  # First window parameter
  global n_receptors = number_of_ligand_receptors
  global nb_source = number_of_sources  
  global type_source = type_of_source
  global type_diffusion = type_of_diffusion
  # Source type
  global source_x_ord = Array(Float64, nb_source)
  global source_x_ord = x_ordinate_sources
  global source_y_ord = Array(Float64, nb_source)
  global source_y_ord = y_ordinate_sources
  # Integrative
  global integration_diffusion_coefficient = Array(Float64, nb_source)
  global integration_diffusion_coefficient = integrative_gradient_coefficient
  global A_coefficients = Array(Float64, nb_source)
  global A_coefficients = integrative_initial_concentration_coefficient
  global tau0 = Array(Float64, nb_source)
  global tau0 = intgerative_upper_time_limit
  # Normal
  global diffusion_maximum = Array(Float64, nb_source)
  global diffusion_maximum = normal_initial_concentration_coefficient
  global diffusion_coefficients = Array(Float64, nb_source)
  global diffusion_coefficients = normal_gradient_coefficient
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

  filenames = []
  for i in 1 : nb_iteration
    println("Simulation: ", i)
    t = strftime(time())[5:27] # Store date and time as string
    filename = "out_$t.pickle"
    filenames = [filenames;filename]
    environment_height = convert(FloatingPoint,environment_height)
    environment_width = convert(FloatingPoint,environment_width)
    alive_cells = initial_placement(number_of_cells, categories, environment_width, environment_height)
    dead_cells = Cell[]
    simulator(alive_cells, dead_cells, categories, steps, pickle_output, filename, 
              environment_width, environment_height, border_settings, bouncing_energy_loss_coefficient,
              diffusion_coefficients, A_coefficients, pickle_interval)
  end
  println("filenames: ",filenames)
  println("v8: ",v8)
  println("v9: ",v9)
end
