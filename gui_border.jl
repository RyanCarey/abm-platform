using Tk

function get_borders(v10)
  # Create a top level window and frames
	global w4 = Toplevel("Border Parameters", 250, 300) ## title, width, height
  global f4 = Frame(w4)
  pack(f4, expand = true, fill = "both")
  grid(canvas, 1, 2, sticky="nsew")
  behaviours = ["Reflecting","Absorbing","Killing"]

  global border_entries1 = Combobox(f4, behaviours)
  set_value(border_entries1, "Absorbing")
  global border_entries2 = Combobox(f4, behaviours)
  set_value(border_entries2, "Killing")
  global border_entries3 = Combobox(f4, behaviours)
  set_value(border_entries3, "Killing")
  global border_entries4 = Combobox(f4, behaviours)
  set_value(border_entries4, "Killing")

  println(v10)

  set_value(border_entries1, "$(v10[1])")
  set_value(border_entries2, "$(v10[2])")
  set_value(border_entries3, "$(v10[3])")
  set_value(border_entries4, "$(v10[4])")

  # Place entry fields in columns
  border_entries = [border_entries1,border_entries2,border_entries3,border_entries4]

  border_prompts = ["Left border","Lower border","Right border","Top border"]
  n = length(border_prompts)
  for i in 1:length(border_prompts)
    grid(border_entries[i],i+1,1)
    #grid(Label(f4, border_prompts[i]),i+1,1,sticky = "se")
    formlayout(border_entries[i],string(border_prompts[i],": "))
    bind(entries[i], "<Return>", destroy_cat_window)
    bind(entries[i], "<KP_Enter>", destroy_cat_window)
  end

  # Place Ok button in bottom left
  bbord = Button(f4, "Ok")  
  bind(bbord, "command", path -> destroy_border_window(v10))
  formlayout(bbord, nothing)

  if !isinteractive()
    while true
      a = readline(STDIN)
      if a == "exit"
        return
      end
    end
  end
end

# Function to get values and destroy window upon clicking OK
function destroy_border_window(v10)
  check_border_entries(v10)
  destroy(w4)
end

# Function to collect values.
function check_border_entries(v10)
  v10[1] = get_value(border_entries1)
  v10[2] = get_value(border_entries2)
  v10[3] = get_value(border_entries3)
  v10[4] = get_value(border_entries4)
end
