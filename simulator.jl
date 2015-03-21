function simulator(canvas::Tk.Canvas,
                   alive_cells::Vector{Cell}, 
                   dead_cells::Vector{Cell}, 
                   categories::Vector{Cell_type},
                   steps::Int,
                   display_output::Bool,
                   pickle_output::Bool,
                   filename::ASCIIString,
                   x_size::Float64,
                   y_size::Float64,
                   border_settings::Vector{ASCIIString},
                   momentum_coefficient::Float64,
                   diffusion_coefficients::Vector{Float64},
                   A_coefficients::Vector{Float64})
  if pickle_output
    pickle_out(filename, 0, alive_cells, dead_cells)
  end
  for i = 1:steps
    iteration(alive_cells, dead_cells, categories,
             x_size, y_size, border_settings, momentum_coefficient, i,
             diffusion_coefficients, A_coefficients)
    if i % 1 == 0 || i==steps  # display every hundredth step, and the last step
      println("$i Iteration(s) Completed")
      if display_output
        show_sim(canvas, alive_cells, categories, x_size, y_size)
      end
      if pickle_output
        pickle_out(filename, i, alive_cells, dead_cells)
      end
    end
  pause(0.001) #this can be used to input a break of some milliseconds between each timestep
  end
  println("Simulation Finished")
  #println(integration_diffusion_coefficients, A_coefficients, tau0)
  #println(source_abscisse_ligand, diffusion_maximum, diffusion_coefficient, type_source, type_diffusion)
end

function iteration(alive_cells::Vector{Cell}, 
                   dead_cells::Vector{Cell}, 
                   categories::Vector{Cell_type},
                   x_size::Float64,
                   y_size::Float64,
                   border_settings::Vector{ASCIIString},
                   momentum_coefficient::Float64,
                   i::Int,
                   diffusion_coefficients::Vector{Float64},
                   A_coefficients::Vector{Float64})
  time = i/length(alive_cells)+1 # to make diffusion and cell movement happen on the same timescale
  finished = false
  if length(alive_cells) == 0
    println("All cells have died after $i iterations")
    finished = true
  end
  index = rand(1 : length(alive_cells))
  if !finished
    alive_cells, dead_cells, finished = chance_to_die(alive_cells, dead_cells, categories, index)
  end
  if !finished
    dying_indices = Int[]
    dying_indices, concentrations = move!(alive_cells, categories, dying_indices, index, x_size, y_size, 
                                          border_settings, time,momentum_coefficient, diffusion_coefficients,
                                          A_coefficients)
    dying_indices = sort([j for j in Set(dying_indices)])
    while length(dying_indices) > 0
      cell_death(alive_cells, dead_cells, pop!(dying_indices))
      finished = true
    end
  end
  if !finished
    alive_cells = cell_growth!(alive_cells, categories, index, x_size, y_size)
    alive_cells = division_decision!(alive_cells, categories, index, x_size, y_size, concentrations)
  end
end

##########################################################################################################
function simulator(alive_cells::Vector{Cell}, 
                   dead_cells::Vector{Cell}, 
                   categories::Vector{Cell_type},
                   steps::Int,
                   pickle_output::Bool,
                   filename::ASCIIString,
                   x_size::Float64,
                   y_size::Float64,
                   border_settings::Vector{ASCIIString},
                   momentum_coefficient::Float64,
                   diffusion_coefficients::Vector{Float64},
                   A_coefficients::Vector{Float64},
                   pickle_interval::Int)
  if pickle_output
    pickle_out(filename, 0, alive_cells, dead_cells)
  end
  for i = 1:steps
    iteration(alive_cells, dead_cells, categories,
             x_size, y_size, border_settings, momentum_coefficient, i,
             diffusion_coefficients, A_coefficients)
    if i % pickle_interval == 0 || i==steps  # display every pickle_interval steps, and display the last step
      println("$i Iteration(s) Completed")
      if pickle_output
        pickle_out(filename, i, alive_cells, dead_cells)
      end
    end
  #pause(0) #this can be used to input a break of some milliseconds between each timestep
  end
  println("Simulation Finished")
  #println(integration_diffusion_coefficients, A_coefficients, tau0)
  #println(source_abscisse_ligand, diffusion_maximum, diffusion_coefficient, type_source, type_diffusion)
end
