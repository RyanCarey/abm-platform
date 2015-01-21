using Gtk

win = @GtkWindow("Cell Viewer")
grid = @GtkGrid()
inner_grid = @GtkGrid()
cells_field = @GtkEntry()
setproperty!(cells_field, :text, "Enter amount of cells")
x_env_field = @GtkEntry()
setproperty!(x_env_field, :text, "X size of environment")
y_env_field = @GtkEntry()
setproperty!(y_env_field, :text, "Y size of environment")
sticky_button = @GtkCheckButton("Sticky Behaviour?")
confirm_button = @GtkButton("Confirm")

img = @GtkImage("94.jpg")

grid[1, 1] = img
grid[2, 1] = inner_grid
inner_grid[1, 1] = cells_field
inner_grid[1, 2] = x_env_field
inner_grid[1, 3] = y_env_field
inner_grid[1, 4] = sticky_button
inner_grid[1, 10] = confirm_button
setproperty!(inner_grid, :column_homogeneous, true)
setproperty!(inner_grid, :column_spacing, 15)
setproperty!(inner_grid, :row_spacing, 10)

confirm_clicked = signal_connect(confirm_button, "clicked") do widget
  cells = gtk_entry_get_text(cells_field)
  println("Cells: ", cells)
end




push!(win, grid)
showall(win)
