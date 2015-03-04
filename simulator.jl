function simulator(alive_cells::Array, 
                  dead_cells::Array, 
                  steps::Int,
                  display_output::Bool,
                  pickle_output::Bool,
                  filename::String)
  global iter
  global negative_distance = 0
  for i = 1:steps
    iter = i
    if length(alive_cells) == 0
      println("All cells have died after $i iterations")
      break
    end

    index = rand(1 : length(alive_cells))
    # Does all cell functions
    # First checks to see if the cell dies; if not, it moves, grows, and if necessary divides
    cell_died = false
    alive_cells, dead_cells, cell_died = chance_to_die(alive_cells, dead_cells, index)
    if !cell_died
      dying_indices = Int[]
    	dying_indices = move_any!(dying_indices)
      dying_indices = sort([j for j in Set(dying_indices)])
      while length(dying_indices) > 0
        cell_death(alive_cells, dead_cells, pop!(dying_indices))
        cell_died = true
      end
    end
    if !cell_died
    	alive_cells = cell_growth!(alive_cells, index)
    	alive_cells = division_decision!(alive_cells, index)
    end
    if display_output
      show_sim(alive_cells)
    end
    # for speed, it will be necessary to batch these outputs in groups of 100+
    if i % 100 == 0
      println("$i iterations completed")
      if pickle_output
        pickle_out(filename, i, alive_cells, dead_cells)
      end
    end
   #pause(0)
  end
  if pickle_output
    pickle_out(filename, steps, alive_cells, dead_cells)
  end
  println("simulation finished")
end
