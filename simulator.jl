function simulator(canvas::Tk.Canvas,
                   alive_cells::Vector{Cell}, 
                   dead_cells::Vector{Cell}, 
                   categories::Vector{Cell_type},
                   steps::Int,
                   display_output::Bool,
                   pickle_output::Bool,
                   filename::ASCIIString,
                   x_size::Real,
                   y_size::Real,
                   border_settings::Vector{ASCIIString},
		   g::Real)

  global negative_distance = 0
  for i = 1:steps
    if length(alive_cells) == 0
      println("All cells have died after $i iterations")
      break
    end
    time = i/length(alive_cells)+1 # We divide the step number by the number of cell in order to put the diffusion and the cell movement on the same basis

    index = rand(1 : length(alive_cells))

    # First check if the cell dies; if not, move, grow, and divide if appropriate
    cell_died = false
    alive_cells, dead_cells, cell_died = chance_to_die(alive_cells, dead_cells, categories, index)
    if !cell_died
      dying_indices = Int[]
      dying_indices, concentrations = move!(alive_cells, categories, dying_indices, index, x_size, y_size, border_settings, time,g)
      dying_indices = sort([j for j in Set(dying_indices)])
      while length(dying_indices) > 0
        cell_death(alive_cells, dead_cells, pop!(dying_indices))
        cell_died = true
      end
    end
    if !cell_died
      alive_cells = cell_growth!(alive_cells, categories, index, x_size, y_size)
      alive_cells = division_decision!(alive_cells, categories, index, x_size, y_size, concentrations)
    end

    if display_output
      show_sim(canvas, alive_cells, categories, x_size, y_size)
    end
    # for speed, it will be necessary to batch these outputs in groups of 100+
    if i % 100 == 0
      println("$i Iterations Completed")
      if display_output
        show_sim(canvas, alive_cells, categories, x_size, y_size)
      end
      if pickle_output
        pickle_out(filename, i, alive_cells, dead_cells)
      end
    end
   #pause(0)
  end
  if pickle_output
    pickle_out(filename, steps, alive_cells, dead_cells)
  end
  println("Simulation Finished")
end

##########################################################################################################
function simulator(alive_cells::Vector{Cell}, 
                   dead_cells::Vector{Cell}, 
                   categories::Vector{Cell_type},
                   steps::Int,
                   pickle_output::Bool,
                   filename::ASCIIString,
                   x_size::Real,
                   y_size::Real,
                   border_settings::Vector{ASCIIString},
		   g::Real)

  global negative_distance = 0
  for i = 1:steps
    if length(alive_cells) == 0
      println("All cells have died after $i iterations")
      break
    end

    time = i/length(alive_cells)+1 # We divide the step number by the number of cell in order to put the diffusion and the cell movement on the same basis

    index = rand(1 : length(alive_cells))

    # First check if the cell dies; if not, move, grow, and divide if appropriate
    cell_died = false
    alive_cells, dead_cells, cell_died = chance_to_die(alive_cells, dead_cells, categories, index)
    if !cell_died
      dying_indices = Int[]
      dying_indices, concentrations = move!(alive_cells, categories, dying_indices, index, x_size, y_size, border_settings, time,g)
      dying_indices = sort([j for j in Set(dying_indices)])
      while length(dying_indices) > 0
        cell_death(alive_cells, dead_cells, pop!(dying_indices))
        cell_died = true
      end
    end
    if !cell_died
      alive_cells = cell_growth!(alive_cells, categories, index, x_size, y_size)
      alive_cells = division_decision!(alive_cells, categories, index, x_size, y_size, concentrations)
    end

    # for speed, it will be necessary to batch these outputs in groups of 100+
    if i % 100 == 0
      println("$i Iterations Completed")
      if pickle_output
        pickle_out(filename, i, alive_cells, dead_cells)
      end
    end
   #pause(0)
  end
  if pickle_output
    pickle_out(filename, steps, alive_cells, dead_cells)
  end
  println("Simulation Finished")
end
