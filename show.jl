
function show_sim(canvas::Tk.Canvas, cells::Vector{Cell}, 
                     categories::Vector{Cell_type}, x_size::Float64, y_size::Float64)
  # Displays four types of cells, using each cells radius and the colour specified by its type
  locations1 = zeros(length(cells), 3)
  for i in 1 : length(cells)
    if cells[i].cell_type == 1
      locations1[i,:] = [cells[i].x cells[i].y cells[i].r]
    end
  end
  p1 = scatter(locations1[:, 1], locations1[:, 2], locations1[:, 3].*70/sqrt(y_size*x_size)
               * max(x_size/y_size,y_size/x_size)^.10, categories[1].colour)
  xlim(0, x_size)
  ylim(0, y_size)
  hold(true) 
  locations2 = zeros(length(cells), 3)
  for i in 1 : length(cells)
    if cells[i].cell_type == 2
      locations2[i,:] = [cells[i].x cells[i].y cells[i].r]
    end
  end
  p2 = scatter(locations2[:, 1], locations2[:, 2], locations2[:, 3].*70/sqrt(y_size*x_size)
               * max(x_size/y_size,y_size/x_size)^.10, categories[2].colour)
  hold(true)
  locations3 = zeros(length(cells), 3)
  for i in 1 : length(cells)
    if cells[i].cell_type == 3
      locations3[i,:] = [cells[i].x cells[i].y cells[i].r]
    end
  end
  p3 = scatter(locations3[:, 1], locations3[:, 2], locations3[:, 3].*70/sqrt(y_size*x_size)
               * max(x_size/y_size,y_size/x_size)^.10, categories[3].colour)
  hold(true)
  locations4 = zeros(length(cells), 3)
  for i in 1 : length(cells)
    if cells[i].cell_type == 4
      locations4[i,:] = [cells[i].x cells[i].y cells[i].r]
    end
  end
  p4 = scatter(locations4[:, 1], locations4[:, 2], locations4[:, 3].*70/sqrt(y_size*x_size)
               * max(x_size/y_size,y_size/x_size)^.10, categories[4].colour)
  hold(true)
  display(canvas, p1)
  display(canvas, p2)
  display(canvas, p3)
  display(canvas, p4)  
  hold(true)
  #hold(true)
  hold(false)
end

