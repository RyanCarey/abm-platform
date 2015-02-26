function simulator(alive_cells::Array, 
                  dead_cells::Array, 
                  steps::Int,
                  display_output::Bool,
                  txt_output::Bool)
  global iter
  global negative_distance = 0
  for i = 1:steps
    iter = i
    if length(alive_cells) == 0
      println("All cells have died after $i iterations")
      return alive_cells, dead_cells
    end

    index = rand(1 : length(alive_cells))
    # Does all cell functions
    # First checks to see if the cell dies; if not, it moves, grows, and if necessary divides
    cell_died = false
    alive_cells, dead_cells, cell_died = chance_to_die(alive_cells, dead_cells, index)
    if !cell_died
    	move_any!()

    #end
    #if !cell_died
    	alive_cells = cell_growth!(alive_cells, index)

    	alive_cells = division_decision!(alive_cells, index)
    end
    if display_output
      show_sim(alive_cells)
    end
    # for speed, it will be necessary to batch these outputs in groups of 100+
    if txt_output
      ## call pickle output here
    end
    if i % 1000 == 0
      println("$i iterations completed")
    end
   #pause(0)
  end
  println("simulation finished")
end
